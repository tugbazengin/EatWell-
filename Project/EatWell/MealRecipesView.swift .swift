//
//  MealRecipesView.swift .swift
//  EatWell
//
//  Created by Tuğba Zengin on 27.03.2025.
//
import SwiftUI

struct MealRecipesView: View {
    @State private var selectedCategory: String = "Tümü"
    @State private var randomMeal: RecipeMeal? = nil

    let categories = ["Tümü", "Kahvaltı", "Öğle", "Akşam", "Atıştırmalık", "Sağlıklı"]
    let meals = [
        RecipeMeal(name: "Yoğurtlu Yulaf", category: "Kahvaltı", calories: "250 kcal", image: "yulaf"),
        RecipeMeal(name: "Izgara Tavuk", category: "Öğle", calories: "400 kcal", image: "tavuk"),
        RecipeMeal(name: "Sebzeli Omlet", category: "Kahvaltı", calories: "300 kcal", image: "omlet"),
        RecipeMeal(name: "Somon Izgara", category: "Akşam", calories: "450 kcal", image: "somon")
    ]

    var filteredMeals: [RecipeMeal] {
        selectedCategory == "Tümü" ? meals : meals.filter { $0.category == selectedCategory }
    }

    var body: some View {
        ZStack {
            
            Color(red: 0.95, green: 1.0, blue: 0.95)
                .edgesIgnoringSafeArea(.all)

            VStack {
             
                Text("Yemek Tarifleri")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 20)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(categories, id: \.self) { category in
                            Button(action: {
                                selectedCategory = category
                            }) {
                                Text(category)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(selectedCategory == category ? Color.green : Color.white)
                                    .foregroundColor(selectedCategory == category ? .white : .black)
                                    .clipShape(Capsule())
                                    .shadow(radius: 3)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 10)

              
                if let meal = randomMeal {
                    VStack {
                        Image(meal.image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shadow(radius: 5)

                        Text(meal.name)
                            .font(.title2)
                            .fontWeight(.bold)

                        Text(meal.calories)
                            .font(.subheadline)
                            .foregroundColor(.gray)

                        Button(action: {
                            randomMeal = nil
                        }) {
                            Text("Yeni Öneri Al")
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 200)
                                .background(Color.green)
                                .clipShape(Capsule())
                                .shadow(radius: 5)
                        }
                        .padding(.top, 10)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.white).shadow(radius: 5))
                    .padding()
                } else {
                    Button(action: {
                        randomMeal = meals.randomElement()
                    }) {
                        Text("Yemek Öner")
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 250)
                            .background(Color.green)
                            .clipShape(Capsule())
                            .shadow(radius: 5)
                    }
                    .padding(.top, 20)
                }

              
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(filteredMeals) { meal in
                            RecipeCard(meal: meal)
                        }
                    }
                    .padding()
                }
            }
        }
    }
}


struct RecipeMeal: Identifiable {
    let id = UUID()
    let name: String
    let category: String
    let calories: String
    let image: String
}


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
                .font(.headline)
                .foregroundColor(.black)

            Text(meal.calories)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white).shadow(radius: 4))
    }
}


struct MealRecipesView_Previews: PreviewProvider {
    static var previews: some View {
        MealRecipesView()
    }
}
