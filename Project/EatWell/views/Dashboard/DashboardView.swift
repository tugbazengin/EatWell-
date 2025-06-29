//
//  DashboardView.swift
//  EatWell
//
//  Created by Tuğba Zengin on 22.05.2025.
//
import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel()

    var body: some View {
        NavigationStack {
            BaseView(showsScrollView: true) {
                VStack(spacing: 0) {
                    // Header Section with gradient background
                VStack(spacing: 20) {
                        Spacer(minLength: 20)

                        // Welcome text with enhanced styling
                        VStack(spacing: 8) {
                            Text("Hoşgeldin")
                                .font(.appBody)
                                .foregroundColor(.black.opacity(0.7))
                            
                            Text(viewModel.userName)
                        .font(.appTitle)
                                .fontWeight(.bold)
                        .foregroundColor(.black)
                        }
                        .padding(.top, 10)

                        // Stats cards with modern design
                        HStack(spacing: 12) {
                            StatCard(
                                icon: "flame.fill",
                                title: "Kalori",
                                value: "\(viewModel.dailyCalories)",
                                color: .orange,
                                gradientColors: [Color.orange.opacity(0.8), Color.orange.opacity(0.6)]
                            )
                            
                            StatCard(
                                icon: "figure.walk",
                                title: "BMI",
                                value: "\(viewModel.bmi)",
                                color: .green,
                                gradientColors: [Color.green.opacity(0.8), Color.green.opacity(0.6)]
                            )
                            
                            StatCard(
                                icon: "drop.fill",
                                title: "Su",
                                value: "\(viewModel.waterIntake)",
                                color: .blue,
                                gradientColors: [Color.blue.opacity(0.8), Color.blue.opacity(0.6)]
                            )
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 30)
                    
                    // Navigation cards section
                    VStack(spacing: 16) {
                        // Main feature card - Meal Plan
                        NavigationLink(destination: MealPlanView()) {
                            MainFeatureCard(
                                icon: "leaf.fill",
                                title: "Beslenme Planı",
                                subtitle: "Kişiye özel beslenme programın",
                                gradientColors: [Color.green.opacity(0.8), Color.green.opacity(0.6)]
                            )
                        }

                        // Secondary cards in grid
                        HStack(spacing: 16) {
                            NavigationLink(destination: AppointmentView()) {
                                SecondaryFeatureCard(
                                    icon: "calendar.badge.plus",
                                    title: "Randevu Al",
                                    color: .blue
                                )
                            }
                            
                            NavigationLink(destination: AppointmentListView()) {
                                SecondaryFeatureCard(
                                    icon: "calendar",
                                    title: "Randevularım",
                                    color: .orange
                                )
                            }
                        }

                        NavigationLink(destination: ProfileView()) {
                            SecondaryFeatureCard(
                                icon: "person.crop.circle.fill",
                                title: "Profil Bilgileri",
                                color: .green,
                                isWide: true
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Enhanced motivation card
                    EnhancedMotivationCard(quote: viewModel.motivationQuote)
                        .padding(.top, 20)

                    Spacer(minLength: 20)
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                viewModel.refreshDashboard()
            }
        }
    }
}

#Preview {
    DashboardView()
}


