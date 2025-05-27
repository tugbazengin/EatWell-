//
//  Dietitian.swift
//  EatWell
//
//  Created by Tuğba Zengin on 24.05.2025.
//
import Foundation

struct Dietitian: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let specialization: String
    let image: String
}

