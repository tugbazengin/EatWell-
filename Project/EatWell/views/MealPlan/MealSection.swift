//
//  MealSection.swift
//  EatWell
//
//  Created by Tuğba Zengin on 22.05.2025.
//


import SwiftUI

struct MealSection: View {
    let title: String
    let meals: [Meal]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.appHeadline)
                .fontWeight(.bold)
                .foregroundColor(.green)
                .padding(.bottom, 5)

            ForEach(meals) { meal in
                MealCard(meal: meal)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 3, y: 3)
                .shadow(color: Color.white.opacity(0.8), radius: 5, x: -3, y: -3)
        )
    }
}


