//
//  Dietitian.swift
//  EatWell
//
//  Created by Tuğba Zengin on 24.05.2025.
//
import Foundation

struct Dietitian: Identifiable, Equatable, Codable {
    let id: Int
    let name: String
    let specialty: String
    let experience: String
    let image: String

    init(id: Int, name: String, specialty: String, experience: String, image: String) {
        self.id = id
        self.name = name
        self.specialty = specialty
        self.experience = experience
        self.image = image
    }
}
