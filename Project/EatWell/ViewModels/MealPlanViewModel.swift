//
//  MealPlanViewModel.swift
//  EatWell
//
//  Created by Tuğba Zengin on 22.05.2025.
//

import Foundation

class MealPlanViewModel: ObservableObject {
    @Published var selectedDay: String = "Bugün"
    @Published var mealPlan: [String: [String: [Meal]]] = [
        "Bugün": [
            "Kahvaltı": [Meal(name: "Yulaf Ezmesi", calories: 250, protein: 8, carbs: 45, fat: 5)],
            "Öğle Yemeği": [Meal(name: "Izgara Tavuk ve Sebzeler", calories: 400, protein: 40, carbs: 30, fat: 10)],
            "Akşam Yemeği": [Meal(name: "Somon ve Quinoa", calories: 450, protein: 50, carbs: 35, fat: 12)],
            "Ara Öğün": [Meal(name: "Yoğurt ve Badem", calories: 200, protein: 10, carbs: 15, fat: 8)]
        ],
        "Yarın": [
            "Kahvaltı": [Meal(name: "Smoothie", calories: 300, protein: 15, carbs: 50, fat: 7)],
            "Öğle Yemeği": [Meal(name: "Tavuklu Salata", calories: 350, protein: 35, carbs: 20, fat: 8)],
            "Akşam Yemeği": [Meal(name: "Sebzeli Makarna", calories: 400, protein: 20, carbs: 55, fat: 10)],
            "Ara Öğün": [Meal(name: "Meyveli Yoğurt", calories: 220, protein: 12, carbs: 25, fat: 5)]
        ]
    ]
}
