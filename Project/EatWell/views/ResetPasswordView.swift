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
        BaseView(title: "Şifre Sıfırlama", showsScrollView: true) {
            VStack(spacing: 20) {
                Picker("Sıfırlama Yöntemi", selection: $viewModel.resetMethod) {
                    Text("E-posta ile").tag(ResetPasswordViewModel.ResetMethod.email)
                    Text("Telefon ile").tag(ResetPasswordViewModel.ResetMethod.phone)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .appContentsPadding()

                if viewModel.resetMethod == .email {
                    Group {
                        CustomTextField(placeholder: "E-posta adresinizi girin", text: $viewModel.resetData.email)

                        if viewModel.isVerificationSent {
                            CustomTextField(placeholder: "E-postaya gelen doğrulama kodunu girin", text: $viewModel.resetData.verificationCode)
                        }

                        if viewModel.isVerified {
                            CustomSecureField(placeholder: "Yeni Şifre", text: $viewModel.resetData.newPassword)
                        }
                    }
                    .appContentsPadding()

                    Button(action: viewModel.handleButtonPress) {
                        Text(viewModel.isPasswordReset ? "Şifre Sıfırlandı" :
                             (viewModel.isVerified ? "Şifreyi Kaydet" :
                              (viewModel.isVerificationSent ? "Doğrula" : "Şifre Sıfırla")))
                            .font(.appHeadline)
                    }
                    .appButtonStyle(color: viewModel.isPasswordReset ? .gray : .green)
                    .disabled(viewModel.isPasswordReset)
                    .appContentsPadding()

                } else {
                    Group {
                        CustomTextField(placeholder: "Telefon numaranızı girin", text: $viewModel.resetData.phoneNumber, keyboardType: .phonePad)

                        if viewModel.isVerificationSent {
                            CustomTextField(placeholder: "SMS ile gelen kodu girin", text: $viewModel.resetData.verificationCode, keyboardType: .numberPad)
                        }

                        if viewModel.isVerified {
                            CustomSecureField(placeholder: "Yeni Şifre", text: $viewModel.resetData.newPassword)
                        }
                    }
                    .appContentsPadding()

                    Button(action: viewModel.handleButtonPress) {
                        Text(viewModel.isPasswordReset ? "Şifre Sıfırlandı" :
                             (viewModel.isVerified ? "Şifreyi Kaydet" :
                              (viewModel.isVerificationSent ? "Doğrula" : "SMS Gönder")))
                            .font(.appHeadline)
                    }
                    .appButtonStyle(color: viewModel.isPasswordReset ? .gray : .green)
                    .disabled(viewModel.isPasswordReset)
                    .appContentsPadding()
                }

                if viewModel.isPasswordReset {
                    Text("Şifre başarıyla sıfırlandı!")
                        .foregroundColor(.green)
                        .font(.appBody)
                        .fontWeight(.bold)
                        .padding(.top)
                }
            }
            .padding()
        }
        .fullScreenCover(isPresented: $viewModel.navigateToAuthView) {
            AuthView()
                .onAppear {
                    self.presentationMode.wrappedValue.dismiss()
                    viewModel.resetAll()
                }
        }
    }
}


