//
//  ResetPasswordView.swift
//  EatWell
//
//  Created by Tuğba Zengin on 24.05.2025.
//
import SwiftUI

struct ResetPasswordView: View {
    @StateObject private var viewModel = ResetPasswordViewModel()
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationStack {
            BaseView(title: nil, showsScrollView: false) {
                VStack(spacing: 0) {
                    headerSection
                    formSection
                    actionSection
                    
                    if viewModel.isPasswordReset {
                        successSection
                    }
                    
                    Spacer()
                    backToLoginSection
                }
                .padding(.horizontal, 20)
            }
            .overlay(errorToastOverlay)
            .navigationBarHidden(true)
        }
        .fullScreenCover(isPresented: $viewModel.navigateToAuthView) {
            AuthView()
                .onAppear {
                    viewModel.resetAll()
                }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 20) {
            // Icon with gradient background
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.blue.opacity(0.8),
                                Color.blue.opacity(0.6)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                    .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
                
                Image(systemName: getHeaderIcon())
                    .font(.system(size: 45, weight: .semibold))
                    .foregroundColor(.white)
            }
            .padding(.top, 30)
            
            VStack(spacing: 8) {
                Text(getHeaderTitle())
                            .font(.appTitle)
                    .fontWeight(.bold)
                            .foregroundColor(.black)
                        
                        Text(getSubtitleText())
                            .font(.appBody)
                    .foregroundColor(.black.opacity(0.7))
                            .multilineTextAlignment(.center)
                    .lineSpacing(2)
            }
        }
        .padding(.bottom, 40)
                    }
                    
    // MARK: - Form Section
    private var formSection: some View {
        VStack(spacing: 25) {
                        if !viewModel.isVerificationSent {
                            // Email Input
                ModernAuthTextField(
                    icon: "envelope.fill",
                                placeholder: "E-posta adresinizi girin", 
                                text: $viewModel.resetData.email,
                    keyboardType: .emailAddress,
                    color: .blue
                            )
                        } else if !viewModel.isVerified {
                // Verification Code Input - FIX: Normal keyboard for alphanumeric codes
                VStack(spacing: 15) {
                    HStack {
                        Image(systemName: "number.circle")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.orange)
                        Text("Doğrulama Kodu")
                            .font(.appHeadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                        Spacer()
                    }
                    
                    ModernAuthTextField(
                        icon: "key.fill",
                        placeholder: "6 haneli kod (harf-sayı karışık)",
                                    text: $viewModel.resetData.verificationCode,
                        keyboardType: .default,  // Changed from .numberPad to .default
                        color: .orange
                                )
                    
                    HStack {
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(.blue.opacity(0.7))
                        Text("Kodunuz harf ve sayılardan oluşabilir")
                            .font(.appCaption)
                            .foregroundColor(.black.opacity(0.6))
                        Spacer()
                    }
                            }
                        } else if !viewModel.isPasswordReset {
                            // New Password Input
                VStack(spacing: 20) {
                    HStack {
                        Image(systemName: "lock.shield")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.green)
                        Text("Yeni Şifre")
                            .font(.appHeadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                        Spacer()
                    }
                    
                    ModernAuthSecureField(
                        icon: "lock.fill",
                                    placeholder: "Yeni Şifre (En az 6 karakter)", 
                        text: $viewModel.resetData.newPassword,
                        color: .green
                                )
                                
                                // Password strength indicator
                                if !viewModel.resetData.newPassword.isEmpty {
                                    HStack {
                                        Image(systemName: viewModel.resetData.newPassword.count >= 6 ? "checkmark.circle.fill" : "xmark.circle.fill")
                                            .foregroundColor(viewModel.resetData.newPassword.count >= 6 ? .green : .red)
                                        Text("En az 6 karakter")
                                .font(.appCaption)
                                .fontWeight(.medium)
                                            .foregroundColor(viewModel.resetData.newPassword.count >= 6 ? .green : .red)
                                        Spacer()
                                    }
                        .padding(.horizontal, 16)
                                }
                            }
                        }
        }
        .padding(.bottom, 30)
                    }
                    
    // MARK: - Action Section
    private var actionSection: some View {
                    Button(action: {
                        viewModel.handleButtonPress()
                    }) {
            HStack(spacing: 12) {
                            if viewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.9)
                } else {
                    Image(systemName: getButtonIcon())
                        .font(.system(size: 18, weight: .bold))
                            }
                
                            Text(getButtonText())
                                .font(.appHeadline)
                    .fontWeight(.bold)
                    }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: getButtonGradientColors()),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: getButtonGradientColors().first?.opacity(0.3) ?? .clear, radius: 8, x: 0, y: 4)
        }
                    .disabled(viewModel.isLoading || !isButtonEnabled())
                    .opacity((viewModel.isLoading || !isButtonEnabled()) ? 0.7 : 1.0)
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }
    
    // MARK: - Success Section
    private var successSection: some View {
        VStack(spacing: 20) {
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
                    .frame(width: 80, height: 80)
                    .shadow(color: .green.opacity(0.3), radius: 8, x: 0, y: 4)
                
                            Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 8) {
                            Text("Şifre Başarıyla Sıfırlandı!")
                    .font(.appTitle3)
                                .foregroundColor(.green)
                                .fontWeight(.bold)
                            
                            Text("Giriş ekranına yönlendiriliyorsunuz...")
                                .font(.appBody)
                    .foregroundColor(.black.opacity(0.7))
            }
                        }
                        .transition(.scale.combined(with: .opacity))
                        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: viewModel.isPasswordReset)
        .padding(.bottom, 30)
    }
    
    // MARK: - Back to Login Section
    private var backToLoginSection: some View {
        VStack(spacing: 15) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 1)
                            .padding(.horizontal, 40)
                        
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                HStack(spacing: 10) {
                    Image(systemName: "arrow.left.circle.fill")
                        .font(.system(size: 18))
                                Text(viewModel.isPasswordReset ? "Giriş Ekranına Git" : "Giriş Ekranına Dön")
                        .font(.appHeadline)
                        .fontWeight(.semibold)
                            }
                            .foregroundColor(.blue)
                .padding(.vertical, 12)
                .padding(.horizontal, 20)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.blue.opacity(0.1))
                )
            }
            .padding(.bottom, 30)
        }
    }
    
    // MARK: - Error Toast Overlay
    private var errorToastOverlay: some View {
                VStack {
                    if viewModel.showError {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.red)
                            Text(viewModel.errorMessage ?? "Bir hata oluştu")
                                .font(.appBody)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.red.opacity(0.9))
                        )
                        .shadow(radius: 8)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: viewModel.showError)
                        .padding(.horizontal)
                    }
                    Spacer()
                }
                .padding(.top, 20)
    }
    
    // MARK: - Helper Functions
    private func getHeaderIcon() -> String {
        if viewModel.isPasswordReset {
            return "checkmark.seal.fill"
        } else if viewModel.isVerified {
            return "lock.shield.fill"
        } else if viewModel.isVerificationSent {
            return "envelope.badge.fill"
        } else {
            return "key.fill"
        }
    }
    
    private func getHeaderTitle() -> String {
        if viewModel.isPasswordReset {
            return "Tamamlandı!"
        } else if viewModel.isVerified {
            return "Yeni Şifre"
        } else if viewModel.isVerificationSent {
            return "Kodu Girin"
        } else {
            return "Şifremi Unuttum"
        }
    }
    
    private func getSubtitleText() -> String {
        if viewModel.isPasswordReset {
            return "Şifreniz başarıyla güncellendi. Artık yeni şifrenizle giriş yapabilirsiniz."
        } else if viewModel.isVerified {
            return "Güvenli ve hatırlanabilir bir şifre oluşturun"
        } else if viewModel.isVerificationSent {
            return "E-posta adresinize gönderilen 6 haneli doğrulama kodunu girin"
        } else {
            return "Şifrenizi sıfırlamak için e-posta adresinizi girin"
        }
    }
    
    private func getButtonText() -> String {
        if viewModel.isPasswordReset {
            return "Giriş Ekranına Git"
        } else if viewModel.isVerified {
            return "Şifreyi Kaydet"
        } else if viewModel.isVerificationSent {
            return "Kodu Doğrula"
        } else {
            return "Doğrulama Kodu Gönder"
        }
    }
    
    private func getButtonIcon() -> String {
        if viewModel.isPasswordReset {
            return "arrow.right.circle.fill"
        } else if viewModel.isVerified {
            return "checkmark.circle.fill"
        } else if viewModel.isVerificationSent {
            return "key.fill"
        } else {
            return "paperplane.fill"
        }
    }
    
    private func getButtonGradientColors() -> [Color] {
        if viewModel.isPasswordReset {
            return [Color.gray.opacity(0.8), Color.gray.opacity(0.6)]
        } else if viewModel.isVerified {
            return [Color.green.opacity(0.8), Color.green.opacity(0.6)]
        } else if viewModel.isVerificationSent {
            return [Color.orange.opacity(0.8), Color.orange.opacity(0.6)]
        } else {
            return [Color.blue.opacity(0.8), Color.blue.opacity(0.6)]
        }
    }
    
    private func isButtonEnabled() -> Bool {
        if viewModel.isPasswordReset {
            return false
        } else if viewModel.isVerified {
            return !viewModel.resetData.newPassword.isEmpty && viewModel.resetData.newPassword.count >= 6
        } else if viewModel.isVerificationSent {
            return !viewModel.resetData.verificationCode.isEmpty && viewModel.resetData.verificationCode.count == 6
        } else {
            return !viewModel.resetData.email.isEmpty && viewModel.resetData.email.contains("@")
        }
    }
}

// MARK: - Modern Auth Components
struct ModernAuthTextField: View {
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
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(color.opacity(0.2), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
    }
}

struct ModernAuthSecureField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
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
            
            SecureField(placeholder, text: $text)
                .font(.appHeadline)
                .foregroundColor(.black)
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(color.opacity(0.2), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
    }
}

#Preview {
    ResetPasswordView()
}


