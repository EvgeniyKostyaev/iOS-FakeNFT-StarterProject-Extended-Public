//
//  ProfileExitConfirmationView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Андрианов on 16.04.2026.
//

import SwiftUI

struct ProfileExitConfirmationView: View {
    @Binding var isPresented: Bool
    let onStay: () -> Void
    let onExit: () -> Void

    private let buttonRowHeight: CGFloat = 48
    private var separatorColor: Color { Color.universalBackground.opacity(0.36) }

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    isPresented = false
                    onStay()
                }

            VStack(spacing: 0) {
                Text(NSLocalizedString("Profile.editExitTitle", comment: ""))
                    .font(.system(size: 17, weight: .semibold))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.universalBlack)
                    .padding(.horizontal, 16)
                    .padding(.top, 20)
                    .padding(.bottom, 16)

                Rectangle()
                    .fill(separatorColor)
                    .frame(height: 0.5)
                    .frame(maxWidth: .infinity)

                HStack(spacing: 0) {
                    Button {
                        isPresented = false
                        onStay()
                    } label: {
                        Text(NSLocalizedString("Profile.editExitStay", comment: ""))
                            .font(.system(size: 17, weight: .regular))
                            .foregroundStyle(.blue)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .buttonStyle(.plain)
                    .frame(height: buttonRowHeight)

                    Rectangle()
                        .fill(separatorColor)
                        .frame(width: 0.5, height: buttonRowHeight)

                    Button {
                        isPresented = false
                        onExit()
                    } label: {
                        Text(NSLocalizedString("Profile.editExitLeave", comment: ""))
                            .font(.system(size: 17, weight: .bold))
                            .foregroundStyle(.blue)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .buttonStyle(.plain)
                    .frame(height: buttonRowHeight)
                }
            }
            .frame(maxWidth: 270)
            .fixedSize(horizontal: false, vertical: true)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color.universalWhite.opacity(0.80))
            )
        }
        .transition(.opacity)
    }
}

#Preview {
    ZStack {
        Color.dayNightLightGray.ignoresSafeArea()
        ProfileExitConfirmationView(
            isPresented: .constant(true),
            onStay: {},
            onExit: {}
        )
    }
}
