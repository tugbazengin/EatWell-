//
//  Style.swift
//  EatWell
//
//  Created by Tuğba Zengin on 25.05.2025.
//
import SwiftUI


extension Color {
    static let appBackground = Color(red: 0.95, green: 1.0, blue: 0.95)
}

// ViewModifier ,Background
struct AppBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.appBackground)
            .ignoresSafeArea()
    }
}

extension View {
    func applyAppBackground() -> some View {
        self.modifier(AppBackgroundModifier())
    }
}

// ViewModifier ,padding
struct AppContentsPadding: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 20)
            .padding(.top, 10)
    }
}

extension View {
    func appContentsPadding() -> some View {
        self.modifier(AppContentsPadding())
    }
}

//  ViewModifier ,Button Stil
struct AppButtonStyle: ViewModifier {
    var backgroundColor: Color

    func body(content: Content) -> some View {
        content
            .padding()
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(radius: 3)
    }
}

extension View {
    func appButtonStyle(color: Color = .green) -> some View {
        self.modifier(AppButtonStyle(backgroundColor: color))
    }
}

// Font Stili
extension Font {
    static let appTitle = Font.system(size: 28, weight: .bold)
    static let appHeadline = Font.system(size: 18, weight: .semibold)
    static let appBody = Font.system(size: 16, weight: .regular)
}
