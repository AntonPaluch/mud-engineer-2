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
                            Text("Предыдущая колонна")
                                .foregroundColor(
                                    themeSettings.isDarkModeEnabled ? ThemeColors.lightText : ThemeColors.darkText)
                                .font(.system(size: 16, weight: .medium))
                            Text("(не обяз.)")
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
                            firstLabel: "Длина",
                            secondLabel: "Внутр. диаметр",
                            firstTextField: $localModel.firstLength,
                            secondTextField: $localModel.firstDiameter
                        )
                        .focused($focusedField, equals: .firstLength)
                        
                        Text("Открытый ствол")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(
                                themeSettings.isDarkModeEnabled ? ThemeColors.lightText : ThemeColors.darkText)
                            .padding(.top, 8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack {
                            CustomTextField(
                                focusedField: $focusedField,
                                currentField: .depth,
                                firstLabel: "Забой",
                                secondLabel: "м",
                                numberText: $localModel.depth
                            )
                            Spacer(minLength: 25)
                            CustomTextField(
                                focusedField: $focusedField,
                                currentField: .bitDiameter,
                                firstLabel: "Диаметр долота",
                                secondLabel: "мм",
                                numberText: $localModel.bitDiameter
                            )
                        }
                        .padding(.top, 10)
                        HStack {
                            CustomTextField(
                                focusedField: $focusedField,
                                currentField: .cavernosity,
                                firstLabel: "Коэфф. кавернозности",
                                secondLabel: "",
                                numberText: $localModel.cavernosity
                            )
                            Spacer(minLength: 25)
                            CustomTextField(
                                focusedField: $focusedField,
                                currentField: .steelPipe,
                                firstLabel: "Стальные бур. трубы",
                                secondLabel: "мм",
                                numberText: $localModel.steelPipe
                            )
                        }
                        .padding(.top, 10)
                        HStack {
                            CustomTextField(
                                focusedField: $focusedField,
                                currentField: .wallThickness,
                                firstLabel: "Толщина стенки",
                                secondLabel: "мм",
                                numberText: $localModel.wallThickness
                            )
                            Spacer(minLength: 25)
                            CustomTextField(
                                focusedField: $focusedField,
                                currentField: .flowRate,
                                firstLabel: "Литраж (не обяз.)",
                                secondLabel: "л/с",
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
                    Button("Next") {
                        focusNextField()
                    }
                    Spacer()
                    Button("Done") {
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
        .onDisappear {
            viewModel.update(intervalType, with: localModel)
        }
        .alert("Сброс данных", isPresented: $showResetAlert) {
            Button("Отмена", role: .cancel) {}
            Button("Сбросить", role: .destructive) {
                resetInterval()
            }
        } message: {
            Text("Все значения будут удалены и данные не сохранятся.")
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
                Text("Сброс")
            }
            .font(.system(size: 14, weight: .semibold))
            .padding(.horizontal, 18)
            .padding(.vertical, 10)
            .background(.ultraThinMaterial, in: Capsule())
            .overlay(
                Capsule()
                    .stroke(Color.white.opacity(themeSettings.isDarkModeEnabled ? 0.1 : 0.2))
            )
        }
        .applyGlassEffect()
        .foregroundColor(themeSettings.isDarkModeEnabled ? ThemeColors.lightText : ThemeColors.darkText)
    }

    private func resetInterval() {
        localModel = .empty
        viewModel.reset(intervalType)
        feedbackGenerator.notificationOccurred(.success)
    }
}
