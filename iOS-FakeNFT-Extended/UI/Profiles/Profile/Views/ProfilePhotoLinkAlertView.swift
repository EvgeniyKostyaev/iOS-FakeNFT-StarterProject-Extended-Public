//
//  ProfilePhotoLinkAlertView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Андрианов on 17.04.2026.
//

import SwiftUI

struct ProfilePhotoLinkAlertView: View {
    @Binding var isPresented: Bool
    @Binding var urlString: String
    let onCancel: () -> Void
    let onSave: () -> Void

    private let buttonRowHeight: CGFloat = 48
    private var separatorColor: Color { Color.dayNightBlack.opacity(0.12) }

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    isPresented = false
                    onCancel()
                }

            VStack(spacing: 0) {
                Text(NSLocalizedString("Profile.avatarLinkTitle", comment: ""))
                    .font(.system(size: 17, weight: .semibold))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.dayNightBlack)
                    .padding(.horizontal, 16)
                    .padding(.top, 20)
                    .padding(.bottom, 12)

                TextField("https://", text: $urlString)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundStyle(.dayNightBlack)
                    .keyboardType(.URL)
                    .textContentType(.URL)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 11, style: .continuous)
                            .fill(Color.dayNightWhite)
                    )
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)

                Rectangle()
                    .fill(separatorColor)
                    .frame(height: 1)
                    .frame(maxWidth: .infinity)

                HStack(spacing: 0) {
                    Button {
                        isPresented = false
                        onCancel()
                    } label: {
                        Text(NSLocalizedString("Profile.avatarLinkCancel", comment: ""))
                            .font(.system(size: 17, weight: .regular))
                            .foregroundStyle(.blue)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .buttonStyle(.plain)
                    .frame(height: buttonRowHeight)

                    Rectangle()
                        .fill(separatorColor)
                        .frame(width: 1, height: buttonRowHeight)

                    Button {
                        isPresented = false
                        onSave()
                    } label: {
                        Text(NSLocalizedString("Profile.avatarLinkSave", comment: ""))
                            .font(.system(size: 17, weight: .bold))
                            .foregroundStyle(.blue)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .buttonStyle(.plain)
                    .frame(height: buttonRowHeight)
                }
            }
            .frame(maxWidth: 300)
            .fixedSize(horizontal: false, vertical: true)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.dayNightLightGray)
            )
            .compositingGroup()
        }
        .transition(.opacity)
    }
}

#Preview {
    ZStack {
        Color.dayNightLightGray.ignoresSafeArea()
        ProfilePhotoLinkAlertView(
            isPresented: .constant(true),
            urlString: .constant("https://example.com/photo.jpg"),
            onCancel: {},
            onSave: {}
        )
    }
}
