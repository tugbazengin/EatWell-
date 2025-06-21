//
//  MealPlanView.swift
//  EatWell
//
//  Created by Tuğba Zengin on 22.05.2025.
//
import SwiftUI

struct MealPlanView: View {
    @StateObject private var viewModel = MealPlanViewModel()
    @State private var selectedCategory = "Kahvaltı"
    @State private var searchText = ""
    @State private var showingMealSelector = false
    
    let categories = ["Kahvaltı", "Öğle Yemeği", "Akşam Yemeği", "Atıştırmalık"]
    
    var body: some View {
        BaseView(title: "Beslenme Planı", showsScrollView: false) {
            VStack(spacing: 20) {
                // Error Toast
                if viewModel.showError, let errorMessage = viewModel.errorMessage {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                        Text(errorMessage)
                        Spacer()
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [Color.red.opacity(0.8), Color.red],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(12)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .animation(.spring(), value: viewModel.showError)
                    .padding(.horizontal)
                }
                
                // Calorie Warning Toast  
                if viewModel.showCalorieWarning {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                        Text(viewModel.calorieWarning)
                        Spacer()
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [Color.orange.opacity(0.8), Color.orange],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(12)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .animation(.spring(), value: viewModel.showCalorieWarning)
                    .padding(.horizontal)
                }
                
                // Loading indicator
                if viewModel.isLoading {
                    VStack(spacing: 10) {
                        ProgressView()
                            .scaleEffect(1.2)
                        Text("Yemekler yükleniyor...")
                            .font(.appCaption)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    // Daily Nutrition Summary
                    dailyNutritionCard
                    
                    // Meal Categories
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            ForEach(categories, id: \.self) { category in
                                mealCategorySection(category: category)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
        .sheet(isPresented: $showingMealSelector) {
            MealSelectorView(
                category: selectedCategory,
                viewModel: viewModel,
                isPresented: $showingMealSelector
            )
        }
        .onAppear {
            viewModel.fetchMeals()
        }
    }
    
    // MARK: - Daily Nutrition Card
    private var dailyNutritionCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "chart.pie.fill")
                    .foregroundColor(.appPrimary)
                Text("Günlük Besin Özeti")
                    .font(.appHeadline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button("Temizle") {
                    viewModel.clearMealPlan()
                }
                .font(.appCaption)
                .foregroundColor(.red)
                .opacity(viewModel.dailyNutrition.calories > 0 ? 1 : 0.3)
                .disabled(viewModel.dailyNutrition.calories == 0)
            }
            
            HStack(spacing: 20) {
                NutritionItem(
                    title: "Kalori",
                    value: "\(viewModel.dailyNutrition.calories)",
                    unit: "kcal",
                    color: .orange
                )
                
                NutritionItem(
                    title: "Protein",
                    value: viewModel.dailyNutrition.formattedProtein,
                    unit: "g",
                    color: .red
                )
                
                NutritionItem(
                    title: "Karb.",
                    value: viewModel.dailyNutrition.formattedCarbs,
                    unit: "g",
                    color: .blue
                )
                
                NutritionItem(
                    title: "Yağ",
                    value: viewModel.dailyNutrition.formattedFat,
                    unit: "g",
                    color: .green
                )
            }
            
            if viewModel.dailyNutrition.preparationTime > 0 {
                HStack {
                    Image(systemName: "clock.fill")
                        .foregroundColor(.gray)
                    Text("Toplam Hazırlık: \(viewModel.dailyNutrition.preparationTimeText)")
                        .font(.appCaption)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
        .padding(.horizontal)
    }
    
    // MARK: - Meal Category Section
    private func mealCategorySection(category: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // Category Header
            HStack {
                Text(category)
                    .font(.appTitle3)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button(action: {
                    selectedCategory = category
                    showingMealSelector = true
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "plus.circle.fill")
                        Text("Ekle")
                    }
                    .font(.appCaption)
                    .foregroundColor(.appPrimary)
                }
            }
            
            // Selected Meals
            let selectedMeals = viewModel.selectedMeals[category] ?? []
            
            if selectedMeals.isEmpty {
                // Empty State
                VStack(spacing: 8) {
                    Image(systemName: categoryIcon(category))
                        .font(.title)
                        .foregroundColor(.gray.opacity(0.5))
                    
                    Text("\(category) için yemek seçin")
                        .font(.appCaption)
                        .foregroundColor(.gray)
                    
                    Button("Yemek Ekle") {
                        selectedCategory = category
                        showingMealSelector = true
                    }
                    .font(.appCaption)
                    .foregroundColor(.appPrimary)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 80)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.3), style: StrokeStyle(lineWidth: 1, dash: [5]))
                        )
                )
            } else {
                // Selected Meals List
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 12) {
                    ForEach(selectedMeals) { meal in
                        SelectedMealCard(meal: meal) {
                            viewModel.removeMealFromPlan(meal: meal, category: category)
                        }
                    }
                }
            }
            
            // Quick suggestions
            if !viewModel.getMealsForCategory(category).isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Öneriler")
                        .font(.appCaption)
                        .foregroundColor(.gray)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(viewModel.getRandomMealsForCategory(category, count: 4)) { meal in
                                SuggestionMealCard(meal: meal) {
                                    viewModel.addMealToPlan(meal: meal, category: category)
                                }
                            }
                        }
                        .padding(.horizontal, 1)
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
    }
    
    private func categoryIcon(_ category: String) -> String {
        switch category {
        case "Kahvaltı":
            return "cup.and.saucer.fill"
        case "Öğle Yemeği":
            return "fork.knife"
        case "Akşam Yemeği":
            return "moon.fill"
        case "Atıştırmalık":
            return "leaf.fill"
        default:
            return "fork.knife"
        }
    }
}

// MARK: - Supporting Views
struct NutritionItem: View {
    let title: String
    let value: String
    let unit: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.appCaption)
                .foregroundColor(.gray)
            
            HStack(alignment: .lastTextBaseline, spacing: 2) {
                Text(value)
                    .font(.appTitle3)
                    .fontWeight(.bold)
                    .foregroundColor(color)
                
                Text(unit)
                    .font(.appCaption)
                    .foregroundColor(.gray)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct SelectedMealCard: View {
    let meal: Meal
    let onRemove: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(meal.name)
                    .font(.appBody)
                    .fontWeight(.medium)
                    .lineLimit(1)
                
                Spacer()
                
                Button(action: onRemove) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red.opacity(0.7))
                }
            }
            
            HStack(spacing: 12) {
                Label("\(meal.calories)", systemImage: "flame.fill")
                    .font(.appCaption)
                    .foregroundColor(.orange)
                
                Label("\(Int(meal.protein))g", systemImage: "dumbbell.fill")
                    .font(.appCaption)
                    .foregroundColor(.red)
            }
            
            if meal.preparationTime > 0 {
                Label(meal.preparationTimeText, systemImage: "clock")
                    .font(.appCaption)
                    .foregroundColor(.gray)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.appPrimary.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.appPrimary.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct SuggestionMealCard: View {
    let meal: Meal
    let onAdd: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(meal.name)
                .font(.appCaption)
                .fontWeight(.medium)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
            
            HStack(spacing: 8) {
                Text("\(meal.calories) kcal")
                    .font(.caption2)
                    .foregroundColor(.orange)
                
                Text("\(Int(meal.protein))g protein")
                    .font(.caption2)
                    .foregroundColor(.red)
            }
            
            Button(action: onAdd) {
                HStack(spacing: 4) {
                    Image(systemName: "plus.circle.fill")
                    Text("Ekle")
                }
                .font(.caption2)
                .foregroundColor(.appPrimary)
            }
        }
        .padding(10)
        .frame(width: 140, height: 80)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.1))
        )
    }
}

// MARK: - Meal Selector View
struct MealSelectorView: View {
    let category: String
    @ObservedObject var viewModel: MealPlanViewModel
    @Binding var isPresented: Bool
    
    @State private var searchText = ""
    @State private var selectedFilter = "Tümü"
    
    let filters = ["Tümü", "Düşük Kalori", "Yüksek Protein", "Hızlı Hazırlık"]
    
    var filteredMeals: [Meal] {
        var meals = viewModel.getMealsForCategory(category)
        
        // Arama filtresi
        if !searchText.isEmpty {
            meals = meals.filter { meal in
                meal.name.localizedCaseInsensitiveContains(searchText) ||
                meal.description.localizedCaseInsensitiveContains(searchText) ||
                meal.ingredients.contains { $0.localizedCaseInsensitiveContains(searchText) }
            }
        }
        
        // Özel filtreler
        switch selectedFilter {
        case "Düşük Kalori":
            meals = meals.filter { $0.calories <= 200 }
        case "Yüksek Protein":
            meals = meals.filter { $0.protein >= 15 }
        case "Hızlı Hazırlık":
            meals = meals.filter { $0.preparationTime <= 20 }
        default:
            break
        }
        
        return meals.sorted { $0.name < $1.name }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                header
                
                // Search and Filters
                searchAndFilters
                
                // Meals List
                if filteredMeals.isEmpty {
                    emptyState
                } else {
                    mealsList
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    // MARK: - Header
    private var header: some View {
        HStack {
            Button("İptal") {
                isPresented = false
            }
            .foregroundColor(.appPrimary)
            
            Spacer()
            
            VStack(spacing: 2) {
                Text(category)
                    .font(.appTitle3)
                    .fontWeight(.semibold)
                
                Text("\(filteredMeals.count) yemek")
                    .font(.appCaption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Placeholder for symmetry
            Button("İptal") {
                isPresented = false
            }
            .foregroundColor(.clear)
            .disabled(true)
        }
        .padding()
        .background(Color.white)
        .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1)
    }
    
    // MARK: - Search and Filters
    private var searchAndFilters: some View {
        VStack(spacing: 12) {
            // Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Yemek ara...", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.1))
            )
            
            // Filter Tabs
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(filters, id: \.self) { filter in
                        Button(action: {
                            selectedFilter = filter
                        }) {
                            Text(filter)
                                .font(.appCaption)
                                .fontWeight(.medium)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(selectedFilter == filter ? Color.appPrimary : Color.gray.opacity(0.2))
                                )
                                .foregroundColor(selectedFilter == filter ? .white : .gray)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding()
        .background(Color.white)
    }
    
    // MARK: - Meals List
    private var mealsList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(filteredMeals) { meal in
                    MealSelectionCard(
                        meal: meal,
                        isSelected: isSelected(meal),
                        onTap: {
                            toggleMealSelection(meal)
                        }
                    )
                }
            }
            .padding()
        }
    }
    
    // MARK: - Empty State
    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "fork.knife.circle")
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.5))
            
            VStack(spacing: 8) {
                Text("Yemek bulunamadı")
                    .font(.appTitle3)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                
                Text("Arama kriterlerinizi değiştirmeyi deneyin")
                    .font(.appBody)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            
            Button("Filtreleri Temizle") {
                searchText = ""
                selectedFilter = "Tümü"
            }
            .font(.appBody)
            .foregroundColor(.appPrimary)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Helper Methods
    private func isSelected(_ meal: Meal) -> Bool {
        viewModel.selectedMeals[category]?.contains { $0.id == meal.id } ?? false
    }
    
    private func toggleMealSelection(_ meal: Meal) {
        if isSelected(meal) {
            viewModel.removeMealFromPlan(meal: meal, category: category)
        } else {
            viewModel.addMealToPlan(meal: meal, category: category)
        }
    }
}

// MARK: - Meal Selection Card
struct MealSelectionCard: View {
    let meal: Meal
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                // Selection Indicator
                Circle()
                    .fill(isSelected ? Color.appPrimary : Color.clear)
                    .frame(width: 24, height: 24)
                    .overlay(
                        Circle()
                            .stroke(isSelected ? Color.appPrimary : Color.gray.opacity(0.5), lineWidth: 2)
                    )
                    .overlay(
                        Image(systemName: "checkmark")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .opacity(isSelected ? 1 : 0)
                    )
                
                // Meal Info
                VStack(alignment: .leading, spacing: 6) {
                    Text(meal.name)
                        .font(.appBody)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    
                    Text(meal.description)
                        .font(.appCaption)
                        .foregroundColor(.gray)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    // Nutrition Info
                    HStack(spacing: 16) {
                        NutritionLabel(
                            icon: "flame.fill",
                            value: "\(meal.calories)",
                            unit: "kcal",
                            color: .orange
                        )
                        
                        NutritionLabel(
                            icon: "dumbbell.fill",
                            value: String(format: "%.1f", meal.protein),
                            unit: "g",
                            color: .red
                        )
                        
                        if meal.preparationTime > 0 {
                            NutritionLabel(
                                icon: "clock",
                                value: meal.preparationTimeText,
                                unit: "",
                                color: .gray
                            )
                        }
                    }
                    
                    // Ingredients
                    if !meal.ingredients.isEmpty {
                        Text("Malzemeler: \(meal.ingredientsText)")
                            .font(.caption2)
                            .foregroundColor(.gray)
                            .lineLimit(1)
                    }
                }
                
                Spacer()
                
                // Arrow
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.gray.opacity(0.6))
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.appPrimary.opacity(0.1) : Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                isSelected ? Color.appPrimary.opacity(0.5) : Color.gray.opacity(0.2),
                                lineWidth: 1
                            )
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Nutrition Label (for MealSelector)
private struct NutritionLabel: View {
    let icon: String
    let value: String
    let unit: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption2)
                .foregroundColor(color)
            
            Text("\(value)\(unit.isEmpty ? "" : " \(unit)")")
                .font(.caption2)
                .foregroundColor(color)
        }
    }
}

#Preview {
    MealPlanView()
}




