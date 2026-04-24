//
//  NavigationBarBackButtonView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Андрианов on 21.04.2026.
//

import SwiftUI

private enum CustomNavigationBarLayout {
    static let barHeight: CGFloat = 44
    static let backButtonWidth: CGFloat = 44
    static let backButtonHeight: CGFloat = 44
    static let backIconLeadingInset: CGFloat = 16
    static let titleTrailingInset: CGFloat = 16
    static let titleFont: Font = .headline
}

struct NavigationBarBackButtonView: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.clear)
                    .frame(
                        width: CustomNavigationBarLayout.backButtonWidth,
                        height: CustomNavigationBarLayout.backButtonHeight
                    )

                Image(systemName: "chevron.left")
                    .font(.dsBodySemibold)
                    .foregroundStyle(.dayNightBlack)
                    .padding(.leading, CustomNavigationBarLayout.backIconLeadingInset)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

private struct CustomNavigationBarView<Trailing: View>: View {
    let title: String?
    let action: () -> Void
    @ViewBuilder let trailing: () -> Trailing

    var body: some View {
        ZStack {
            if let title {
                Text(title)
                    .font(CustomNavigationBarLayout.titleFont)
                    .foregroundStyle(.dayNightBlack)
                    .lineLimit(1)
            }

            HStack(spacing: 0) {
                NavigationBarBackButtonView(action: action)
                Spacer(minLength: 0)
                trailing()
                    .frame(
                        width: CustomNavigationBarLayout.backButtonWidth,
                        height: CustomNavigationBarLayout.backButtonHeight
                    )
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: CustomNavigationBarLayout.barHeight)
        .background(.dayNightWhite)
    }
}

private struct CustomNavigationBarModifier<Trailing: View>: ViewModifier {
    let title: String?
    let action: () -> Void
    @ViewBuilder let trailing: () -> Trailing

    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .navigationBar)
            .safeAreaInset(edge: .top, spacing: 0) {
                CustomNavigationBarView(
                    title: title,
                    action: action,
                    trailing: trailing
                )
            }
    }
}

extension View {
    func customNavigationBar(
        title: String? = nil,
        action: @escaping () -> Void
    ) -> some View {
        modifier(
            CustomNavigationBarModifier(
                title: title,
                action: action,
                trailing: { EmptyView() }
            )
        )
    }

    func customNavigationBar<Trailing: View>(
        title: String? = nil,
        action: @escaping () -> Void,
        @ViewBuilder trailing: @escaping () -> Trailing
    ) -> some View {
        modifier(
            CustomNavigationBarModifier(
                title: title,
                action: action,
                trailing: trailing
            )
        )
    }
}

#Preview {
    Color.dayNightWhite
        .ignoresSafeArea()
        .customNavigationBar {
            print("back tapped")
            
        }
}
