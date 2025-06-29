//
//  SplashViewModel.swift
//  EatWell
//
//  Created by Tuğba Zengin on 25.05.2025.
//

import SwiftUI
import Combine

final class SplashViewModel: ObservableObject {
    @Published var showText = false
    @Published var showSlogan = false
    @Published var showLoading = false
    @Published var navigateToAuth = false
    @Published var navigateToDashboard = false
    
    let title = "EatWell"
    let slogan = "Sağlıklı beslen, mutlu yaşa!"
    
    func startAnimationSequence() {
        // İlk animasyon hemen başlasın
        DispatchQueue.main.async {
            withAnimation {
                self.showText = true
            }
        }
        
        // Slogan daha hızlı gelsin
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            withAnimation {
                self.showSlogan = true
            }
        }
        
        // Loading indicator da daha hızlı
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation {
                self.showLoading = true
            }
        }
        
        // Toplam süreyi kısalttık
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            self.checkLoginStatus()
        }
    }
    
    private func checkLoginStatus() {
        // Giriş yapmış kullanıcıları Dashboard'a yönlendir
        if UserDefaults.standard.string(forKey: "user_token") != nil {
            self.navigateToDashboard = true
        } else {
            self.navigateToAuth = true
        }
    }
}
