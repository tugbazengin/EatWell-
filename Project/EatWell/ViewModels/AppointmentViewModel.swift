//
//  AppointmentViewModel.swift
//  EatWell
//
//  Created by Tuğba Zengin on 24.05.2025.
//

import Foundation
import SwiftUI

class AppointmentViewModel: ObservableObject {
    @Published var appointment = NewAppointment()

    let times = ["09.00", "10.00", "11.00", "13.00", "14.00", "15.00", "16.00"]

    let dietitians = [
        Dietitian(name: "Dr. Tuğba Zengin", specialization: "Klinik Beslenme Uzmanı", image: "dietitian1"),
        Dietitian(name: "Dr. Berke Baş", specialization: "Sporcu Beslenmesi Uzmanı", image: "dietitian2"),
        Dietitian(name: "Dr. Ahmet Çelik", specialization: "Diyetisyen", image: "dietitian3"),
        Dietitian(name: "Dr. Sıla Bicakcı", specialization: "Diyetisyen", image: "dietitian4")
    ]

    func resetSelection() {
        appointment.selectedTime = nil
        appointment.selectedDietitian = nil
    }

    func confirmAppointment() {
        print("Randevu Onaylandı: \(appointment)")
        //  burada Appointment oluşturup Firebase'e kaydedebilirz
        // let saved = Appointment(dietitian: appointment.selectedDietitian?.name ?? "", ...)
    }
}


