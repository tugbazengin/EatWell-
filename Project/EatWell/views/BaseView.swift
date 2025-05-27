//
//  BaseView.swift
//  EatWell
//
//  Created by Tuğba Zengin on 26.05.2025.
//
import SwiftUI

struct BaseView<Content: View>: View {
    var title: String? = nil
    var showsScrollView: Bool = true
    let content: () -> Content

    init(title: String? = nil, showsScrollView: Bool = true, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.showsScrollView = showsScrollView
        self.content = content
    }

    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Başlık 
                if let title = title {
                    Text(title)
                        .font(.appTitle)
                        .foregroundColor(.black)
                        .padding(.top, 20)
                }

                // ScrollView
                Group {
                    if showsScrollView {
                        ScrollView {
                            content()
                                .appContentsPadding()
                        }
                    } else {
                        content()
                            .appContentsPadding()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}
