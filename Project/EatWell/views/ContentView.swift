//
//  ContentView.swift
//  EatWell
//
//  Created by Tuğba Zengin on 27.03.2025.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @State private var showSplash = true
    
    var body: some View {
        if showSplash {
            SplashView()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                        withAnimation {
                            showSplash = false
                        }
                    }
                }
        } else {
            if isLoggedIn {
                DashboardView() // Kullanıcı giriş yaptıysa Dashboard gösterilir
            } else {
                AuthView() // Kullanıcı giriş yapmadıysa AuthView gösterilir
            }
        }
    }
}

#Preview {
    ContentView()
}
