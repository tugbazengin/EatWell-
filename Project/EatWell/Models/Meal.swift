//
//  Meal.swift
//  EatWell
//
//  Created by Tuğba Zengin on 22.05.2025.
//

import Foundation

struct Meal: Identifiable, Codable {
    let id: String
    let name: String
    let category: String
    let calories: Int
    let protein: Double
    let carbs: Double
    let fat: Double
    let description: String
    let ingredients: [String]
    let preparationTime: Int // dakika
    let createdAt: String?
    let updatedAt: String?
    
    // MongoDB'den gelen _id'yi id'ye map et
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case category
        case calories
        case protein
        case carbs
        case fat
        case description
        case ingredients
        case preparationTime
        case createdAt
        case updatedAt
    }
    
    // Test verisi için init
    init(id: String = UUID().uuidString, name: String, category: String, calories: Int, protein: Double, carbs: Double, fat: Double, description: String, ingredients: [String], preparationTime: Int) {
        self.id = id
        self.name = name
        self.category = category
        self.calories = calories
        self.protein = protein
        self.carbs = carbs
        self.fat = fat
        self.description = description
        self.ingredients = ingredients
        self.preparationTime = preparationTime
        self.createdAt = nil
        self.updatedAt = nil
    }
}

// MARK: - Computed Properties
extension Meal {
    /// Hazırlama süresini string olarak döndürür
    var preparationTimeText: String {
        if preparationTime == 0 {
            return "Anında"
        } else if preparationTime < 60 {
            return "\(preparationTime) dk"
        } else {
            let hours = preparationTime / 60
            let minutes = preparationTime % 60
            if minutes == 0 {
                return "\(hours) saat"
            } else {
                return "\(hours) saat \(minutes) dk"
            }
        }
    }
    
    /// Kalori kategorisini döndürür
    var calorieCategory: String {
        switch calories {
        case 0..<100:
            return "Düşük Kalori"
        case 100..<200:
            return "Orta Kalori"
        case 200..<400:
            return "Yüksek Kalori"
        default:
            return "Çok Yüksek Kalori"
        }
    }
    
    /// Protein kategorisini döndürür
    var proteinCategory: String {
        switch protein {
        case 0..<5:
            return "Düşük Protein"
        case 5..<15:
            return "Orta Protein"
        case 15..<25:
            return "Yüksek Protein"
        default:
            return "Çok Yüksek Protein"
        }
    }
    
    /// Malzemeleri string olarak döndürür
    var ingredientsText: String {
        ingredients.joined(separator: ", ")
    }
}

// MARK: - Sample Data
extension Meal {
    static let sampleMeals: [Meal] = [
        Meal(
            name: "Menemen",
            category: "Kahvaltı",
            calories: 250,
            protein: 12.0,
            carbs: 8.0,
            fat: 18.0,
            description: "Domates, biber ve yumurta ile yapılan geleneksel Türk kahvaltısı",
            ingredients: ["yumurta", "domates", "biber", "soğan", "zeytinyağı"],
            preparationTime: 15
        ),
        Meal(
            name: "Adana Kebap",
            category: "Öğle Yemeği",
            calories: 420,
            protein: 35.0,
            carbs: 5.0,
            fat: 28.0,
            description: "Acılı kıyma ile yapılan geleneksel kebap",
            ingredients: ["dana kıyma", "kuyruk yağı", "pul biber", "tuz"],
            preparationTime: 20
        ),
        Meal(
            name: "Mantı",
            category: "Akşam Yemeği",
            calories: 320,
            protein: 18.0,
            carbs: 40.0,
            fat: 10.0,
            description: "Kıymalı mantı",
            ingredients: ["hamur", "kıyma", "yoğurt", "sarımsak", "tereyağı"],
            preparationTime: 90
        ),
        Meal(
            name: "Elma",
            category: "Atıştırmalık",
            calories: 80,
            protein: 0.0,
            carbs: 21.0,
            fat: 0.0,
            description: "Taze elma",
            ingredients: ["elma"],
            preparationTime: 0
        ),
        Meal(
            name: "Mercimek Çorbası",
            category: "Çorba",
            calories: 180,
            protein: 12.0,
            carbs: 28.0,
            fat: 3.0,
            description: "Kırmızı mercimekle yapılan geleneksel çorba",
            ingredients: ["kırmızı mercimek", "soğan", "havuç", "patates", "zeytinyağı"],
            preparationTime: 30
        ),
        Meal(
            name: "Baklava",
            category: "Tatlı",
            calories: 450,
            protein: 8.0,
            carbs: 55.0,
            fat: 22.0,
            description: "Geleneksel baklava",
            ingredients: ["yufka", "ceviz", "şeker", "tereyağı"],
            preparationTime: 120
        )
    ]
}
