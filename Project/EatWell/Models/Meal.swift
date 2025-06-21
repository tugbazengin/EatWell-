//
//  Meal.swift
//  EatWell
//
//  Created by Tuğba Zengin on 22.05.2025.
//
import Foundation

struct Meal: Identifiable {
    let id: UUID
    let name: String
    let calories: Int
    let protein: Int
    let carbs: Int
    let fat: Int

    init(id: UUID = UUID(), name: String, calories: Int, protein: Int, carbs: Int, fat: Int) {
        self.id = id
        self.name = name
        self.calories = calories
        self.protein = protein
        self.carbs = carbs
        self.fat = fat
    }
}
