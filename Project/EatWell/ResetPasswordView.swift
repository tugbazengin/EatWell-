//
//  ResetPasswordView.swift
//  EatWell
//
//  Created by Tuğba Zengin on 28.03.2025.
//
import SwiftUI

struct ResetPasswordView: View {
    @State private var email: String = ""
    @State private var phoneNumber: String = ""
    @State private var verificationCode: String = ""
    @State private var newPassword: String = ""
    
    @State private var resetMethod: ResetMethod = .email
    @State private var isVerificationSent = false
    @State private var isVerified = false
    @State private var isPasswordReset = false
    @State private var navigateToAuthView = false
    
    enum ResetMethod {
        case email, phone
    }
    
    @Environment(\.presentationMode) var presentationMode // Geri dönüşü kapamak için
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Şifre Sıfırlama")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.green)
            
            Picker("Sıfırlama Yöntemi", selection: $resetMethod) {
                Text("E-posta ile").tag(ResetMethod.email)
                Text("Telefon ile").tag(ResetMethod.phone)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
            if resetMethod == .email {
                TextField("E-posta adresinizi girin", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                if isVerificationSent {
                    TextField("E-postaya gelen doğrulama kodunu girin", text: $verificationCode)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                }
                
                if isVerified {
                    SecureField("Yeni Şifre", text: $newPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                }
                
                Button(action: handleButtonPress) {
                    Text(isPasswordReset ? "Şifre Sıfırlandı" : (isVerified ? "Şifreyi Kaydet" : (isVerificationSent ? "Doğrula" : "Şifre Sıfırla")))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(isPasswordReset ? Color.gray : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(isPasswordReset)
                
            } else {
                TextField("Telefon numaranızı girin", text: $phoneNumber)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                if isVerificationSent {
                    TextField("SMS ile gelen kodu girin", text: $verificationCode)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                }
                
                if isVerified {
                    SecureField("Yeni Şifre", text: $newPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                }
                
                Button(action: handleButtonPress) {
                    Text(isPasswordReset ? "Şifre Sıfırlandı" : (isVerified ? "Şifreyi Kaydet" : (isVerificationSent ? "Doğrula" : "SMS Gönder")))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(isPasswordReset ? Color.gray : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(isPasswordReset)
            }
            
            if isPasswordReset {
                Text("Şifre başarıyla sıfırlandı!")
                    .foregroundColor(.green)
                    .fontWeight(.bold)
            }
        }
        .padding()
        .fullScreenCover(isPresented: $navigateToAuthView) {
            AuthView()
                .onAppear {
                    self.presentationMode.wrappedValue.dismiss() 
                }
        }
    }
    
    private func handleButtonPress() {
        if isVerified {
            isPasswordReset = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                navigateToAuthView = true
            }
        } else if isVerificationSent {
            isVerified = true
        } else {
            isVerificationSent = true
        }
    }
}

#Preview {
    ResetPasswordView()
}

