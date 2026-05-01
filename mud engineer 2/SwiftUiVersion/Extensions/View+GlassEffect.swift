import SwiftUI

extension View {
    @ViewBuilder
    func applyGlassEffect() -> some View {
        if #available(iOS 26.0, *) {
            self.glassEffect(.regular.tint(ThemeColors.buttonSettings).interactive())
        } else {
            self
        }
    }
}
