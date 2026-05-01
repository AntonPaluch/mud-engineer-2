import SwiftUI

private enum WeightingField: Hashable {
    case volume
    case startDensity
    case finishDensity
}

private struct WeightingModel: Codable, Equatable {
    var volume: String
    var startDensity: String
    var finishDensity: String
    var componentDensity: Double

    static let empty = WeightingModel(
        volume: "",
        startDensity: "",
        finishDensity: "",
        componentDensity: WeightComponents.barit.rawValue
    )
}

private final class WeightingStorage {
    private let userDefaults = UserDefaults.standard
    private let storageKey = "WeightingData"

    func loadData() -> WeightingModel {
        guard let data = userDefaults.data(forKey: storageKey),
              let model = try? JSONDecoder().decode(WeightingModel.self, from: data) else {
            return .empty
        }
        return model
    }

    func saveData(_ model: WeightingModel) {
        guard model != .empty else {
            userDefaults.removeObject(forKey: storageKey)
            return
        }

        do {
            let data = try JSONEncoder().encode(model)
            userDefaults.set(data, forKey: storageKey)
        } catch {
            print("Ошибка при сохранении утяжеления: \(error)")
        }
    }

    func reset() {
        userDefaults.removeObject(forKey: storageKey)
    }
}

private final class WeightingViewModel: ObservableObject {
    @Published private(set) var model: WeightingModel
    private let storage = WeightingStorage()

    init() {
        model = storage.loadData()
    }

    func update(with model: WeightingModel) {
        self.model = model
        storage.saveData(model)
    }

    func reset() {
        model = .empty
        storage.reset()
    }
}

struct WeightingView: View {
    @EnvironmentObject private var themeSettings: ThemeSettings
    @EnvironmentObject private var unitSettings: UnitSettings
    @EnvironmentObject private var navigationCoordinator: NavigationCoordinator

    @FocusState private var focusedField: WeightingField?
    @StateObject private var viewModel = WeightingViewModel()
    private let calculator = CalculationManager()

    @State private var localModel = WeightingModel.empty
    @State private var isComponentPickerExpanded = false
    @State private var showResetAlert = false

    private var textColor: Color {
        themeSettings.isDarkModeEnabled ? ThemeColors.lightText : ThemeColors.darkText
    }

    private var secondaryTextColor: Color {
        themeSettings.isDarkModeEnabled ? ThemeColors.lightText.opacity(0.8) : ThemeColors.darkText.opacity(0.8)
    }

    private var cardColor: Color {
        themeSettings.isDarkModeEnabled ? ThemeColors.darkBackgroundSubView : ThemeColors.lightBackgroundSubView
    }

    private var backgroundColor: Color {
        themeSettings.isDarkModeEnabled ? ThemeColors.darkBackground : ThemeColors.lightBackground
    }

    private var inputBackground: Color {
        themeSettings.isDarkModeEnabled ? ThemeColors.darkBackgroundSubView : ThemeColors.lightBackgroundSubView
    }

    private var inputBorder: Color {
        themeSettings.isDarkModeEnabled ? Color.white.opacity(0.22) : Color(red: 0.808, green: 0.824, blue: 0.839)
    }

    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                header
                    .padding(.horizontal, 25)
                    .padding(.top, 12)

                title
                    .padding(.horizontal, 25)
                    .padding(.top, 20)

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        sourceSection
                            .padding(.top, 26)

                        weightingSection
                            .padding(.top, 34)

                        requiredDensityField
                            .padding(.top, 20)

                        resultCard
                            .padding(.top, 40)
                    }
                    .padding(.horizontal, 25)
                    .padding(.bottom, 0)
                }
                .ignoresSafeArea(.container, edges: .bottom)
            }
        }
        .navigationBarHidden(true)
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                HStack {
                    Button(L10n.tr("swiftui.next")) { focusNext() }
                    Spacer()
                    Button(L10n.tr("swiftui.done")) {
                        saveLocalModel()
                        focusedField = nil
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .onAppear {
            localModel = viewModel.model
        }
        .onChange(of: unitSettings.resetVersion) { _ in
            localModel = .empty
            isComponentPickerExpanded = false
            viewModel.reset()
        }
        .onDisappear {
            saveLocalModel()
        }
        .alert(L10n.tr("swiftui.resetData.title"), isPresented: $showResetAlert) {
            Button(L10n.tr("swiftui.cancel"), role: .cancel) {}
            Button(L10n.tr("swiftui.reset"), role: .destructive) {
                resetWeighting()
            }
        } message: {
            Text(L10n.tr("swiftui.resetData.message"))
        }
    }

    private var header: some View {
        HStack {
            Button(action: {
                navigationCoordinator.pop()
            }) {
                Image(themeSettings.isDarkModeEnabled ? "backButtonDark" : "backButton")
                    .resizable()
                    .frame(width: 40, height: 40)
            }
            Spacer()

            resetButton
        }
    }

    private var title: some View {
        Text(L10n.tr("weighting"))
            .font(.system(size: 22, weight: .semibold))
            .foregroundColor(textColor)
            .frame(height: 30, alignment: .leading)
    }

    private var sourceSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(L10n.tr("swiftui.sourceMud"))
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(textColor)
                .frame(height: 20, alignment: .leading)

            HStack(spacing: 0) {
                WeightingInputCell(
                    label: L10n.tr("swiftui.volume"),
                    unit: unitSettings.system.volumeUnit,
                    value: $localModel.volume,
                    field: .volume,
                    focusedField: $focusedField,
                    corners: [.topLeft, .bottomLeft],
                    textColor: textColor,
                    background: inputBackground,
                    border: inputBorder
                )

                WeightingInputCell(
                    label: L10n.tr("swiftui.density"),
                    unit: unitSettings.system.densityUnit,
                    value: $localModel.startDensity,
                    field: .startDensity,
                    focusedField: $focusedField,
                    corners: [.topRight, .bottomRight],
                    textColor: textColor,
                    background: inputBackground,
                    border: inputBorder
                )
            }
        }
    }

    private var weightingSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(L10n.tr("swiftui.weighting.short"))
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(textColor)
                .frame(height: 20, alignment: .leading)

            VStack(alignment: .leading, spacing: 15) {
                Text(L10n.tr("swiftui.addedMaterial"))
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(secondaryTextColor)
                    .frame(height: 20, alignment: .leading)

                if isComponentPickerExpanded {
                    VStack(spacing: 0) {
                        ForEach(WeightComponents.allCases, id: \.self) { component in
                            materialOption(component)
                        }
                    }
                    .padding(5)
                    .frame(maxWidth: .infinity)
                    .background(inputBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(inputBorder, lineWidth: 1)
                    )
                } else {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.18)) {
                            isComponentPickerExpanded = true
                        }
                    }) {
                        materialRow(
                            selectedComponent,
                            isSelected: false,
                            showsDisclosure: true
                        )
                        .padding(5)
                        .background(inputBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(inputBorder, lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                    .frame(maxWidth: .infinity)
                    .contentShape(RoundedRectangle(cornerRadius: 14))
                }
            }
        }
    }

    private var requiredDensityField: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(L10n.tr("swiftui.requiredOutputDensity"))
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(secondaryTextColor)
                .frame(height: 20, alignment: .leading)

            HStack(spacing: 5) {
                TextField("0", text: $localModel.finishDensity)
                    .keyboardType(.decimalPad)
                    .font(.system(size: 20, weight: .regular))
                    .foregroundColor(textColor)
                    .focused($focusedField, equals: .finishDensity)
                    .multilineTextAlignment(.leading)

                Text(unitSettings.system.densityUnit)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(secondaryTextColor.opacity(0.75))
            }
            .frame(width: 110, height: 30)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(inputBackground)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(inputBorder, lineWidth: 1)
            )
        }
    }

    private var resultCard: some View {
        WeightingResultCard(
            weightingAgentMass: formattedWeightingAgentMass,
            finishVolume: formattedFinishVolume,
            volumeUnit: unitSettings.system.volumeUnit,
            massUnit: unitSettings.system.massUnit,
            message: validationMessage,
            isReady: resultsAvailable,
            textColor: textColor,
            secondaryTextColor: secondaryTextColor,
            cardColor: cardColor
        )
        .frame(width: UIScreen.main.bounds.width, alignment: .topLeading)
        .padding(.horizontal, -25)
    }

    private var selectedComponent: WeightComponents {
        WeightComponents.allCases.first { $0.rawValue == localModel.componentDensity } ?? .barit
    }

    private func materialOption(_ component: WeightComponents) -> some View {
        let isSelected = selectedComponent == component

        return Button(action: {
            localModel.componentDensity = component.rawValue
            withAnimation(.easeInOut(duration: 0.18)) {
                isComponentPickerExpanded = false
            }
        }) {
            materialRow(component, isSelected: isSelected, showsDisclosure: false)
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
    }

    private func materialRow(
        _ component: WeightComponents,
        isSelected: Bool,
        showsDisclosure: Bool
    ) -> some View {
        HStack(spacing: 5) {
            Text(component.displayName)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(isSelected ? .white : textColor)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text(densityLabel(for: component))
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(isSelected ? .white : secondaryTextColor)
                .multilineTextAlignment(.trailing)

            if showsDisclosure {
                Image(systemName: "chevron.down")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(secondaryTextColor)
                    .padding(.leading, 4)
            }
        }
        .frame(height: 30)
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(isSelected ? ThemeColors.buttonSettings : Color.clear)
        .contentShape(RoundedRectangle(cornerRadius: 14))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    // MARK: - Calculation

    private var volumeValue: Double? {
        parse(localModel.volume).map(unitSettings.system.volumeToCubicMeters)
    }

    private var startDensityValue: Double? {
        parse(localModel.startDensity).map(unitSettings.system.densityToGramPerCubicCentimeter)
    }

    private var finishDensityValue: Double? {
        parse(localModel.finishDensity).map(unitSettings.system.densityToGramPerCubicCentimeter)
    }

    private var resultsAvailable: Bool {
        guard
            let volumeValue,
            let startDensityValue,
            let finishDensityValue
        else { return false }

        return volumeValue > 0
            && finishDensityValue > startDensityValue
            && finishDensityValue < selectedComponent.rawValue
    }

    private var weightingAgentMassValue: Double? {
        guard
            resultsAvailable,
            let volumeValue,
            let startDensityValue,
            let finishDensityValue
        else { return nil }

        return calculator.weightingAgentMass(
            volume: volumeValue,
            startDensity: startDensityValue,
            finishDensity: finishDensityValue,
            componentDensity: selectedComponent.rawValue
        )
    }

    private var finishVolumeValue: Double? {
        guard let volumeValue, let weightingAgentMassValue else { return nil }

        return calculator.weightedMudVolume(
            volume: volumeValue,
            weightingAgentMass: weightingAgentMassValue,
            componentDensity: selectedComponent.rawValue
        )
    }

    private var formattedWeightingAgentMass: String? {
        guard let weightingAgentMassValue else { return nil }
        let displayValue = unitSettings.system.massFromKilograms(weightingAgentMassValue)
        return numberFormatter(fraction: 0).string(from: NSNumber(value: displayValue))
    }

    private var formattedFinishVolume: String? {
        guard let finishVolumeValue else { return nil }
        let displayValue = unitSettings.system.volumeFromCubicMeters(finishVolumeValue)
        return numberFormatter(fraction: 0).string(from: NSNumber(value: displayValue))
    }

    private var validationMessage: String {
        guard volumeValue != nil || startDensityValue != nil || finishDensityValue != nil else {
            return L10n.tr("swiftui.fillAllFields")
        }

        guard let volumeValue, volumeValue > 0 else {
            return L10n.tr("swiftui.enterVolumeGreaterThanZero")
        }

        guard let startDensityValue, let finishDensityValue else {
            return L10n.tr("swiftui.enterStartAndRequiredDensity")
        }

        if finishDensityValue <= startDensityValue {
            return NSLocalizedString("weieghtingEror", comment: "")
        }

        if finishDensityValue >= selectedComponent.rawValue {
            return L10n.tr("swiftui.requiredDensityLessThanMaterial")
        }

        return L10n.tr("swiftui.fillAllFields")
    }

    private func parse(_ value: String) -> Double? {
        let normalized = value
            .replacingOccurrences(of: ",", with: ".")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        guard let parsed = Double(normalized), parsed.isFinite else { return nil }
        return parsed
    }

    private func numberFormatter(fraction: Int) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = fraction
        formatter.maximumFractionDigits = fraction
        formatter.locale = Locale.current
        return formatter
    }

    private func densityLabel(for component: WeightComponents) -> String {
        let displayValue = unitSettings.system.densityFromGramPerCubicCentimeter(component.rawValue)
        let value = numberFormatter(fraction: 1).string(from: NSNumber(value: displayValue)) ?? "-"
        return "\(value) \(unitSettings.system.densityUnit)"
    }

    private func nextField(for current: WeightingField?) -> WeightingField? {
        switch current {
        case .volume: return .startDensity
        case .startDensity: return .finishDensity
        case .finishDensity: return .volume
        case .none: return .volume
        }
    }

    private func focusNext() {
        focusedField = nextField(for: focusedField)
    }

    private var resetButton: some View {
        Button(action: {
            focusedField = nil
            showResetAlert = true
        }) {
            HStack(spacing: 6) {
                Image(systemName: "arrow.counterclockwise")
                Text(L10n.tr("swiftui.reset"))
            }
            .font(.system(size: 14, weight: .semibold))
            .padding(.horizontal, 18)
            .padding(.vertical, 10)
            .background(ThemeColors.buttonSettings.opacity(themeSettings.isDarkModeEnabled ? 0.34 : 1), in: Capsule())
            .overlay(
                Capsule()
                    .stroke(ThemeColors.buttonSettings.opacity(themeSettings.isDarkModeEnabled ? 0.42 : 0.18))
            )
        }
        .applyGlassEffect()
        .foregroundColor(ThemeColors.lightText)
    }

    private func saveLocalModel() {
        viewModel.update(with: localModel)
    }

    private func resetWeighting() {
        localModel = .empty
        isComponentPickerExpanded = false
        viewModel.reset()
    }
}

private struct WeightingInputCell: View {
    let label: String
    let unit: String
    @Binding var value: String
    let field: WeightingField
    @FocusState.Binding var focusedField: WeightingField?
    let corners: UIRectCorner
    let textColor: Color
    let background: Color
    let border: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(label)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(textColor.opacity(0.8))
                .frame(height: 20, alignment: .leading)

            HStack(spacing: 5) {
                TextField("0", text: $value)
                    .keyboardType(.decimalPad)
                    .font(.system(size: 20, weight: .regular))
                    .foregroundColor(textColor)
                    .focused($focusedField, equals: field)
                    .multilineTextAlignment(.leading)

                Text(unit)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(textColor.opacity(0.6))
                    .multilineTextAlignment(.trailing)
            }
            .frame(height: 30)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(background)
            .cornerRadius(14, corners: corners)
            .overlay(
                RoundedCorner(radius: 14, corners: corners)
                    .stroke(border, lineWidth: 1)
            )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct WeightingResultCard: View {
    let weightingAgentMass: String?
    let finishVolume: String?
    let volumeUnit: String
    let massUnit: String
    let message: String
    let isReady: Bool
    let textColor: Color
    let secondaryTextColor: Color
    let cardColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 26) {
            Text(L10n.tr("swiftui.weighting.resultTitle"))
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(textColor)
                .frame(height: 20, alignment: .leading)

            if isReady, let weightingAgentMass, let finishVolume {
                VStack(alignment: .leading, spacing: 20) {
                    resultRow(title: L10n.tr("swiftui.finalVolume"), value: "\(finishVolume) \(volumeUnit)")
                    resultRow(title: L10n.tr("swiftui.weightingAgentAmount"), value: "\(weightingAgentMass) \(massUnit)")
                }
            } else {
                Text(message)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(secondaryTextColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(
            maxWidth: .infinity,
            minHeight: UIScreen.main.bounds.height * 0.48,
            alignment: .topLeading
        )
        .padding(.horizontal, 25)
        .padding(.top, 34)
        .padding(.bottom, 26)
        .background(cardColor)
        .cornerRadius(28, corners: [.topLeft, .topRight])
    }

    private func resultRow(title: String, value: String) -> some View {
        HStack(alignment: .top, spacing: 20) {
            Text(title)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(secondaryTextColor)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text(value)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(textColor)
                .multilineTextAlignment(.trailing)
        }
        .frame(height: 20)
    }
}

private extension WeightComponents {
    var displayName: String {
        switch self {
        case .mramor: return L10n.tr("swiftui.material.microcalcite")
        case .barit: return L10n.tr("swiftui.material.barite")
        case .dolomit: return L10n.tr("swiftui.material.dolomite")
        case .siderit: return L10n.tr("swiftui.material.siderite")
        }
    }
}

struct WeightingView_Previews: PreviewProvider {
    static var previews: some View {
        WeightingView()
            .environmentObject(ThemeSettings())
            .environmentObject(UnitSettings())
            .environmentObject(NavigationCoordinator())
    }
}
