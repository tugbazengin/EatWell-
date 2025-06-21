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
            VStack(spacing: 20) {
                // Error ve Success mesajları
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
                
                if let successMessage = viewModel.successMessage {
                    Text(successMessage)
                        .foregroundColor(.green)
                        .padding()
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
                // Diyetisyen kartlarıyatay scroll
                if viewModel.isLoading && viewModel.dietitians.isEmpty {
                    ProgressView("Diyetisyenler yükleniyor...")
                        .frame(height: 120)
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
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
                        .appContentsPadding()
                    }
                }

                // Tarih seçimi
                VStack(alignment: .leading, spacing: 8) {
                    Text("Tarih Seç:")
                        .font(.appHeadline)

                    DatePicker("", selection: $viewModel.appointment.selectedDate, displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.9)).shadow(radius: 4))
                        .onChange(of: viewModel.appointment.selectedDate) {
                            if viewModel.appointment.selectedDietitian != nil {
                                viewModel.fetchAvailableTimes()
                            }
                        }
                }
                .appContentsPadding()

                // Saat seçimi
                VStack(alignment: .leading, spacing: 8) {
                    Text("Saat Seç")
                        .font(.appHeadline)

                    ScrollView {
                        LazyVStack(spacing: 10) {
                            ForEach(viewModel.times, id: \.self) { time in
                                Button(action: {
                                    viewModel.appointment.selectedTime = time
                                }) {
                                    Text(time)
                                        .font(.appBody)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                        .background(
                                            viewModel.appointment.selectedTime == time ? Color.green : Color.white
                                        )
                                        .foregroundColor(
                                            viewModel.appointment.selectedTime == time ? .white : .black
                                        )
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .shadow(radius: 3)
                                }
                            }
                        }
                    }
                }
                .appContentsPadding()

                Spacer()

               
                HStack(spacing: 16) {
                    Button(action: {
                        viewModel.resetSelection()
                    }) {
                        Text("İptal Et")
                    }
                    .appButtonStyle(color: .red)

                    Button(action: {
                        viewModel.confirmAppointment()
                    }) {
                        Text("Onayla")
                    }
                    .appButtonStyle(color: .green)
                }
                .appContentsPadding()
                .padding(.bottom, 20)
            }
        }
    }
}

#Preview {
    AppointmentView()
}

