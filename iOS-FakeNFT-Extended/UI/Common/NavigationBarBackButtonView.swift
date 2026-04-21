//
//  NavigationBarBackButtonView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Андрианов on 21.04.2026.
//

import SwiftUI

private enum NavigationBarBackButtonLayout {
    static let tapSide: CGFloat = 44
    static let leadingEdgeShift: CGFloat = 16
}

struct NavigationBarBackButtonView: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "chevron.left")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.dayNightBlack)
                .frame(
                    width: NavigationBarBackButtonLayout.tapSide,
                    height: NavigationBarBackButtonLayout.tapSide
                )
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .offset(x: -NavigationBarBackButtonLayout.leadingEdgeShift)
    }
}

private struct NavigationBackToolbarContent: ToolbarContent {
    let action: () -> Void

    var body: some ToolbarContent {
        if #available(iOS 26.0, *) {
            ToolbarItem(placement: .topBarLeading) {
                NavigationBarBackButtonView(action: action)
            }
            .sharedBackgroundVisibility(.hidden)
        } else {
            ToolbarItem(placement: .topBarLeading) {
                NavigationBarBackButtonView(action: action)
            }
        }
    }
}

extension View {
    func navigationBarBackButton(action: @escaping () -> Void) -> some View {
        navigationBarBackButtonHidden(true)
            .toolbar {
                NavigationBackToolbarContent(action: action)
            }
    }
}

#Preview("NavigationBarBackButton") {
    NavigationStack {
        Color.dayNightWhite
            .ignoresSafeArea()
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButton {}
    }
}
