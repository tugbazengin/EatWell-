//
//  MealCard.swift
//  EatWell
//
//  Created by Tuğba Zengin on 22.05.2025.
//



import SwiftUI

struct MealCard: View {
    let meal: Meal

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(meal.name)
                .font(.appHeadline)
                .foregroundColor(.green)
                .fontWeight(.bold)

            HStack(spacing: 15) {
                NutritionInfo(label: "Kalori", value: "\(meal.calories) kcal", color: .red)
                NutritionInfo(label: "Protein", value: "\(meal.protein)g", color: .blue)
                NutritionInfo(label: "Karbonhidrat", value: "\(meal.carbs)g", color: .orange)
                NutritionInfo(label: "Yağ", value: "\(meal.fat)g", color: .purple)
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


