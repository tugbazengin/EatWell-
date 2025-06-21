//
//  RecipeMeal.swift
//  EatWell
//
//  Created by Tuğba Zengin on 22.05.2025.
//

import Foundation

struct RecipeMeal: Identifiable {
    let id: UUID
    let name: String
    let category: String
    let calories: String
    let image: String

    init(id: UUID = UUID(), name: String, category: String, calories: String, image: String) {
        self.id = id
        self.name = name
        self.category = category
        self.calories = calories
        self.image = image
    }
}
