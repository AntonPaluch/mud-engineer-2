import SwiftUI

// MARK: - Focus fields
private enum DilutionField: Hashable {
    case startVolume
    case startDensity
    case addedVolume
    case addedDensity
}

struct DilutionView: View {
    @EnvironmentObject private var themeSettings: ThemeSettings
    @EnvironmentObject private var navigationCoordinator: NavigationCoordinator
    
    @FocusState private var focusedField: DilutionField?
    private let feedbackGenerator = UINotificationFeedbackGenerator()
    
    @State private var startVolume = ""
    @State private var startDensity = ""
    @State private var addedVolume = ""
    @State private var addedDensity = ""
    
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
                            title: "Исходный раствор",
                            firstLabel: "Объём",
                            firstUnit: "м³",
                            secondLabel: "Плотность",
                            secondUnit: "г/см³",
                            firstField: .startVolume,
                            secondField: .startDensity,
                            firstValue: $startVolume,
                            secondValue: $startDensity,
                            focusedField: $focusedField
                        )
                        .padding(.horizontal, 25)
                        
                        DilutionInputSection(
                            title: "Добавляемый раствор",
                            firstLabel: "Объём",
                            firstUnit: "м³",
                            secondLabel: "Плотность",
                            secondUnit: "г/см³",
                            firstField: .addedVolume,
                            secondField: .addedDensity,
                            firstValue: $addedVolume,
                            secondValue: $addedDensity,
                            focusedField: $focusedField
                        )
                        .padding(.horizontal, 25)
                        
                        ResultCard(
                            resultVolume: formattedVolume,
                            resultDensity: formattedDensity,
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
                    Button("Next") { focusNext() }
                    Spacer()
                    Button("Done") { focusedField = nil }
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
    
    private var header: some View {
        HStack {
            Button(action: {
                feedbackGenerator.notificationOccurred(.success)
                navigationCoordinator.pop()
            }) {
                Image(themeSettings.isDarkModeEnabled ? "backButtonDark" : "backButton")
                    .resizable()
                    .frame(width: 40, height: 40)
            }
            Spacer()
        }
    }
    
    private var title: some View {
        Text("Разбавление раствора")
            .font(.system(size: 22, weight: .semibold))
            .foregroundColor(textColor)
    }
    
    // MARK: - Calculation
    
    private var resultsAvailable: Bool {
        startVolumeValue != nil &&
        startDensityValue != nil &&
        addedVolumeValue != nil &&
        addedDensityValue != nil &&
        totalVolumeValue > 0
    }
    
    private var startVolumeValue: Double? { parse(startVolume) }
    private var startDensityValue: Double? { parse(startDensity) }
    private var addedVolumeValue: Double? { parse(addedVolume) }
    private var addedDensityValue: Double? { parse(addedDensity) }
    
    private var totalVolumeValue: Double {
        guard let start = startVolumeValue, let add = addedVolumeValue else { return 0 }
        return start + add
    }
    
    private var resultDensityValue: Double? {
        guard
            let startV = startVolumeValue,
            let startD = startDensityValue,
            let addV = addedVolumeValue,
            let addD = addedDensityValue,
            totalVolumeValue > 0
        else { return nil }
        
        let numerator = (startV * startD) + (addV * addD)
        return numerator / totalVolumeValue
    }
    
    private var formattedVolume: String? {
        guard resultsAvailable else { return nil }
        return numberFormatter(fraction: 0).string(from: NSNumber(value: totalVolumeValue))
    }
    
    private var formattedDensity: String? {
        guard let density = resultDensityValue else { return nil }
        return numberFormatter(fraction: 3).string(from: NSNumber(value: density))
    }
    
    private func parse(_ value: String) -> Double? {
        let normalized = value.replacingOccurrences(of: ",", with: ".")
        return Double(normalized)
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
    let isReady: Bool
    let textColor: Color
    let secondaryTextColor: Color
    let cardColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Результат разбавления")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(textColor)
            
            if isReady, let volume = resultVolume, let density = resultDensity {
                VStack(alignment: .leading, spacing: 12) {
                    resultRow(title: "Конечный объём", value: "\(volume) м³")
                    resultRow(title: "Плотность после разбавления", value: "\(density) г/см³")
                }
            } else {
                Text("Заполните все поля чтобы увидеть результаты расчёта")
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

#Preview {
    DilutionView()
        .environmentObject(ThemeSettings())
        .environmentObject(NavigationCoordinator())
}
