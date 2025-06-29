//
//  ContentView.swift
//  EatWell
//
//  Created by Tuğba Zengin on 27.03.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Ana Sayfa")
                }
            
            MealPlanView()
                .tabItem {
                    Image(systemName: "leaf.fill")
                    Text("Beslenme")
                }
            
            AppointmentListView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Randevular")
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profil")
                }
        }
        .accentColor(.green)
    }
}

#Preview {
    ContentView()
}
