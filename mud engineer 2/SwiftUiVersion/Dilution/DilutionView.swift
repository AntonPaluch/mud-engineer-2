import SwiftUI

// MARK: - Focus fields
private enum DilutionField: Hashable {
    case startVolume
    case startDensity
    case addedVolume
    case addedDensity
}

private struct DilutionModel: Codable, Equatable {
    var startVolume: String
    var startDensity: String
    var addedVolume: String
    var addedDensity: String

    static let empty = DilutionModel(
        startVolume: "",
        startDensity: "",
        addedVolume: "",
        addedDensity: ""
    )
}

private final class DilutionStorage {
    private let userDefaults = UserDefaults.standard
    private let storageKey = "DilutionData"

    func loadData() -> DilutionModel {
        guard let data = userDefaults.data(forKey: storageKey),
              let model = try? JSONDecoder().decode(DilutionModel.self, from: data) else {
            return .empty
        }
        return model
    }

    func saveData(_ model: DilutionModel) {
        guard model != .empty else {
            userDefaults.removeObject(forKey: storageKey)
            return
        }

        do {
            let data = try JSONEncoder().encode(model)
            userDefaults.set(data, forKey: storageKey)
        } catch {
            print("Ошибка при сохранении разбавления: \(error)")
        }
    }

    func reset() {
        userDefaults.removeObject(forKey: storageKey)
    }
}

private final class DilutionViewModel: ObservableObject {
    @Published private(set) var model: DilutionModel
    private let storage = DilutionStorage()

    init() {
        model = storage.loadData()
    }

    func update(with model: DilutionModel) {
        self.model = model
        storage.saveData(model)
    }

    func reset() {
        model = .empty
        storage.reset()
    }
}

struct DilutionView: View {
    @EnvironmentObject private var themeSettings: ThemeSettings
    @EnvironmentObject private var unitSettings: UnitSettings
    @EnvironmentObject private var navigationCoordinator: NavigationCoordinator
    
    @FocusState private var focusedField: DilutionField?
    @StateObject private var viewModel = DilutionViewModel()
    
    @State private var localModel = DilutionModel.empty
    @State private var showResetAlert = false
    
    private var textColor: Color {
        themeSettings.isDarkModeEnabled ? ThemeColors.lightText : ThemeColors.darkText
    }

    private var secondaryTextColor: Color {
        themeSettings.isDarkModeEnabled ? ThemeColors.lightText.opacity(0.7) : ThemeColors.darkText.opacity(0.7)
    }

    private var cardColor: Color {
        themeSettings.isDarkModeEnabled ? ThemeColors.darkBackgroundSubView : ThemeColors.lightBackgroundSubView
    }

    private var backgroundColor: Color {
        themeSettings.isDarkModeEnabled ? ThemeColors.darkBackground : ThemeColors.lightBackground
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

                ScrollView {
                    VStack(alignment: .leading, spacing: 26) {
                        DilutionInputSection(
                            title: L10n.tr("swiftui.sourceMud"),
                            firstLabel: L10n.tr("swiftui.volume"),
                            firstUnit: unitSettings.system.volumeUnit,
                            secondLabel: L10n.tr("swiftui.density"),
                            secondUnit: unitSettings.system.densityUnit,
                            firstField: .startVolume,
                            secondField: .startDensity,
                            firstValue: $localModel.startVolume,
                            secondValue: $localModel.startDensity,
                            focusedField: $focusedField
                        )
                        .padding(.horizontal, 25)
                        
                        DilutionInputSection(
                            title: L10n.tr("swiftui.addedMud"),
                            firstLabel: L10n.tr("swiftui.volume"),
                            firstUnit: unitSettings.system.volumeUnit,
                            secondLabel: L10n.tr("swiftui.density"),
                            secondUnit: unitSettings.system.densityUnit,
                            firstField: .addedVolume,
                            secondField: .addedDensity,
                            firstValue: $localModel.addedVolume,
                            secondValue: $localModel.addedDensity,
                            focusedField: $focusedField
                        )
                        .padding(.horizontal, 25)
                        
                        ResultCard(
                            resultVolume: formattedVolume,
                            resultDensity: formattedDensity,
                            volumeUnit: unitSettings.system.volumeUnit,
                            densityUnit: unitSettings.system.densityUnit,
                            isReady: resultsAvailable,
                            textColor: textColor,
                            secondaryTextColor: secondaryTextColor,
                            cardColor: cardColor
                        )
                        .frame(maxWidth: .infinity)
                        .padding(.top, 6)
                    }
                    .padding(.top, 24)
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
            viewModel.reset()
        }
        .onDisappear {
            saveLocalModel()
        }
        .alert(L10n.tr("swiftui.resetData.title"), isPresented: $showResetAlert) {
            Button(L10n.tr("swiftui.cancel"), role: .cancel) {}
            Button(L10n.tr("swiftui.reset"), role: .destructive) {
                resetDilution()
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
        Text(L10n.tr("dilutionFluid"))
            .font(.system(size: 22, weight: .semibold))
            .foregroundColor(textColor)
    }
    
    // MARK: - Calculation
    
    private var resultsAvailable: Bool {
        guard let startVolumeValue,
              let startDensityValue,
              let addedVolumeValue,
              let addedDensityValue else {
            return false
        }

        return startVolumeValue > 0 &&
        startDensityValue > 0 &&
        addedVolumeValue > 0 &&
        addedDensityValue > 0 &&
        totalVolumeValue > 0
    }
    
    private var startVolumeValue: Double? {
        parse(localModel.startVolume).map(unitSettings.system.volumeToCubicMeters)
    }

    private var startDensityValue: Double? {
        parse(localModel.startDensity).map(unitSettings.system.densityToGramPerCubicCentimeter)
    }

    private var addedVolumeValue: Double? {
        parse(localModel.addedVolume).map(unitSettings.system.volumeToCubicMeters)
    }

    private var addedDensityValue: Double? {
        parse(localModel.addedDensity).map(unitSettings.system.densityToGramPerCubicCentimeter)
    }
    
    private var totalVolumeValue: Double {
        guard let start = startVolumeValue, let add = addedVolumeValue else { return 0 }
        return start + add
    }
    
    private var resultDensityValue: Double? {
        guard
            resultsAvailable,
            let startV = startVolumeValue,
            let startD = startDensityValue,
            let addV = addedVolumeValue,
            let addD = addedDensityValue
        else { return nil }
        
        let numerator = (startV * startD) + (addV * addD)
        return numerator / totalVolumeValue
    }
    
    private var formattedVolume: String? {
        guard resultsAvailable else { return nil }
        let displayValue = unitSettings.system.volumeFromCubicMeters(totalVolumeValue)
        return numberFormatter(fraction: 0).string(from: NSNumber(value: displayValue))
    }
    
    private var formattedDensity: String? {
        guard let density = resultDensityValue else { return nil }
        let displayValue = unitSettings.system.densityFromGramPerCubicCentimeter(density)
        let fraction = unitSettings.system == .metric ? 3 : 1
        return numberFormatter(fraction: fraction).string(from: NSNumber(value: displayValue))
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
    
    private func nextField(for current: DilutionField?) -> DilutionField? {
        switch current {
        case .startVolume: return .startDensity
        case .startDensity: return .addedVolume
        case .addedVolume: return .addedDensity
        case .addedDensity: return .startVolume
        case .none: return .startVolume
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

    private func resetDilution() {
        localModel = .empty
        viewModel.reset()
    }
}

// MARK: - Subviews

private struct DilutionInputSection: View {
    @EnvironmentObject private var themeSettings: ThemeSettings
    
    let title: String
    let firstLabel: String
    let firstUnit: String
    let secondLabel: String
    let secondUnit: String
    let firstField: DilutionField
    let secondField: DilutionField
    
    @Binding var firstValue: String
    @Binding var secondValue: String
    
    @FocusState.Binding var focusedField: DilutionField?
    
    private var textColor: Color {
        themeSettings.isDarkModeEnabled ? ThemeColors.lightText : ThemeColors.darkText
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(textColor)
            
            DualInputField(
                firstLabel: firstLabel,
                firstUnit: firstUnit,
                secondLabel: secondLabel,
                secondUnit: secondUnit,
                firstValue: $firstValue,
                secondValue: $secondValue,
                firstField: firstField,
                secondField: secondField,
                focusedField: $focusedField
            )
        }
    }
}

private struct DualInputField: View {
    @EnvironmentObject private var themeSettings: ThemeSettings
    
    let firstLabel: String
    let firstUnit: String
    let secondLabel: String
    let secondUnit: String
    
    @Binding var firstValue: String
    @Binding var secondValue: String
    
    let firstField: DilutionField
    let secondField: DilutionField
    
    @FocusState.Binding var focusedField: DilutionField?
    
    private var textColor: Color {
        themeSettings.isDarkModeEnabled ? ThemeColors.lightText : ThemeColors.darkText
    }

    private var inputBackground: Color {
        themeSettings.isDarkModeEnabled ? ThemeColors.darkBackgroundSubView : ThemeColors.lightBackgroundSubView
    }

    private var inputBorder: Color {
        themeSettings.isDarkModeEnabled ? Color.white.opacity(0.22) : Color.gray.opacity(0.45)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(firstLabel)
                Spacer()
                Text(secondLabel)
            }
            .font(.system(size: 14, weight: .regular))
            .foregroundColor(textColor)
            
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(inputBackground)
                    .frame(height: 50)
                
                HStack(spacing: 0) {
                    HStack(spacing: 6) {
                        TextField("0", text: $firstValue)
                            .keyboardType(.decimalPad)
                            .font(.system(size: 20, weight: .regular))
                            .foregroundColor(textColor)
                            .focused($focusedField, equals: firstField)
                            .multilineTextAlignment(.leading)
                            .padding(.leading, 20)
                        
                        Text(firstUnit)
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(textColor.opacity(0.85))
                            .padding(.leading, 5)
                            .padding(.trailing, 14)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Divider()
                        .frame(width: 1, height: 50)
                        .overlay(inputBorder)
                    
                    HStack(spacing: 6) {
                        TextField("0", text: $secondValue)
                            .keyboardType(.decimalPad)
                            .font(.system(size: 20, weight: .regular))
                            .foregroundColor(textColor)
                            .focused($focusedField, equals: secondField)
                            .multilineTextAlignment(.leading)
                            .padding(.leading, 20)
                        
                        Text(secondUnit)
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(textColor.opacity(0.85))
                            .padding(.trailing, 20)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(inputBorder, lineWidth: 1)
            )
        }
    }
}

private struct ResultCard: View {
    let resultVolume: String?
    let resultDensity: String?
    let volumeUnit: String
    let densityUnit: String
    let isReady: Bool
    let textColor: Color
    let secondaryTextColor: Color
    let cardColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(L10n.tr("swiftui.dilution.resultTitle"))
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(textColor)
            
            if isReady, let volume = resultVolume, let density = resultDensity {
                VStack(alignment: .leading, spacing: 12) {
                    resultRow(title: L10n.tr("swiftui.finalVolume"), value: "\(volume) \(volumeUnit)")
                    resultRow(title: L10n.tr("swiftui.dilution.finalDensity"), value: "\(density) \(densityUnit)")
                }
            } else {
                Text(L10n.tr("swiftui.fillAllFields"))
                    .font(.system(size: 14))
                    .foregroundColor(secondaryTextColor)
                    .padding(.top, 4)
            }

            Spacer(minLength: 0)
        }
        .frame(
            maxWidth: .infinity,
            minHeight: UIScreen.main.bounds.height * 0.62,
            alignment: .topLeading
        )
        .padding(.horizontal, 25)
        .padding(.top, 34)
        .padding(.bottom, 36)
        .background(cardColor)
        .cornerRadius(28, corners: [.topLeft, .topRight])
    }
    
    private func resultRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 15))
                .foregroundColor(secondaryTextColor)
            Spacer()
            Text(value)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(textColor)
        }
    }
}

// MARK: - Focus helper

struct DilutionView_Previews: PreviewProvider {
    static var previews: some View {
        DilutionView()
            .environmentObject(ThemeSettings())
            .environmentObject(UnitSettings())
            .environmentObject(NavigationCoordinator())
    }
}
