//
//  ProfileSetupView.swift
//  EatWell
//
//  Created by Tuğba Zengin on 23.05.2025.
//
import SwiftUI

struct ProfileSetupView: View {
    @StateObject private var viewModel = ProfileSetupViewModel()

    var body: some View {
        BaseView(title: "Kullanıcı Bilgileri", showsScrollView: true) {
            VStack(spacing: 20) {
                Group {
                    CustomTextField(placeholder: "Ad Soyad", text: $viewModel.user.fullName)

                    CustomTextField(
                        placeholder: "Yaş",
                        text: Binding(
                            get: {
                                viewModel.user.age == 0 ? "" : String(viewModel.user.age)
                            },
                            set: {
                                viewModel.user.age = Int($0) ?? 0
                            }
                        )
                    )

                    CustomTextField(
                        placeholder: "Boy (cm)",
                        text: Binding(
                            get: {
                                viewModel.user.height == 0 ? "" : String(format: "%.0f", viewModel.user.height)
                            },
                            set: {
                                viewModel.user.height = Double($0) ?? 0
                            }
                        )
                    )

                    CustomTextField(
                        placeholder: "Kilo (kg)",
                        text: Binding(
                            get: {
                                viewModel.user.weight == 0 ? "" : String(format: "%.0f", viewModel.user.weight)
                            },
                            set: {
                                viewModel.user.weight = Double($0) ?? 0
                            }
                        )
                    )

                    CustomTextField(placeholder: "Telefon Numarası", text: $viewModel.user.phoneNumber)
                }
                .appContentsPadding()

                VStack(spacing: 10) {
                    Text("Hedef Kilo: \(Int(viewModel.user.targetWeight)) kg")
                        .font(.appBody)
                        .foregroundColor(.black)

                    Slider(value: $viewModel.user.targetWeight, in: 40...150, step: 1)
                        .padding(.horizontal, 30)
                }

                VStack(spacing: 10) {
                    Button(action: viewModel.calculateBMI) {
                        Text("Vücut Kitle Endeksi Hesapla")
                            .font(.appHeadline)
                    }
                    .appButtonStyle(color: .orange)

                    if !viewModel.user.bmi.isEmpty {
                        InfoBox(text: "BMI: \(viewModel.user.bmi)", color: .orange)
                    }

                    Button(action: viewModel.calculateDailyCalories) {
                        Text("Günlük Kalori Hesapla")
                            .font(.appHeadline)
                    }
                    .appButtonStyle(color: .green)

                    if !viewModel.user.dailyCalories.isEmpty {
                        InfoBox(text: "\(viewModel.user.dailyCalories) kcal", color: .green)
                    }

                    Button(action: viewModel.calculateDailyWaterIntake) {
                        Text("Günlük Su Tüketimi Hesapla")
                            .font(.appHeadline)
                    }
                    .appButtonStyle(color: .blue)

                    if !viewModel.user.dailyWaterIntake.isEmpty {
                        InfoBox(text: "\(viewModel.user.dailyWaterIntake) L", color: .blue)
                    }

                    Button(action: viewModel.saveProfile) {
                        Text("Profili Kaydet")
                            .font(.appHeadline)
                    }
                    .appButtonStyle(color: .black)
                }
                .appContentsPadding()
            }
        }
        .navigationDestination(isPresented: $viewModel.isProfileCompleted) {
            DashboardView()
        }
    }
}

