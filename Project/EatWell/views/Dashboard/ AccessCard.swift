//
//   AccessCard.swift
//  EatWell
//
//  Created by Tuğba Zengin on 22.05.2025.
//
import SwiftUI

struct AccessCard: View {
    let icon: String
    let title: String

    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.appHeadline)
                .foregroundColor(Color.green)
            Text(title)
                .font(.appBody)
                .foregroundColor(.primary)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 80)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .shadow(color: Color.gray.opacity(0.3), radius: 10, x: 5, y: 5)
                .shadow(color: Color.white, radius: 10, x: -5, y: -5)
        )
    }
}

