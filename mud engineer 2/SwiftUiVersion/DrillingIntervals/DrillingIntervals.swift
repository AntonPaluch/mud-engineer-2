//
//  DrillingIntervals.swift
//  mud engineer 2
//
//  Created by Dmitriy Pavlov on 16.04.2023.
//

import SwiftUI

import SwiftUI

struct DrillingIntervals: View {
    @EnvironmentObject var themeSettings: ThemeSettings
    @EnvironmentObject var unitSettings: UnitSettings
    var title: String
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                CustomDoubleTextField()
            }
            .padding()
        }
//        .background(themeSettings.isDarkModeEnabled ? Color.black : Color.white)
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarTitle(title, displayMode: .inline)
//        .foregroundColor(themeSettings.isDarkModeEnabled ? Color.white : Color.black)
    }
}


struct DrillingIntervals_Previews: PreviewProvider {
    static var previews: some View {
        DrillingIntervals(title: "Хвостовик")
            .environmentObject(ThemeSettings())
            .environmentObject(UnitSettings())
    }
}
