//
//  MealRecipesViewModel.swift
//  EatWell
//
//  Created by Tuğba Zengin on 22.05.2025.
//

import SwiftUI

class MealRecipesViewModel: ObservableObject {
    @Published var selectedCategory: String
    @Published var randomMeal: RecipeMeal?

    let categories: [String]
    let meals: [RecipeMeal]

    var filteredMeals: [RecipeMeal] {
        selectedCategory == "Tümü" ? meals : meals.filter { $0.category == selectedCategory }
    }

    init(selectedCategory: String = "Tümü",
         randomMeal: RecipeMeal? = nil,
         categories: [String] = ["Tümü", "Kahvaltı", "Öğle", "Akşam", "Atıştırmalık", "Sağlıklı"],
         meals: [RecipeMeal] = [
            RecipeMeal(name: "Yoğurtlu Yulaf", category: "Kahvaltı", calories: "250 kcal", image: "yulaf"),
            RecipeMeal(name: "Izgara Tavuk", category: "Öğle", calories: "400 kcal", image: "tavuk"),
            RecipeMeal(name: "Sebzeli Omlet", category: "Kahvaltı", calories: "300 kcal", image: "omlet"),
            RecipeMeal(name: "Somon Izgara", category: "Akşam", calories: "450 kcal", image: "somon")
         ]) {
        self.selectedCategory = selectedCategory
        self.randomMeal = randomMeal
        self.categories = categories
        self.meals = meals
    }

    func suggestRandomMeal() {
        randomMeal = meals.randomElement()
    }

    func clearSuggestion() {
        randomMeal = nil
    }
}
