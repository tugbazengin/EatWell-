//
//  RecipeCard.swift
//  EatWell
//
//  Created by Tuğba Zengin on 22.05.2025.
//
import SwiftUI

struct RecipeCard: View {
    let meal: RecipeMeal

    var body: some View {
        VStack {
            Image(meal.image)
                .resizable()
                .scaledToFit()
                .frame(height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(radius: 3)

            Text(meal.name)
                .font(.appHeadline)
                .foregroundColor(.primary)

            Text(meal.calories)
                .font(.appBody)
                .foregroundColor(.gray)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(radius: 4)
        )
        .appContentsPadding()
    }
}

