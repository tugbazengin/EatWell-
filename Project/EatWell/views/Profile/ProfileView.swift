//
//  ProfileView.swift
//  EatWell
//
//  Created by Tuğba Zengin on 23.05.2025.
import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()

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
                            ProfileRow(label: "Yaş", value: $viewModel.profile.age, isEditing: viewModel.isEditing, keyboardType: .numberPad)
                            ProfileRow(label: "Boy (cm)", value: $viewModel.profile.height, isEditing: viewModel.isEditing, keyboardType: .decimalPad)
                            ProfileRow(label: "Kilo (kg)", value: $viewModel.profile.weight, isEditing: viewModel.isEditing, keyboardType: .decimalPad)
                            ProfileRow(label: "Telefon", value: $viewModel.profile.phoneNumber, isEditing: viewModel.isEditing, keyboardType: .phonePad)
                            ProfileRow(label: "Hedef Kilo", value: $viewModel.profile.targetWeight, isEditing: viewModel.isEditing, keyboardType: .decimalPad)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.white.opacity(0.9))
                                .shadow(color: Color.gray.opacity(0.25), radius: 6, x: 3, y: 3)
                        )
                        .padding(.horizontal)

                        // Eğer dailyWater Double ise, direkt formatlayabiliriz
                        let dailyWaterString = String(format: "%.2f", viewModel.profile.dailyWater)

                        VStack(spacing: 15) {
                            ProfileInfoCard(title: "Vücut Kitle Endeksi", value: viewModel.profile.bmi ?? "-", icon: "chart.bar.fill", color: .purple)
                            ProfileInfoCard(title: "Günlük Kalori İhtiyacı", value: "\(viewModel.profile.dailyCalories ?? "0") kcal", icon: "flame.fill", color: .red)
                            ProfileInfoCard(title: "Günlük Su Tüketimi", value: "\(dailyWaterString) L", icon: "drop.fill", color: .blue)
                        }
                        .padding(.horizontal)

                        Spacer(minLength: 40)
                    }
                }
                .overlay(
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: { viewModel.isEditing.toggle() }) {
                                Image(systemName: viewModel.isEditing ? "checkmark.circle.fill" : "pencil.circle.fill")
                                    .resizable()
                                    .frame(width: 36, height: 36)
                                    .foregroundColor(viewModel.isEditing ? .green : .black)
                                    .shadow(radius: 4)
                            }
                        }
                        .padding()
                    }
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
