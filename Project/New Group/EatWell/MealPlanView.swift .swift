//
//  MealPlanView.swift .swift
//  EatWell
//
//  Created by Tuğba Zengin on 27.03.2025.
//
import SwiftUI

struct MealPlanView: View {
    @State private var selectedDay: String = "Bugün"
    @State private var mealPlan: [String: [String: [Meal]]] = [
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

    var body: some View {
        ZStack {
            Color(red: 0.95, green: 1.0, blue: 0.95)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Beslenme Planı")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                    .padding(.top, 20)

                Picker("Gün Seç", selection: $selectedDay) {
                    ForEach(mealPlan.keys.sorted(), id: \.self) { day in
                        Text(day).tag(day)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)

                ScrollView {
                    VStack(spacing: 15) {
                        if let mealsForDay = mealPlan[selectedDay] {
                            ForEach(["Kahvaltı", "Öğle Yemeği", "Akşam Yemeği", "Ara Öğün"], id: \.self) { mealType in
                                if let meals = mealsForDay[mealType] {
                                    MealSection(title: mealType, meals: meals)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding()
        }
    }
}

struct MealSection: View {
    let title: String
    let meals: [Meal]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.title2)
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
                .shadow(radius: 4)
        )
    }
}

struct MealCard: View {
    let meal: Meal

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(meal.name)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.green)

            HStack {
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
                .shadow(radius: 4)
        )
    }
}

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
                .font(.headline)
                .foregroundColor(color)
        }
        .padding(8)
        .frame(minWidth: 75, maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.systemGray6))
        )
    }
}

struct Meal: Identifiable {
    let id = UUID()
    let name: String
    let calories: Int
    let protein: Int
    let carbs: Int
    let fat: Int
}

#Preview {
    MealPlanView()
}
