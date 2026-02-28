//
//  View+GlassEffect.swift
//  mud engineer 2
//
//  Created by Codex.
//

import SwiftUI

extension View {
    @ViewBuilder
    func applyGlassEffect() -> some View {
        if #available(iOS 26.0, *) {
            self.glassEffect(.regular.tint(Color(red: 0.345, green: 0.337, blue: 0.839)).interactive())
        } else {
            self
        }
    }
}

