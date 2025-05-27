//
//  CustomButton.swift
//  EatWell
//
//  Created by Tuğba Zengin on 23.05.2025.
//
import SwiftUI

struct CustomButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.appHeadline)
                .fontWeight(.bold)
        }
        .appButtonStyle(color: .green)
        .frame(width: 250)
    }
}


