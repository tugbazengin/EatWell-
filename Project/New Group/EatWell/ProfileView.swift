//
//  ProfileView.swift
//  EatWell
//
//  Created by Tuğba Zengin on 27.03.2025.
//
import SwiftUI

struct ProfileView: View {
    @State private var fullName: String = "Adınız Soyadınız"
    @State private var age: String = "25"
    @State private var height: String = "170"
    @State private var weight: String = "70"
    @State private var phoneNumber: String = "555-123-4567"
    @State private var targetWeight: String = "65"
    @State private var bmi: String = "22.5"
    @State private var dailyCalories: String = "2000"
    @State private var dailyWater: String = "2.3"
    @State private var isEditing: Bool = false
    @State private var showDeleteConfirmation: Bool = false
    @State private var navigateToAuth: Bool = false 

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 120, height: 120)
                        .foregroundColor(.gray)
                        .padding()
                    
                   
                    VStack(alignment: .leading, spacing: 10) {
                        ProfileRow(label: "Ad Soyad", value: $fullName, isEditing: isEditing)
                        ProfileRow(label: "Yaş", value: $age, isEditing: isEditing)
                        ProfileRow(label: "Boy (cm)", value: $height, isEditing: isEditing)
                        ProfileRow(label: "Kilo (kg)", value: $weight, isEditing: isEditing)
                        ProfileRow(label: "Telefon", value: $phoneNumber, isEditing: isEditing)
                        ProfileRow(label: "Hedef Kilo", value: $targetWeight, isEditing: isEditing)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.9)).shadow(radius: 3))
                    .padding()
                    
                 
                    ProfileInfoCard(title: "Vücut Kitle Endeksi", value: bmi, icon: "chart.bar.fill", color: .purple)
                    ProfileInfoCard(title: "Günlük Kalori İhtiyacı", value: "\(dailyCalories) kcal", icon: "flame.fill", color: .red)
                    ProfileInfoCard(title: "Günlük Su Tüketimi", value: "\(dailyWater) L", icon: "drop.fill", color: .blue)
                    
                    Spacer()
                }
            }
            .navigationTitle("Profil")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Profil")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                  
                    Button(action: { showDeleteConfirmation = true }) {
                        Image(systemName: "trash")
                            .font(.title)
                            .foregroundColor(.red)
                    }
                 
                    Button(action: {
                        navigateToAuth = true
                    }) {
                        Image(systemName: "rectangle.portrait.and.arrow.forward")
                            .font(.title)
                            .foregroundColor(.blue)
                    }
                }
            }
            .alert(isPresented: $showDeleteConfirmation) {
                Alert(
                    title: Text("Profil Silinsin Mi?"),
                    message: Text("Bu işlemi geri alamazsınız."),
                    primaryButton: .destructive(Text("Evet"), action: {
                        deleteProfile()
                    }),
                    secondaryButton: .cancel(Text("Hayır"))
                )
            }
            .overlay(
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: { isEditing.toggle() }) {
                            Image(systemName: "pencil")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.black)
                                .padding()
                        }
                    }
                }
                .padding(),
                alignment: .bottomTrailing
            )
            
            .fullScreenCover(isPresented: $navigateToAuth) {
                AuthView()
            }
        }
    }

 
    private func deleteProfile() {
        navigateToAuth = true
    }
}

struct ProfileRow: View {
    var label: String
    @Binding var value: String
    var isEditing: Bool
    
    var body: some View {
        HStack {
            Text(label + ":")
                .fontWeight(.bold)
                .foregroundColor(.black)
            Spacer()
            if isEditing {
                TextField("", text: $value)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 120)
                    .keyboardType(label.contains("Yaş") || label.contains("Kilo") || label.contains("Boy") ? .numberPad : .default)
            } else {
                Text(value)
                    .foregroundColor(.gray)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
        }
        .padding(.horizontal)
    }
}


struct ProfileInfoCard: View {
    var title: String
    var value: String
    var icon: String
    var color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.white)
                .frame(width: 30, height: 30)
                .padding()
                .background(color)
                .clipShape(Circle())

            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(color.opacity(0.8))
        .cornerRadius(15)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}

#Preview {
    ProfileView()
}





