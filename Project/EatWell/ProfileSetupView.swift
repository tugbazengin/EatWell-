//
//  ProfileSetupView.swift
//  EatWell
//
//  Created by Tuğba Zengin on 28.03.2025.
import SwiftUI

struct ProfileSetupView: View {
    @State private var fullName: String = ""
    @State private var age: String = ""
    @State private var height: String = ""
    @State private var weight: String = ""
    @State private var phoneNumber: String = ""
    @State private var targetWeight: Double = 70.0
    @State private var bmi: String = ""
    @State private var dailyCalories: String = ""
    @State private var dailyWaterIntake: String = ""
    
    @State private var isProfileCompleted: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.95, green: 1.0, blue: 0.95)
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 20) {
                        Text("Kullanıcı Bilgileri")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .padding(.top, 20)
                        
                        Group {
                            CustomTextField(placeholder: "Ad Soyad", text: $fullName)
                            CustomTextField(placeholder: "Yaş", text: $age)
                            CustomTextField(placeholder: "Boy (cm)", text: $height)
                            CustomTextField(placeholder: "Kilo (kg)", text: $weight)
                            CustomTextField(placeholder: "Telefon Numarası", text: $phoneNumber)
                        }
                        .padding(.horizontal)
                        
                        VStack {
                            Text("Hedef Kilo: \(Int(targetWeight)) kg")
                                .font(.title3)
                                .foregroundColor(.black)
                            
                            Slider(value: $targetWeight, in: 40...150, step: 1)
                                .padding(.horizontal, 30)
                        }
                        
                        CustomButton(title: "Vücut Kitle Endeksi Hesapla", action: calculateBMI)
                        if !bmi.isEmpty {
                            InfoBox(text: "BMI: \(bmi)", color: .orange)
                        }
                        
                        CustomButton(title: "Günlük Kalori Hesapla", action: calculateDailyCalories)
                        if !dailyCalories.isEmpty {
                            InfoBox(text: "\(dailyCalories) kcal", color: .green)
                        }
                        
                        CustomButton(title: "Günlük Su Tüketimi Hesapla", action: calculateDailyWaterIntake)
                        if !dailyWaterIntake.isEmpty {
                            InfoBox(text: "\(dailyWaterIntake) L", color: .blue)
                        }
                        
                        CustomButton(title: "Profili Kaydet", action: saveProfile)
                        
                    }
                }
                .navigationDestination(isPresented: $isProfileCompleted) {
                    DashboardView()
                }
            }
        }
    }
    
    func calculateBMI() {
        guard let h = Double(height), let w = Double(weight), h > 0 else { return }
        let heightInMeters = h / 100
        let bmiValue = w / (heightInMeters * heightInMeters)
        bmi = String(format: "%.2f", bmiValue)
    }
    
    func calculateDailyCalories() {
        guard let h = Double(height), let w = Double(weight), let a = Double(age), h > 0 else { return }
        let bmr = 10 * w + 6.25 * h - 5 * a + 5
        let deficitCalories = (w - targetWeight) * 7700 / 30
        let dailyCalorieIntake = max(1200, bmr - deficitCalories)
        
        dailyCalories = String(format: "%.0f", dailyCalorieIntake)
    }
    
    func calculateDailyWaterIntake() {
        guard let w = Double(weight) else { return }
        let waterIntake = w * 0.033
        dailyWaterIntake = String(format: "%.2f", waterIntake)
    }
    
    func saveProfile() {
       
        isProfileCompleted = true
    }
}

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.9)).shadow(radius: 3))
            .foregroundColor(.black)
            .keyboardType(.default)
    }
}

struct CustomButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
                .frame(width: 250)
                .background(LinearGradient(gradient: Gradient(colors: [Color.green, Color.green.opacity(0.7)]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(20)
                .shadow(radius: 5)
        }
    }
}

struct InfoBox: View {
    let text: String
    let color: Color
    
    var body: some View {
        Text(text)
            .font(.title2)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding()
            .frame(width: 200)
            .background(RoundedRectangle(cornerRadius: 15).fill(color.opacity(0.8)))
            .shadow(radius: 5)
    }
}

#Preview {
    ProfileSetupView()
}
