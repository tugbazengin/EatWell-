//
//  MealPlanView.swift
//  EatWell
//
//  Created by Tuğba Zengin on 22.05.2025.
//
import SwiftUI

struct MealPlanView: View {
    @StateObject private var viewModel = MealPlanViewModel()

    var body: some View {
        BaseView(title: "Beslenme Planı", showsScrollView: false) {
            VStack {
                Picker("Gün Seç", selection: $viewModel.selectedDay) {
                    ForEach(viewModel.mealPlan.keys.sorted(), id: \.self) { day in
                        Text(day).tag(day)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)

                ScrollView {
                    VStack(spacing: 15) {
                        if let mealsForDay = viewModel.mealPlan[viewModel.selectedDay] {
                            ForEach(["Kahvaltı", "Öğle Yemeği", "Akşam Yemeği", "Ara Öğün"], id: \.self) { mealType in
                                if let meals = mealsForDay[mealType] {
                                    MealSection(title: mealType, meals: meals)
                                }
                            }
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
//  MealPlanView.swift
//  EatWell
//
//  Created by Tuğba Zengin on 22.05.2025.
//
import SwiftUI

struct MealPlanView: View {
    @StateObject private var viewModel = MealPlanViewModel()

    var body: some View {
        BaseView(title: "Beslenme Planı") {
            VStack {
                Picker("Gün Seç", selection: $viewModel.selectedDay) {
                    ForEach(viewModel.mealPlan.keys.sorted(), id: \.self) { day in
                        Text(day).tag(day)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)

                ScrollView {
                    VStack(spacing: 15) {
                        if let mealsForDay = viewModel.mealPlan[viewModel.selectedDay] {
                            ForEach(["Kahvaltı", "Öğle Yemeği", "Akşam Yemeği", "Ara Öğün"], id: \.self) { mealType in
                                if let meals = mealsForDay[mealType] {
                                    MealSection(title: mealType, meals: meals)
                                }
                            }
                        }
                    }
                    .appContentsPadding()
                }
            }
            .appContentsPadding()
        }
    }
}




