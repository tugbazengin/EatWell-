//  ProfileSetupView.swift
//  EatWell
//
//  Created by Tuğba Zengin on 23.05.2025.
import SwiftUI

struct ProfileSetupView: View {
    @StateObject private var viewModel = ProfileSetupViewModel()

    var body: some View {
        BaseView(title: "Kullanıcı Bilgileri", showsScrollView: true) {
            VStack(spacing: 0) {
                headerSection
                personalInfoSection
                targetWeightSection
                calculationsSection
                saveButtonSection
            }
        }
        .navigationDestination(isPresented: $viewModel.isProfileCompleted) {
            DashboardView()
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 20) {
            // Profile Setup Icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.green.opacity(0.8),
                                Color.green.opacity(0.6)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                    .shadow(color: .green.opacity(0.3), radius: 8, x: 0, y: 4)
                
                Image(systemName: "person.crop.circle.badge.plus")
                    .font(.system(size: 50, weight: .semibold))
                    .foregroundColor(.white)
            }
            .padding(.top, 20)
            
            VStack(spacing: 8) {
                Text("Profilini Tamamla")
                    .font(.appTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Text("Kişiselleştirilmiş deneyim için bilgilerini gir")
                    .font(.appBody)
                    .foregroundColor(.black.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.bottom, 30)
    }
    
    // MARK: - Personal Information Section
    private var personalInfoSection: some View {
            VStack(spacing: 20) {
            SectionHeader(
                icon: "person.text.rectangle",
                title: "Kişisel Bilgiler",
                color: .green
            )
            
            VStack(spacing: 16) {
                ModernTextField(
                    icon: "person.fill",
                    placeholder: "Ad Soyad",
                    text: $viewModel.user.fullName,
                    color: .green
                )

                ModernTextField(
                    icon: "calendar",
                        placeholder: "Yaş",
                        text: Binding(
                            get: {
                                viewModel.user.age == 0 ? "" : String(viewModel.user.age)
                            },
                            set: {
                                viewModel.user.age = Int($0) ?? 0
                            }
                    ),
                    keyboardType: .numberPad,
                    color: .blue
                    )

                ModernTextField(
                    icon: "arrow.up.and.down",
                        placeholder: "Boy (cm)",
                        text: Binding(
                            get: {
                                viewModel.user.height == 0 ? "" : String(format: "%.0f", viewModel.user.height)
                            },
                            set: {
                                viewModel.user.height = Double($0) ?? 0
                            }
                    ),
                    keyboardType: .decimalPad,
                    color: .orange
                    )

                ModernTextField(
                    icon: "scalemass",
                        placeholder: "Kilo (kg)",
                        text: Binding(
                            get: {
                                viewModel.user.weight == 0 ? "" : String(format: "%.0f", viewModel.user.weight)
                            },
                            set: {
                                viewModel.user.weight = Double($0) ?? 0
                            }
                    ),
                    keyboardType: .decimalPad,
                    color: .green
                    )

                ModernTextField(
                    icon: "phone.fill",
                    placeholder: "Telefon Numarası",
                    text: $viewModel.user.phoneNumber,
                    keyboardType: .phonePad,
                    color: .blue
                )
                }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white)
                    .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
            )
        }
        .padding(.horizontal, 20)
    }
    
    // MARK: - Target Weight Section
    private var targetWeightSection: some View {
        VStack(spacing: 20) {
            SectionHeader(
                icon: "target",
                title: "Hedef Belirleme",
                color: .orange
            )
            
            VStack(spacing: 16) {
                HStack {
                    Image(systemName: "target")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.orange)
                    
                    Text("Hedef Kilo")
                        .font(.appHeadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)

                    Spacer()
                    
                    Text("\(Int(viewModel.user.targetWeight)) kg")
                        .font(.appTitle3)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                }

                Slider(value: $viewModel.user.targetWeight, in: 40...150, step: 1)
                    .accentColor(.orange)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white)
                    .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
            )
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
                }

    // MARK: - Calculations Section
    private var calculationsSection: some View {
        VStack(spacing: 20) {
            SectionHeader(
                icon: "chart.bar.fill",
                title: "Sağlık Hesaplamaları",
                color: .blue
            )
            
            VStack(spacing: 12) {
                // BMI Calculation
                ModernCalculationCard(
                    icon: "chart.bar.fill",
                    title: "Vücut Kitle Endeksi Hesapla",
                    result: viewModel.user.bmi,
                    action: viewModel.calculateBMI,
                    gradientColors: [Color.green.opacity(0.8), Color.green.opacity(0.6)]
                )

                // Calorie Calculation
                ModernCalculationCard(
                    icon: "flame.fill",
                    title: "Günlük Kalori Hesapla",
                    result: viewModel.user.dailyCalories.map { "\($0) kcal" },
                    action: viewModel.calculateDailyCalories,
                    gradientColors: [Color.orange.opacity(0.8), Color.orange.opacity(0.6)]
                )

                // Water Calculation
                ModernCalculationCard(
                    icon: "drop.fill",
                    title: "Günlük Su Tüketimi Hesapla",
                    result: viewModel.user.dailyWaterIntake.map { "\($0) L" },
                    action: viewModel.calculateDailyWaterIntake,
                    gradientColors: [Color.blue.opacity(0.8), Color.blue.opacity(0.6)]
                )
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
                    }

    // MARK: - Save Button Section
    private var saveButtonSection: some View {
        VStack(spacing: 20) {
            Button(action: viewModel.saveProfile) {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 20, weight: .bold))
                        
                    Text("Profili Kaydet")
                            .font(.appHeadline)
                        .fontWeight(.bold)
                    }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.green.opacity(0.8),
                            Color.green.opacity(0.6)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .green.opacity(0.3), radius: 8, x: 0, y: 4)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 30)
        .padding(.bottom, 40)
    }
}

// Section Header Component
struct SectionHeader: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(color)
            
            Text(title)
                .font(.appTitle3)
                .fontWeight(.bold)
                .foregroundColor(.black)
            
            Spacer()
        }
        .padding(.horizontal, 20)
                    }
}

// Simplified Modern Text Field Component
struct ModernTextField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.1))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(color)
            }
            
            TextField(placeholder, text: $text)
                            .font(.appHeadline)
                .foregroundColor(.black)
                .keyboardType(keyboardType)
        }
        .padding(.vertical, 12)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(color.opacity(0.2)),
            alignment: .bottom
        )
    }
}

// Modern Calculation Card Component
struct ModernCalculationCard: View {
    let icon: String
    let title: String
    let result: String?
    let action: () -> Void
    let gradientColors: [Color]
    
    var body: some View {
        VStack(spacing: 16) {
            Button(action: action) {
                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(.white.opacity(0.2))
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: icon)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                    Text(title)
                            .font(.appHeadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: gradientColors),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: gradientColors.first?.opacity(0.3) ?? .clear, radius: 6, x: 0, y: 3)
                )
            }
            
            if let result = result, !result.isEmpty {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    
                    Text(result)
                        .font(.appHeadline)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
            }
        }
    }
}
