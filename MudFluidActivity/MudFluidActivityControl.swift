//
//  MudFluidActivityControl.swift
//  MudFluidActivity
//
//  Created by Павлов Дмитрий on 14.11.2024.
//

import AppIntents
import SwiftUI
import WidgetKit

struct StartTimerIntent: SetValueIntent {
    static let title: LocalizedStringResource = "Start a timer"

    @Parameter(title: "Timer is running")
    var value: Bool

    func perform() async throws -> some IntentResult {
        // Start / stop the timer based on `value`.
        return .result()
    }
}
