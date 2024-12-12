//
//  DebugFrameModifier.swift
//  mud engineer 2
//
//  Created by Павлов Дмитрий on 14.11.2024.
//

import SwiftUI

struct DebugFrameModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    let width = geometry.size.width
                    let height = geometry.size.height
                    ZStack(alignment: .topTrailing) {
                        content
                            .border(Color.blue, width: 1)
                        
                        Text("W: \(Int(width)) H: \(Int(height))")
                            .font(.caption)
                            .padding(4)
                            .background(Color.black.opacity(0.7))
                            .foregroundColor(.white)
                            .cornerRadius(5)
                            .padding(4)
                    }
                }
            )
    }
}

extension View {
    func debugFrame() -> some View {
        self.modifier(DebugFrameModifier())
    }
}
