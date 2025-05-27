//
//  DashboardView.swift
//  EatWell
//
//  Created by Tuğba Zengin on 28.03.2025.
//
import SwiftUI

struct DashboardView: View {
    let userName: String = "Tuğba" // Kullanıcı adını buraya dinamik ekleyeceğm
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer(minLength: 30)
                
                
                Text("Hoşgeldin, \(userName) ")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding(.top, 5)
                
              
                HStack(spacing: 20) {
                    InfoCard(icon: "flame.fill", title: "Günlük Kalori", value: "2000 kcal", color: .orange)
                    InfoCard(icon: "scalemass.fill", title: "Vücut Kitle Endeksi", value: "22.5 BMI", color: .green)
                    InfoCard(icon: "drop.fill", title: "Su Tüketimi", value: "2.5 L", color: .blue)
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
                
                
                MotivationCard(quote: "Başarı, küçük ama istikrarlı adımlarla gelir! 💪")
                
                Spacer()
            }
            .padding()
            .background(Color(red: 0.95, green: 1.0, blue: 0.95).edgesIgnoringSafeArea(.all))
            .navigationBarHidden(true)
        }
    }
}


struct InfoCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.largeTitle)
                .foregroundColor(color)
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 140)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color.gray.opacity(0.3), radius: 10, x: 5, y: 5)
                .shadow(color: Color.white, radius: 10, x: -5, y: -5)
        )
    }
}

struct AccessCard: View {
    let icon: String
    let title: String
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(.green)
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 80)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .shadow(color: Color.gray.opacity(0.3), radius: 10, x: 5, y: 5)
                .shadow(color: Color.white, radius: 10, x: -5, y: -5)
        )
    }
}

struct MotivationCard: View {
    let quote: String
    
    var body: some View {
        Text(quote)
            .font(.body)
            .foregroundColor(.primary)
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white)
                    .shadow(color: Color.gray.opacity(0.3), radius: 10, x: 5, y: 5)
                    .shadow(color: Color.white, radius: 10, x: -5, y: -5)
            )
            .padding(.horizontal)
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}

