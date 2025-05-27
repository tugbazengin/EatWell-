//
//  CustomSecureField.swift
//  EatWell
//
//  Created by Tuğba Zengin on 25.05.2025.
//

import SwiftUI

struct CustomSecureField: View {
    var placeholder: String
    @Binding var text: String

    var body: some View {
        SecureField(placeholder, text: $text)
            .padding()
            .background(Color.white)
            .cornerRadius(8)
            .shadow(radius: 1)
    }
}
