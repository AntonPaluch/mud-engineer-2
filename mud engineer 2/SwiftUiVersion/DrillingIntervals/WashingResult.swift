//
//  WashingResult.swift
//  mud engineer 2
//
//  Created by Павлов Дмитрий on 08.09.2024.
//

import SwiftUI

import SwiftUI

struct WashingResult: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Результат промывки")
                .font(.title2)
                .bold()
                .foregroundColor(.black)
                .padding(.leading, 25)
                .padding(.top, 34)
            
            
            VStack(alignment: .leading, spacing: 20) {
                Text("Время")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 2)
                
                HStack {
                    Text("Полный цикл")
                    Spacer()
                    Text("18,83 мин")
                }
                HStack {
                    Text("Выход забойной пачки")
                    Spacer()
                    Text("14,92 мин")
                }
                HStack {
                    Text("Прокачка раствора для забоя")
                    Spacer()
                    Text("3,9 мин")
                }
                HStack {
                    Text("Полтора цикла")
                    Spacer()
                    Text("28 мин")
                }
                HStack {
                    Text("Два цикла промывки")
                    Spacer()
                    Text("1 ч 38 мин")
                }
                Text("Объем")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 2)
                HStack {
                    Text("С учётом инструмента")
                    Spacer()
                    Text("70 м³")
                }
                HStack {
                    Text("В инструменте")
                    Spacer()
                    Text("14,5 м³")
                }
                HStack {
                    Text("В затрубе")
                    Spacer()
                    Text("55,5 м³")
                }
                HStack {
                    Text("В скважине без инструмента")
                    Spacer()
                    Text("74,5 м³")
                }
                HStack {
                    Text("Объём инструмента")
                    Spacer()
                    Text("4,5 м³")
                }
                HStack {
                    Text("Объём в колонне")
                    Spacer()
                    Text("74,5 м³")
                }
                HStack {
                    Text("Открытый ствол")
                    Spacer()
                    Text("74,5 м³")
                }
                .padding(.bottom, 50)
            }
            .font(.system(size: 14, weight: .regular))
            .padding(.horizontal, 25)
            .foregroundColor(.black)
        }
        .background(Color.white)
        .cornerRadius(28)
//        .cornerRadius(28, corners: [.topLeft, .topRight]) // Скругляем только верхние углы
        .shadow(radius: 4)
    }
}

#Preview {
    WashingResult()
}
