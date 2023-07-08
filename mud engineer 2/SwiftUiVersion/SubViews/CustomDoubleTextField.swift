//
//  PrototipView.swift
//  mud engineer 2
//
//  Created by Dmitriy Pavlov on 18.04.2023.
//

import SwiftUI

struct CustomDoubleTextField: View {
    @State private var firstTextField: String = "13313"
    @State private var secondTextField: String = "5454"
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.gray, lineWidth: 1)
                .frame(height: 50)
            
            HStack {
                TextField("", text: $firstTextField)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 25))
//                    .frame(height: .infinity)
//                    .background(Color.green)
                    .padding(.leading, 20)
                    .onChange(of: firstTextField) { newValue in
                        if newValue.count > 5 {
                            firstTextField = String(newValue.prefix(5))
                        }
                    }
                
//                Spacer()
                
                Text("м")
                    .padding(.trailing, 20)
                    .padding(.leading, 8)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                
                RoundedRectangle(cornerRadius: 1)
                                    .frame(width: 1, height: 50)
                                    .foregroundColor(Color.gray)
                
                TextField("0", text: $secondTextField)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 25))
                    .background(Color.green)
//                    .frame(height: .infinity)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .padding(.leading, 20)
                    .onChange(of: secondTextField) { newValue in
                        if newValue.count > 5 {
                            secondTextField = String(newValue.prefix(5))
                        }
                    }
                
//                Spacer()
                
                Text("мм")
                    .foregroundColor(.gray)
//                    .padding(.leading, 8)
                    .padding(.trailing, 20)
                    .font(.system(size: 14))
            }
//            .padding(.horizontal, 8)
        }
        
    }
}

struct CustomDoubleTextField_Previews: PreviewProvider {
    static var previews: some View {
        CustomDoubleTextField()
    }
}

