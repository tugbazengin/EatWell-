//
//  CustomTextField.swift
//  EatWell
//
//  Created by Tuğba Zengin on 23.05.2025.
//
import SwiftUI

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        TextField(placeholder, text: $text)
            .font(.appBody)
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .foregroundColor(.black)
            .keyboardType(keyboardType)
          
    }
}

