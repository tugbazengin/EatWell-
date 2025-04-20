//
//  AppointmentView.swift
//  EatWell
//
//  Created by Tuğba Zengin on 28.03.2025.
//
import SwiftUI

struct AppointmentView: View {
    @State private var selectedDate = Date()
    @State private var selectedTime: String? = nil
    @State private var selectedDietitian: Dietitian? = nil

    let times = ["09.00", "10.00", "11.00", "13.00", "14.00", "15.00", "16.00"]
    let dietitians = [
        Dietitian(name: "Dr. Tuğba Zengin", specialization: "Klinik Beslenme Uzmanı", image: "dietitian1"),
        Dietitian(name: "Dr. Berke Baş", specialization: "Sporcu Beslenmesi Uzmanı", image: "dietitian2"),
        Dietitian(name: "Dr. Ahmet Çelik", specialization: "Diyetisyen", image: "dietitian3"),
        Dietitian(name: "Dr. Sıla Bicakcı", specialization: "Diyetisyen", image: "dietitian4")
    ]

    var body: some View {
        ZStack {
            // Arka plan rengini değiştirdik
            Color(red: 0.95, green: 1.0, blue: 0.95)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Text("Randevu Al")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 20)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(dietitians) { dietitian in
                            DietitianCard(dietitian: dietitian, isSelected: selectedDietitian == dietitian) {
                                selectedDietitian = dietitian
                            }
                        }
                    }
                    .padding()
                }

                // 📌 Takvim Seçimi
                VStack(alignment: .leading) {
                    Text("Tarih Seç:")
                        .font(.headline)
                    DatePicker("", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.9)).shadow(radius: 4))
                }
                .padding(.horizontal)

                // 📌 Saat Seçimi (Grid ile düzenlenmiş)
                VStack(alignment: .leading) {
                    Text("Saat Seç")
                        .font(.headline)
                        .padding(.top)

                    let columns = [GridItem(.adaptive(minimum: 70), spacing: 8)] // 📌 Min genişlik ve aralık güncellendi

                    LazyVGrid(columns: columns, spacing: 8) {
                        ForEach(times, id: \.self) { time in
                            Button(action: {
                                selectedTime = time
                            }) {
                                Text(time)
                                    .font(.system(size: 14)) // 📌 Saat fontu küçültüldü
                                    .padding()
                                    .frame(width: 70, height: 35) // 📌 Kutu boyutu küçültüldü
                                    .background(selectedTime == time ? Color.green : Color.white)
                                    .foregroundColor(selectedTime == time ? .white : .black)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .shadow(radius: 3)
                            }
                        }
                    }
                }
                .padding(.horizontal)

                Spacer()

                // 📌 Onay / İptal Butonları
                HStack {
                    Button(action: {
                        selectedDietitian = nil
                        selectedTime = nil
                    }) {
                        Text("İptal Et")
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 120)
                            .background(Color.red.opacity(0.7))
                            .clipShape(Capsule())
                            .shadow(radius: 3)
                    }

                    Spacer()

                    Button(action: {
                        // Randevu onaylandı işlemi buraya eklenebilir
                    }) {
                        Text("Onayla")
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 120)
                            .background(Color.green)
                            .clipShape(Capsule())
                            .shadow(radius: 3)
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 20)
            }
        }
    }
}

// 📌 Diyetisyen Modeli
struct Dietitian: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let specialization: String
    let image: String
}

// 📌 Diyetisyen Kartı Bileşeni
struct DietitianCard: View {
    let dietitian: Dietitian
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        VStack {
            Image(dietitian.image)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .overlay(Circle().stroke(isSelected ? Color.green : Color.gray, lineWidth: 3))
                .shadow(radius: 5)

            Text(dietitian.name)
                .font(.headline)
                .foregroundColor(.black)

            Text(dietitian.specialization)
                .font(.subheadline)
                .foregroundColor(.gray)

            Button(action: action) {
                Text(isSelected ? "Seçildi" : "Seç")
                    .padding(.horizontal, 20)
                    .padding(.vertical, 6)
                    .background(isSelected ? Color.green : Color.white)
                    .foregroundColor(isSelected ? .white : .black)
                    .clipShape(Capsule())
                    .shadow(radius: 3)
            }
            .padding(.top, 5)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.9)).shadow(radius: 4))
        .frame(width: 180)
    }
}

// 📌 Önizleme
struct AppointmentView_Previews: PreviewProvider {
    static var previews: some View {
        AppointmentView()
    }
}

