//
//  InfoCard.swift
//  EatWell
//
//  Created by Tuğba Zengin on 22.05.2025.
//

import SwiftUI

struct InfoCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(color)

            Text(title)
                .font(.appHeadline)
                .foregroundColor(.primary)

            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 140)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 3, y: 3)
                .shadow(color: Color.white.opacity(0.8), radius: 5, x: -3, y: -3)
        )
    }
}

