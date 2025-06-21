//
//  MealRecipesView.swift
//  EatWell
//
//  Created by Tuğba Zengin on 22.05.2025.
//
import SwiftUI

struct MealRecipesView: View {
    @StateObject private var viewModel = MealRecipesViewModel()

    var body: some View {
        BaseView(title: "Yemek Tarifleri", showsScrollView: false) {
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(viewModel.categories, id: \.self) { category in
                            Button(action: {
                                viewModel.selectedCategory = category
                            }) {
                                Text(category)
                                    .font(.appBody)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(viewModel.selectedCategory == category ? Color.green : Color.white)
                                    .foregroundColor(viewModel.selectedCategory == category ? .white : .primary)
                                    .clipShape(Capsule())
                                    .shadow(radius: 3)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 10)

                if let meal = viewModel.randomMeal {
                    VStack(spacing: 10) {
                        Image(meal.image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shadow(radius: 5)

                        Text(meal.name)
                            .font(.appHeadline)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)

                        Text(meal.calories)
                            .font(.appBody)
                            .foregroundColor(.gray)

                        Button(action: {
                            viewModel.clearSuggestion()
                        }) {
                            Text("Yeni Öneri Al")
                                .font(.appBody)
                                .foregroundColor(.white)
                                .appButtonStyle(color: .green)
                                .frame(width: 200)
                        }
                        .padding(.top, 10)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white)
                            .shadow(radius: 5)
                    )
                    .padding()
                } else {
                    Button(action: {
                        viewModel.suggestRandomMeal()
                    }) {
                        Text("Yemek Öner")
                            .font(.appBody)
                            .foregroundColor(.white)
                            .appButtonStyle(color: .green)
                            .frame(width: 250)
                    }
                    .padding(.top, 20)
                }

                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(viewModel.filteredMeals) { meal in
                            RecipeCard(meal: meal)
                        }
                    }
                    .appContentsPadding()
                }
            }
            .appContentsPadding()
        }
    }
}

//
//  MealRecipesView.swift
//  EatWell
//
//  Created by Tuğba Zengin on 22.05.2025.
//
import SwiftUI

struct MealRecipesView: View {
    @StateObject private var viewModel = MealRecipesViewModel()

    var body: some View {
        BaseView(title: "Yemek Tarifleri") {
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(viewModel.categories, id: \.self) { category in
                            Button(action: {
                                viewModel.selectedCategory = category
                            }) {
                                Text(category)
                                    .font(.appBody)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(viewModel.selectedCategory == category ? Color.green : Color.white)
                                    .foregroundColor(viewModel.selectedCategory == category ? .white : .primary)
                                    .clipShape(Capsule())
                                    .shadow(radius: 3)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 10)

                if let meal = viewModel.randomMeal {
                    VStack(spacing: 10) {
                        Image(meal.image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shadow(radius: 5)

                        Text(meal.name)
                            .font(.appHeadline)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)

                        Text(meal.calories)
                            .font(.appBody)
                            .foregroundColor(.gray)

                        Button(action: {
                            viewModel.clearSuggestion()
                        }) {
                            Text("Yeni Öneri Al")
                                .font(.appBody)
                                .foregroundColor(.white)
                                .appButtonStyle(color: .green)
                                .frame(width: 200)
                        }
                        .padding(.top, 10)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white)
                            .shadow(radius: 5)
                    )
                    .padding()
                } else {
                    Button(action: {
                        viewModel.suggestRandomMeal()
                    }) {
                        Text("Yemek Öner")
                            .font(.appBody)
                            .foregroundColor(.white)
                            .appButtonStyle(color: .green)
                            .frame(width: 250)
                    }
                    .padding(.top, 20)
                }

                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(viewModel.filteredMeals) { meal in
                            RecipeCard(meal: meal)
                        }
                    }
                    .appContentsPadding()
                }
            }
            .appContentsPadding()
        }
    }
}
