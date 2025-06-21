//
//  ProfileView.swift
//  EatWell
//
//  Created by Tuğba Zengin on 23.05.2025.
import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    
    // Numeric alanları String olarak bind etmek için computed property'ler
    private var ageBinding: Binding<String> {
        Binding(
            get: { String(viewModel.profile.age) },
            set: { newValue in
                if let intValue = Int(newValue) {
                    viewModel.profile.age = intValue
                    if viewModel.isEditing {
                        viewModel.calculateHealthMetrics()
                    }
                }
            }
        )
    }
    
    private var heightBinding: Binding<String> {
        Binding(
            get: { String(viewModel.profile.height) },
            set: { newValue in
                if let doubleValue = Double(newValue) {
                    viewModel.profile.height = doubleValue
                    if viewModel.isEditing {
                        viewModel.calculateHealthMetrics()
                    }
                }
            }
        )
    }
    
    private var weightBinding: Binding<String> {
        Binding(
            get: { String(viewModel.profile.weight) },
            set: { newValue in
                if let doubleValue = Double(newValue) {
                    viewModel.profile.weight = doubleValue
                    if viewModel.isEditing {
                        viewModel.calculateHealthMetrics()
                    }
                }
            }
        )
    }
    
    private var targetWeightBinding: Binding<String> {
        Binding(
            get: { String(viewModel.profile.targetWeight) },
            set: { newValue in
                if let doubleValue = Double(newValue) {
                    viewModel.profile.targetWeight = doubleValue
                    if viewModel.isEditing {
                        viewModel.calculateHealthMetrics()
                    }
                }
            }
        )
    }

    var body: some View {
        NavigationStack {
            BaseView(title: "Profil") {
                ScrollView {
                    VStack(spacing: 20) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 120, height: 120)
                            .foregroundColor(.gray)
                            .padding(.top)

                        VStack(alignment: .leading, spacing: 15) {
                            ProfileRow(label: "Ad Soyad", value: $viewModel.profile.fullName, isEditing: viewModel.isEditing)
                            ProfileRow(label: "Yaş", value: ageBinding, isEditing: viewModel.isEditing, keyboardType: .numberPad)
                            ProfileRow(label: "Boy (cm)", value: heightBinding, isEditing: viewModel.isEditing, keyboardType: .decimalPad)
                            ProfileRow(label: "Kilo (kg)", value: weightBinding, isEditing: viewModel.isEditing, keyboardType: .decimalPad)
                            ProfileRow(label: "Telefon", value: $viewModel.profile.phoneNumber, isEditing: viewModel.isEditing, keyboardType: .phonePad)
                            ProfileRow(label: "Hedef Kilo", value: targetWeightBinding, isEditing: viewModel.isEditing, keyboardType: .decimalPad)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.white.opacity(0.9))
                                .shadow(color: Color.gray.opacity(0.25), radius: 6, x: 3, y: 3)
                        )
                        .padding(.horizontal)

                        VStack(spacing: 15) {
                            ProfileInfoCard(title: "Vücut Kitle Endeksi", value: viewModel.profile.bmi ?? "-", icon: "chart.bar.fill", color: .purple)
                            ProfileInfoCard(title: "Günlük Kalori İhtiyacı", value: "\(viewModel.profile.dailyCalories ?? "0") kcal", icon: "flame.fill", color: .red)
                            ProfileInfoCard(title: "Günlük Su Tüketimi", value: "\(viewModel.profile.dailyWaterIntake ?? "0.00") L", icon: "drop.fill", color: .blue)
                        }
                        .padding(.horizontal)

                        Spacer(minLength: 40)
                    }
                }
                .onAppear {
                    viewModel.fetchProfile()
                }
                .overlay(
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: { 
                                if viewModel.isEditing {
                                    // Düzenleme modundan çıkılırken profili kaydet
                                    viewModel.updateProfile()
                                }
                                viewModel.isEditing.toggle() 
                            }) {
                                ZStack {
                                    if viewModel.isLoading {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                            .frame(width: 36, height: 36)
                                    } else {
                                        Image(systemName: viewModel.isEditing ? "checkmark.circle.fill" : "pencil.circle.fill")
                                            .resizable()
                                            .frame(width: 36, height: 36)
                                            .foregroundColor(viewModel.isEditing ? .green : .black)
                                    }
                                }
                                .background(
                                    Circle()
                                        .fill(viewModel.isLoading ? Color.blue : Color.clear)
                                        .frame(width: 44, height: 44)
                                )
                                .shadow(radius: 4)
                            }
                            .disabled(viewModel.isLoading)
                        }
                        .padding()
                    }
                )
                .overlay(
                    // Success Toast
                    VStack {
                        if viewModel.showSuccessMessage {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                Text("Profil başarıyla güncellendi!")
                                    .font(.appBody)
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.black.opacity(0.8))
                            )
                            .transition(.move(edge: .top).combined(with: .opacity))
                            .animation(.spring(), value: viewModel.showSuccessMessage)
                        }
                        Spacer()
                    }
                    .padding(.top, 60)
                )
                .alert(isPresented: $viewModel.showDeleteConfirmation) {
                    Alert(
                        title: Text("Profil Silinsin Mi?"),
                        message: Text("Bu işlemi geri alamazsınız."),
                        primaryButton: .destructive(Text("Evet"), action: viewModel.deleteProfile),
                        secondaryButton: .cancel(Text("Hayır"))
                    )
                }
                .fullScreenCover(isPresented: $viewModel.navigateToAuth) {
                    AuthView()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Profil")
                        .font(.appHeadline)
                        .foregroundColor(.primary)
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: { viewModel.showDeleteConfirmation = true }) {
                        Image(systemName: "trash")
                            .font(.title2)
                            .foregroundColor(.red)
                    }
                    Button(action: { viewModel.navigateToAuth = true }) {
                        Image(systemName: "rectangle.portrait.and.arrow.forward")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }
            }
        }
    }
}
