//
//  ProfileRow.swift
//  EatWell
//
//  Created by Tuğba Zengin on 23.05.2025.
//
import SwiftUI

struct ProfileRow<T: CustomStringConvertible & LosslessStringConvertible>: View {
    var label: String
    @Binding var value: T
    var isEditing: Bool
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        HStack {
            Text(label + ":")
                .font(.appHeadline)
                .fontWeight(.semibold)
                .foregroundColor(.black)
            
            Spacer()
            
            if isEditing {
                TextField(
                    label,
                    text: Binding(
                        get: { String(value) },
                        set: { newValue in
                            if let converted = T(newValue) {
                                value = converted
                            }
                        }
                    )
                )
                .textFieldStyle(.roundedBorder)
                .frame(width: 140)
                .keyboardType(keyboardType)
                .font(.appBody)
            } else {
                Text(String(value))
                    .font(.appBody)
                    .foregroundColor(.gray)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
        }
        .appContentsPadding()
    }
}
