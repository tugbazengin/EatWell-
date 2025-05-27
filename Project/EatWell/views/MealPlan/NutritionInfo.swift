//
//  NutritionInfo.swift
//  EatWell
//
//  Created by Tuğba Zengin on 22.05.2025.
//


import SwiftUI

struct NutritionInfo: View {
    let label: String
    let value: String
    let color: Color

    var body: some View {
        VStack {
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            Text(value)
                .font(.appHeadline)
                .foregroundColor(color)
                .fontWeight(.semibold)
        }
        .padding(8)
        .frame(minWidth: 75, maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.systemGray6))
        )
    }
}
