//
//  WashingResult.swift
//  mud engineer 2
//
//  Created by Павлов Дмитрий on 08.09.2024.
//

import SwiftUI

fileprivate struct WashingCalculationResult {
    let volumeColumn: Double
    let volumeOpenHole: Double
    let volumeMetal: Double
    let volumeTotal: Double
    let volumeWithInstrument: Double
    let volumeInInstrument: Double
    let volumeBehindInstrument: Double

    let pumpRateCubicPerMinute: Double?
    let outputDownholePack: Double?
    let pumpingToBottom: Double?
    let fullCycle: Double?
    let oneAndHalfCycles: Double?
    let twoCycles: Double?

    var isPumpingAvailable: Bool { pumpRateCubicPerMinute != nil }
}

fileprivate struct WashingCalculator {
    let model: DrillingIntervalModel

    func compute() -> WashingCalculationResult {
        let previousColumnLength = parse(model.firstLength)
        let previousColumnDiameter = parse(model.firstDiameter)
        let depth = parse(model.depth)
        let bitDiameter = parse(model.bitDiameter)
        let cavernosity = parse(model.cavernosity) ?? 1
        let instrumentDiameter = parse(model.steelPipe)
        let wallThickness = parse(model.wallThickness)
        let flowRate = parse(model.flowRate)

        let columnVolume = calculateColumnVolume(length: previousColumnLength, diameter: previousColumnDiameter)
        let openHoleVolume = calculateOpenHoleVolume(depth: depth, previousColumnLength: previousColumnLength, bitDiameter: bitDiameter, cavernosity: cavernosity)
        let volumeTotal = columnVolume + openHoleVolume

        let (metalVolume, innerInstrumentDiameter) = calculateInstrumentMetalVolume(outerDiameter: instrumentDiameter, wallThickness: wallThickness, depth: depth)
        let volumeWithInstrument = max(volumeTotal - metalVolume, 0)
        let volumeInInstrument = calculateFluidInInstrument(innerDiameter: innerInstrumentDiameter, depth: depth)
        let volumeBehindInstrument = max(volumeWithInstrument - volumeInInstrument, 0)

        let pumpRate = calculatePumpRate(flowRate: flowRate)
        let outputDownholePack = divide(volumeWithInstrument, by: pumpRate)
        let pumpingToBottom = divide(volumeInInstrument, by: pumpRate)
        let fullCycle = add(outputDownholePack, pumpingToBottom)
        let oneAndHalfCycles = fullCycle.map { $0 * 1.5 }
        let twoCycles = fullCycle.map { $0 * 2 }

        return WashingCalculationResult(
            volumeColumn: columnVolume,
            volumeOpenHole: openHoleVolume,
            volumeMetal: metalVolume,
            volumeTotal: volumeTotal,
            volumeWithInstrument: volumeWithInstrument,
            volumeInInstrument: volumeInInstrument,
            volumeBehindInstrument: volumeBehindInstrument,
            pumpRateCubicPerMinute: pumpRate,
            outputDownholePack: outputDownholePack,
            pumpingToBottom: pumpingToBottom,
            fullCycle: fullCycle,
            oneAndHalfCycles: oneAndHalfCycles,
            twoCycles: twoCycles
        )
    }

    private func parse(_ string: String) -> Double? {
        let sanitized = string
            .replacingOccurrences(of: ",", with: ".")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        guard !sanitized.isEmpty, let value = Double(sanitized) else { return nil }
        return value
    }

    private func calculateColumnVolume(length: Double?, diameter: Double?) -> Double {
        guard let length, length > 0,
              let diameter, diameter > 0 else { return 0 }
        let diameterMeters = diameter / 1000
        let area = Double.pi / 4 * pow(diameterMeters, 2)
        return area * length
    }

    private func calculateOpenHoleVolume(depth: Double?, previousColumnLength: Double?, bitDiameter: Double?, cavernosity: Double) -> Double {
        guard let depth, depth > 0,
              let bitDiameter, bitDiameter > 0 else { return 0 }

        let previousLength = max(previousColumnLength ?? 0, 0)
        let intervalLength = max(depth - previousLength, 0)
        let bitDiameterMeters = bitDiameter / 1000
        let area = Double.pi / 4 * pow(bitDiameterMeters, 2)
        return area * intervalLength * max(cavernosity, 0)
    }

    private func calculateInstrumentMetalVolume(outerDiameter: Double?, wallThickness: Double?, depth: Double?) -> (volume: Double, innerDiameter: Double?) {
        guard let depth, depth > 0,
              let outerDiameter, outerDiameter > 0,
              let wallThickness, wallThickness > 0 else { return (0, nil) }

        let innerDiameter = outerDiameter - 2 * wallThickness
        guard innerDiameter > 0 else { return (0, nil) }

        let outerDiameterMeters = outerDiameter / 1000
        let innerDiameterMeters = innerDiameter / 1000

        let outerArea = Double.pi / 4 * pow(outerDiameterMeters, 2)
        let innerArea = Double.pi / 4 * pow(innerDiameterMeters, 2)
        let metalArea = max(outerArea - innerArea, 0)
        let volume = metalArea * depth

        return (volume, innerDiameter)
    }

    private func calculateFluidInInstrument(innerDiameter: Double?, depth: Double?) -> Double {
        guard let depth, depth > 0,
              let innerDiameter, innerDiameter > 0 else { return 0 }

        let innerDiameterMeters = innerDiameter / 1000
        let area = Double.pi / 4 * pow(innerDiameterMeters, 2)
        return area * depth
    }

    private func calculatePumpRate(flowRate: Double?) -> Double? {
        guard let flowRate, flowRate > 0 else { return nil }
        let rate = (flowRate * 60) / 1000
        return rate > 0 ? rate : nil
    }

    private func divide(_ value: Double, by divisor: Double?) -> Double? {
        guard let divisor, divisor > 0 else { return nil }
        return value / divisor
    }

    private func add(_ lhs: Double?, _ rhs: Double?) -> Double? {
        guard let lhs, let rhs else { return nil }
        return lhs + rhs
    }
}

struct WashingResult: View {
    @EnvironmentObject var themeSettings: ThemeSettings

    var model: DrillingIntervalModel

    private var calculation: WashingCalculationResult {
        WashingCalculator(model: model).compute()
    }

    private var primaryTextColor: Color {
        themeSettings.isDarkModeEnabled ? ThemeColors.lightText : ThemeColors.darkText
    }

    private var secondaryTextColor: Color {
        themeSettings.isDarkModeEnabled ? ThemeColors.lightText.opacity(0.6) : ThemeColors.darkText.opacity(0.6)
    }

    private var cardBackground: Color {
        themeSettings.isDarkModeEnabled ? ThemeColors.darkBackgroundSubView : Color.white
    }

    private var minimumPanelHeight: CGFloat {
        UIScreen.main.bounds.height * 0.72
    }

    @State private var showCopyBanner = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Результат промывки")
                    .font(.title2.weight(.bold))
                    .foregroundColor(primaryTextColor)
                Spacer()
                Button(action: {
                    UIPasteboard.general.string = summaryText
                    showCopyBanner = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        showCopyBanner = false
                    }
                }) {
                    Image(systemName: "doc.on.doc")
                        .font(.system(size: 18, weight: .semibold))
                        .padding(8)
                        .background(.ultraThinMaterial, in: Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(themeSettings.isDarkModeEnabled ? 0.1 : 0.2))
                        )
                }
                .applyGlassEffect()
                .foregroundColor(primaryTextColor)
                .accessibilityLabel("Копировать сводку")
            }
            .padding(.horizontal, 25)
            .padding(.top, 34)

            VStack(alignment: .leading, spacing: 20) {
                sectionTitle("Время")

                resultRow(
                    title: "Полный цикл",
                    value: calculation.isPumpingAvailable ? formattedMinutes(calculation.fullCycle) : localized("notFlushed")
                )
                resultRow(
                    title: "Выход забойной пачки",
                    value: formattedMinutes(calculation.outputDownholePack)
                )
                resultRow(
                    title: "Прокачка раствора для забоя",
                    value: formattedMinutes(calculation.pumpingToBottom)
                )
                resultRow(
                    title: "Полтора цикла",
                    value: formattedHoursMinutes(calculation.oneAndHalfCycles)
                )
                resultRow(
                    title: "Два цикла промывки",
                    value: formattedHoursMinutes(calculation.twoCycles)
                )

                sectionTitle("Объем")

                resultRow(
                    title: "С учётом инструмента",
                    value: formattedVolume(calculation.volumeWithInstrument)
                )
                resultRow(
                    title: "В инструменте",
                    value: formattedVolume(calculation.volumeInInstrument)
                )
                resultRow(
                    title: "В затрубе",
                    value: formattedVolume(calculation.volumeBehindInstrument)
                )
                resultRow(
                    title: "В скважине без инструмента",
                    value: formattedVolume(calculation.volumeTotal)
                )
                resultRow(
                    title: "Объём инструмента",
                    value: formattedVolume(calculation.volumeMetal)
                )
                resultRow(
                    title: "Объём в колонне",
                    value: formattedVolume(calculation.volumeColumn)
                )
                resultRow(
                    title: "Открытый ствол",
                    value: formattedVolume(calculation.volumeOpenHole)
                )
                .padding(.bottom, 50)
            }
            .padding(.horizontal, 25)
        }
        .foregroundColor(primaryTextColor)
        .frame(maxWidth: .infinity, minHeight: minimumPanelHeight, alignment: .topLeading)
        .background(cardBackground)
        .cornerRadius(28, corners: [.topLeft, .topRight])
        .overlay(alignment: .bottom) {
            if showCopyBanner {
                Text("Сводка скопирована")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(primaryTextColor)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(.ultraThinMaterial, in: Capsule())
                    .overlay(
                        Capsule()
                            .stroke(Color.white.opacity(themeSettings.isDarkModeEnabled ? 0.1 : 0.2))
                    )
                    .padding(.bottom, 16)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: showCopyBanner)
    }

    private func sectionTitle(_ text: String) -> some View {
        Text(text)
            .font(.subheadline.weight(.semibold))
            .foregroundColor(secondaryTextColor)
            .padding(.bottom, 2)
    }

    private func resultRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .multilineTextAlignment(.trailing)
        }
        .font(.system(size: 14, weight: .regular))
    }

    private func formattedMinutes(_ value: Double?) -> String {
        guard let value, value.isFinite else { return "-" }
        if value >= 60 {
            return formattedHoursMinutes(value)
        }
        let number = Self.minutesFormatter.string(from: value as NSNumber) ?? "-"
        return number + localized("minutes")
    }

    private func formattedHoursMinutes(_ value: Double?) -> String {
        guard let value, value.isFinite else { return "-" }
        var hours = floor(value / 60)
        var minutes = round((value / 60 - hours) * 60)
        if minutes >= 60 {
            minutes -= 60
            hours += 1
        }
        let hoursString = Self.minutesFormatterNoFraction.string(from: hours as NSNumber) ?? "0"
        let minutesString = Self.minutesFormatterNoFraction.string(from: minutes as NSNumber) ?? "0"
        return "\(hoursString) \(localized("h")) \(minutesString) \(localized("min"))"
    }

    private func formattedVolume(_ value: Double) -> String {
        Self.volumeFormatter.string(from: value as NSNumber)?.appending(localized("metr3")) ?? "-"
    }

    private func localized(_ key: String) -> String {
        NSLocalizedString(key, comment: "")
    }

    private static let minutesFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        return formatter
    }()

    private static let minutesFormatterNoFraction: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        formatter.minimumFractionDigits = 0
        return formatter
    }()

    private static let volumeFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 1
        return formatter
    }()

    private var summaryText: String {
        let calc = calculation
        var lines: [String] = []

        lines.append("Время")
        if calc.fullCycle != nil {
            lines.append("Полный цикл: \(formattedMinutes(calc.fullCycle))")
        }
        if calc.outputDownholePack != nil {
            lines.append("Выход забойной пачки: \(formattedMinutes(calc.outputDownholePack))")
        }
        if calc.pumpingToBottom != nil {
            lines.append("Прокачка раствора для забоя: \(formattedMinutes(calc.pumpingToBottom))")
        }
        if let oneHalf = calc.oneAndHalfCycles {
            lines.append("Полтора цикла: \(formattedHoursMinutes(oneHalf))")
        }
        if let twoCycles = calc.twoCycles {
            lines.append("Два цикла промывки: \(formattedHoursMinutes(twoCycles))")
        }

        lines.append("Объем")
        lines.append("С учётом инструмента: \(formattedVolume(calc.volumeWithInstrument))")
        lines.append("В инструменте: \(formattedVolume(calc.volumeInInstrument))")
        lines.append("В затрубе: \(formattedVolume(calc.volumeBehindInstrument))")
        lines.append("В скважине без инструмента: \(formattedVolume(calc.volumeTotal))")
        lines.append("Объём инструмента: \(formattedVolume(calc.volumeMetal))")
        lines.append("Объём в колонне: \(formattedVolume(calc.volumeColumn))")
        lines.append("Открытый ствол: \(formattedVolume(calc.volumeOpenHole))")

        return lines.joined(separator: "\n")
    }
}

#Preview {
    WashingResult(
        model: DrillingIntervalModel(
            firstLength: "400",
            firstDiameter: "178",
            depth: "1500",
            bitDiameter: "220",
            cavernosity: "1.1",
            steelPipe: "127",
            wallThickness: "9",
            flowRate: "30"
        )
    )
    .environmentObject(ThemeSettings())
}
