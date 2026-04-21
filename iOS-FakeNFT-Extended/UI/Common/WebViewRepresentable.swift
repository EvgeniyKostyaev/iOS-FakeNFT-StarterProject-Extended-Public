//
//  WebViewRepresentable.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Андрианов on 14.04.2026.
//

import SwiftUI
import WebKit

struct WKWebViewRepresentable: UIViewRepresentable {
    let url: URL

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        webView.allowsBackForwardNavigationGestures = true
        context.coordinator.loadIfNeeded(webView: webView, url: url)
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        context.coordinator.loadIfNeeded(webView: webView, url: url)
    }

    final class Coordinator {
        private var loadedURL: URL?
        func loadIfNeeded(webView: WKWebView, url: URL) {
            guard loadedURL != url else { return }
            loadedURL = url
            webView.load(URLRequest(url: url))
        }
    }
}

struct WebViewRepresentable: View {
    let url: URL

    var body: some View {
        WKWebViewRepresentable(url: url)
            .ignoresSafeArea(edges: .bottom)
            .navigationBarTitleDisplayMode(.inline)
    }
}

/// Полноэкранное модальное окно с сайтом (поверх таббара). Шеврон «назад» как на остальных экранах, без заголовка в баре.
struct WebViewFullScreenModal: View {
    @Environment(\.dismiss) private var dismiss

    let url: URL

    var body: some View {
        NavigationStack {
            WebViewRepresentable(url: url)
                .navigationTitle("")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundStyle(.dayNightBlack)
                        }
                    }
                }
        }
        .toolbar(.hidden, for: .tabBar)
    }
}

#Preview {
    NavigationStack {
        WKWebViewRepresentable(
            url: URL(string: "https://practicum.yandex.ru/ios-developer/?from=catalog")!,
        )
    }
}
