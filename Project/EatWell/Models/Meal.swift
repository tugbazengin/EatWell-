//
//  Meal.swift
//  EatWell
//
//  Created by Tuğba Zengin on 22.05.2025.
//

import Foundation

struct Meal: Identifiable {
    let id = UUID()
    let name: String
    let calories: Int
    let protein: Int
    let carbs: Int
    let fat: Int
}
