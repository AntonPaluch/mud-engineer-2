//
//  DrillingIntervals.swift
//  mud engineer 2
//
//  Created by Dmitriy Pavlov on 16.04.2023.
//

import SwiftUI

enum DrillingIntervalType: String {
    case conductor = "Conductor"
    case production = "Production"
    case liner = "Liner"
}

struct DrillingIntervalModel: Codable, Equatable {
    var firstLength: String
    var firstDiameter: String
    var depth: String
    var bitDiameter: String
    var cavernosity: String
    var steelPipe: String
    var wallThickness: String
    var flowRate: String

    static let empty = DrillingIntervalModel(
        firstLength: "",
        firstDiameter: "",
        depth: "",
        bitDiameter: "",
        cavernosity: "",
        steelPipe: "",
        wallThickness: "",
        flowRate: ""
    )
}

class DrillingIntervalsStorage {
    private let userDefaults = UserDefaults.standard
    private let storageKey = "DrillingIntervalsData"

    func loadData() -> [String: DrillingIntervalModel] {
        guard let data = userDefaults.data(forKey: storageKey),
              let dict = try? JSONDecoder().decode([String: DrillingIntervalModel].self, from: data) else {
            return [:]
        }
        return dict
    }
    
    func saveData(_ dict: [String: DrillingIntervalModel]) {
        do {
            print("DEBUG: Attempting to save dictionary:")
            for (key, model) in dict {
                print("  Key: \(key)")
                print("    Model: \(model)")
            }
            
            let data = try JSONEncoder().encode(dict)
            
            // Печатаем JSON-строку, чтобы увидеть, что именно записывается
            if let jsonString = String(data: data, encoding: .utf8) {
                print("DEBUG: JSON to be saved:\n\(jsonString)")
            }
            
            userDefaults.set(data, forKey: storageKey)
            
            print("DEBUG: Data successfully saved to UserDefaults with key: \(storageKey)")
        } catch {
            print("Ошибка при сохранении данных: \(error)")
        }
    }

    func resetAll() {
        userDefaults.removeObject(forKey: storageKey)
    }
}


struct DrillingIntervals: View {
    
    enum Field: CaseIterable {
        case firstLength, firstDiameter, depth, bitDiameter, cavernosity, steelPipe, wallThickness, flowRate
    }
    
    @EnvironmentObject var viewModel: DrillingIntervalsViewModel
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var themeSettings: ThemeSettings
    @EnvironmentObject var unitSettings: UnitSettings
    
    var title: String
    
    var intervalType: DrillingIntervalType

    @State private var localModel: DrillingIntervalModel


    private let feedbackGenerator = UINotificationFeedbackGenerator()

    @FocusState private var focusedField: Field?
    @State private var showResetAlert = false

    private var units: MeasurementSystem {
        unitSettings.system
    }
    
    init(title: String, intervalType: DrillingIntervalType) {
        self.title = title
        self.intervalType = intervalType
        _localModel = State(initialValue: .empty)
    }
        
    var body: some View {
        ZStack {
            if themeSettings.isDarkModeEnabled {
                ThemeColors.darkBackground
                    .edgesIgnoringSafeArea(.all)
            } else {
                ThemeColors.lightBackground
                    .edgesIgnoringSafeArea(.all)
            }
            
            VStack(alignment: .leading) {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                        feedbackGenerator.notificationOccurred(.success)
                    }) {
                        Image(themeSettings.isDarkModeEnabled ? "backButtonDark" : "backButton")
                            .resizable()
                            .frame(width: 40, height: 40)
                    }

                    Spacer()

                    resetButton
                }
                .padding(.horizontal, 25)

                Text(title)
                    .font(.title)
                    .foregroundColor(
                        themeSettings.isDarkModeEnabled ? ThemeColors.lightText : ThemeColors.darkText)
                    .padding(.top, 28)
                    .padding(.leading, 25)
                
                ScrollView {
                    Spacer()
                    
                    VStack() {
                        HStack() {
                            Text(L10n.tr("swiftui.previousColumn"))
                                .foregroundColor(
                                    themeSettings.isDarkModeEnabled ? ThemeColors.lightText : ThemeColors.darkText)
                                .font(.system(size: 16, weight: .medium))
                            Text(L10n.tr("swiftui.optionalShort"))
                                .foregroundColor(
                                    themeSettings.isDarkModeEnabled ? ThemeColors.lightText.opacity(0.4) : ThemeColors.darkText)
                                .font(.system(size: 16, weight: .medium))
                            Spacer()
                        }
                        .padding(.bottom, 16)
                        
                        CustomDoubleTextField(
                            focusedField: $focusedField,
                            firstField: .firstLength,
                            secondField: .firstDiameter,
                            firstLabel: L10n.tr("swiftui.length"),
                            secondLabel: L10n.tr("swiftui.innerDiameter"),
                            firstUnit: units.lengthUnit,
                            secondUnit: units.diameterUnit,
                            firstTextField: $localModel.firstLength,
                            secondTextField: $localModel.firstDiameter
                        )
                        .focused($focusedField, equals: .firstLength)
                        
                        Text(L10n.tr("swiftui.openHole"))
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(
                                themeSettings.isDarkModeEnabled ? ThemeColors.lightText : ThemeColors.darkText)
                            .padding(.top, 8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack {
                            CustomTextField(
                                focusedField: $focusedField,
                                currentField: .depth,
                                firstLabel: L10n.tr("swiftui.depth"),
                                secondLabel: units.lengthUnit,
                                numberText: $localModel.depth
                            )
                            Spacer(minLength: 25)
                            CustomTextField(
                                focusedField: $focusedField,
                                currentField: .bitDiameter,
                                firstLabel: L10n.tr("swiftui.bitDiameter"),
                                secondLabel: units.diameterUnit,
                                numberText: $localModel.bitDiameter
                            )
                        }
                        .padding(.top, 10)
                        HStack {
                            CustomTextField(
                                focusedField: $focusedField,
                                currentField: .cavernosity,
                                firstLabel: L10n.tr("swiftui.cavernosityCoefficient"),
                                secondLabel: "",
                                numberText: $localModel.cavernosity
                            )
                            Spacer(minLength: 25)
                            CustomTextField(
                                focusedField: $focusedField,
                                currentField: .steelPipe,
                                firstLabel: L10n.tr("swiftui.steelDrillPipes"),
                                secondLabel: units.diameterUnit,
                                numberText: $localModel.steelPipe
                            )
                        }
                        .padding(.top, 10)
                        HStack {
                            CustomTextField(
                                focusedField: $focusedField,
                                currentField: .wallThickness,
                                firstLabel: L10n.tr("swiftui.wallThickness"),
                                secondLabel: units.diameterUnit,
                                numberText: $localModel.wallThickness
                            )
                            Spacer(minLength: 25)
                            CustomTextField(
                                focusedField: $focusedField,
                                currentField: .flowRate,
                                firstLabel: L10n.tr("swiftui.flowRateOptional"),
                                secondLabel: units.flowRateUnit,
                                numberText: $localModel.flowRate
                            )
                        }
                        .padding(.top, 10)
                    }
                    .padding(.horizontal, 25)
                    
                    WashingResult(model: localModel)
                        .padding(.top, 40)

                }
                .scrollIndicators(.hidden)
                .edgesIgnoringSafeArea(.bottom)
            }
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
        }
        .navigationBarHidden(true)
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                HStack {
                    Button(L10n.tr("swiftui.next")) {
                        focusNextField()
                    }
                    Spacer()
                    Button(L10n.tr("swiftui.done")) {
                        viewModel.update(intervalType, with: localModel)
//                    viewModel.save()
                        focusedField = nil
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: EmptyView())
        .onAppear {
            localModel = viewModel.model(for: intervalType)
        }
        .onChange(of: unitSettings.resetVersion) { _ in
            localModel = .empty
            viewModel.clearAll()
        }
        .onDisappear {
            viewModel.update(intervalType, with: localModel)
        }
        .alert(L10n.tr("swiftui.resetData.title"), isPresented: $showResetAlert) {
            Button(L10n.tr("swiftui.cancel"), role: .cancel) {}
            Button(L10n.tr("swiftui.reset"), role: .destructive) {
                resetInterval()
            }
        } message: {
            Text(L10n.tr("swiftui.resetData.message"))
        }
    }

    private func focusNextField() {
        guard let currentField = focusedField,
              let currentIndex = Field.allCases.firstIndex(of: currentField) else { return }

        let nextIndex = (currentIndex + 1) % Field.allCases.count
        focusedField = Field.allCases[nextIndex]
    }

    private var resetButton: some View {
        Button(action: {
            focusedField = nil
            feedbackGenerator.notificationOccurred(.warning)
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

    private func resetInterval() {
        localModel = .empty
        viewModel.reset(intervalType)
        feedbackGenerator.notificationOccurred(.success)
    }
}
