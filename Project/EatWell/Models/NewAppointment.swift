//
//  NewAppointment.swift
//  EatWell
//
//  Created by Tuğba Zengin on 24.05.2025.
//
import Foundation

struct NewAppointment {
    var selectedDate: Date
    var selectedTime: String?
    var selectedDietitian: Dietitian?

    init(selectedDate: Date = Date(), selectedTime: String? = nil, selectedDietitian: Dietitian? = nil) {
        self.selectedDate = selectedDate
        self.selectedTime = selectedTime
        self.selectedDietitian = selectedDietitian
    }
}
