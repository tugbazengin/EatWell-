//
//  AppointmentView.swift
//  EatWell
//
//  Created by Tuğba Zengin on 24.05.2025.
//
import SwiftUI

struct AppointmentView: View {
    @StateObject private var viewModel = AppointmentViewModel()

    var body: some View {
        BaseView(title: "Randevu Al", showsScrollView: false) {
            VStack(spacing: 0) {
                messagesSection
                dietitiansSection
                dateSelectionSection
                timeSelectionSection
                Spacer()
                actionButtonsSection
            }
        }
    }
    
    // MARK: - Messages Section
    private var messagesSection: some View {
        VStack(spacing: 12) {
            if let errorMessage = viewModel.errorMessage {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                    Text(errorMessage)
                        .font(.appBody)
                        .fontWeight(.medium)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.red.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.red.opacity(0.2), lineWidth: 1)
                        )
                )
                .padding(.horizontal, 20)
            }
            
            if let successMessage = viewModel.successMessage {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text(successMessage)
                        .font(.appBody)
                        .fontWeight(.medium)
                        .foregroundColor(.green)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.green.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.green.opacity(0.2), lineWidth: 1)
                        )
                )
                .padding(.horizontal, 20)
            }
        }
        .padding(.bottom, viewModel.errorMessage != nil || viewModel.successMessage != nil ? 20 : 0)
    }
    
    // MARK: - Dietitians Section
    private var dietitiansSection: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "stethoscope")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.blue)
                Text("Diyetisyen Seçin")
                    .font(.appTitle3)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                Spacer()
            }
            .padding(.horizontal, 20)
            
            if viewModel.isLoading && viewModel.dietitians.isEmpty {
                HStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        .scaleEffect(0.8)
                    Text("Diyetisyenler yükleniyor...")
                        .font(.appBody)
                        .foregroundColor(.black.opacity(0.7))
                }
                .frame(height: 180)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(viewModel.dietitians) { dietitian in
                            DietitianCard(
                                dietitian: dietitian,
                                isSelected: viewModel.appointment.selectedDietitian == dietitian
                            ) {
                                viewModel.appointment.selectedDietitian = dietitian
                                viewModel.fetchAvailableTimes()
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
        .padding(.bottom, 30)
    }
    
    // MARK: - Date Selection Section
    private var dateSelectionSection: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "calendar")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.green)
                Text("Tarih Seçin")
                    .font(.appTitle3)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                Spacer()
            }
            .padding(.horizontal, 20)
            
            DatePicker("", selection: $viewModel.appointment.selectedDate, displayedComponents: .date)
                .datePickerStyle(.compact)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.green.opacity(0.2), lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
                )
                .padding(.horizontal, 20)
                .onChange(of: viewModel.appointment.selectedDate) {
                    if viewModel.appointment.selectedDietitian != nil {
                        viewModel.fetchAvailableTimes()
                    }
                }
        }
        .padding(.bottom, 30)
    }
    
    // MARK: - Time Selection Section
    private var timeSelectionSection: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "clock")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.orange)
                Text("Saat Seçin")
                    .font(.appTitle3)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                Spacer()
            }
            .padding(.horizontal, 20)
            
            if viewModel.times.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "clock.badge.xmark")
                        .font(.system(size: 40))
                        .foregroundColor(.gray.opacity(0.6))
                    
                    Text("Önce diyetisyen ve tarih seçin")
                        .font(.appBody)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                .frame(height: 120)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.gray.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.gray.opacity(0.1), lineWidth: 1)
                        )
                )
                .padding(.horizontal, 20)
            } else {
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 12) {
                        ForEach(viewModel.times, id: \.self) { time in
                            Button(action: {
                                viewModel.appointment.selectedTime = time
                            }) {
                                Text(time)
                                    .font(.appHeadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(
                                        viewModel.appointment.selectedTime == time ? .white : .black
                                    )
                                    .frame(height: 48)
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(
                                                viewModel.appointment.selectedTime == time ? 
                                                LinearGradient(
                                                    gradient: Gradient(colors: [
                                                        Color.orange.opacity(0.8),
                                                        Color.orange.opacity(0.6)
                                                    ]),
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                ) :
                                                LinearGradient(
                                                    gradient: Gradient(colors: [.white, .white]),
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(
                                                        viewModel.appointment.selectedTime == time ? 
                                                        Color.orange.opacity(0.3) : Color.gray.opacity(0.2),
                                                        lineWidth: 1
                                                    )
                                            )
                                            .shadow(
                                                color: viewModel.appointment.selectedTime == time ? 
                                                .orange.opacity(0.3) : .black.opacity(0.05),
                                                radius: viewModel.appointment.selectedTime == time ? 8 : 4,
                                                x: 0,
                                                y: viewModel.appointment.selectedTime == time ? 4 : 2
                                            )
                                    )
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .frame(maxHeight: 200)
            }
        }
        .padding(.bottom, 20)
    }
    
    // MARK: - Action Buttons Section
    private var actionButtonsSection: some View {
        HStack(spacing: 16) {
            Button(action: {
                viewModel.resetSelection()
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "xmark.circle")
                        .font(.system(size: 16, weight: .semibold))
                    Text("İptal Et")
                        .font(.appHeadline)
                        .fontWeight(.bold)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.red.opacity(0.8),
                            Color.red.opacity(0.6)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .red.opacity(0.3), radius: 8, x: 0, y: 4)
            }

            Button(action: {
                viewModel.confirmAppointment()
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Onayla")
                        .font(.appHeadline)
                        .fontWeight(.bold)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.green.opacity(0.8),
                            Color.green.opacity(0.6)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .green.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .disabled(!isConfirmButtonEnabled)
            .opacity(isConfirmButtonEnabled ? 1.0 : 0.6)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 30)
    }
    
    // MARK: - Helper
    private var isConfirmButtonEnabled: Bool {
        viewModel.appointment.selectedDietitian != nil &&
        !(viewModel.appointment.selectedTime?.isEmpty ?? true)
    }
}

#Preview {
    AppointmentView()
}

