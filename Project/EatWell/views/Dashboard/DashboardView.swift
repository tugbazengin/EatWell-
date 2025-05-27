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
                VStack(spacing: 20) {
                    Spacer(minLength: 30)

                    Text("Hoşgeldin, \(viewModel.userName)")
                        .font(.appTitle)
                        .foregroundColor(.black)
                        .padding(.top, 5)

                    VStack(spacing: 16) {
                        InfoBox(text: "Günlük Kalori: \(viewModel.dailyCalories)", color: .orange)
                        InfoBox(text: "Vücut Kitle Endeksi: \(viewModel.bmi)", color: .green)
                        InfoBox(text: "Su Tüketimi: \(viewModel.waterIntake)", color: .blue)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 20)

                    VStack(spacing: 10) {
                        HStack(spacing: 20) {
                            NavigationLink(destination: MealPlanView()) {
                                AccessCard(icon: "leaf.fill", title: "Beslenme Planı")
                            }
                            NavigationLink(destination: MealRecipesView()) {
                                AccessCard(icon: "book.fill", title: "Yemek Önerileri")
                            }
                        }

                        HStack(spacing: 20) {
                            NavigationLink(destination: AppointmentView()) {
                                AccessCard(icon: "calendar.badge.plus", title: "Randevu Alma")
                            }
                            NavigationLink(destination: AppointmentListView()) {
                                AccessCard(icon: "calendar", title: "Randevularım")
                            }
                        }

                        NavigationLink(destination: ProfileView()) {
                            AccessCard(icon: "person.crop.circle", title: "Profil Bilgileri")
                        }
                    }

                    MotivationCard(quote: viewModel.motivationQuote)

                    Spacer()
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    DashboardView()
}


