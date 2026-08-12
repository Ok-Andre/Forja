import SwiftUI
import WebKit

struct ContentView: UIViewRepresentable {
    func makeCoordinator() -> Coordinator { Coordinator() }

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        let bridge = StorageBridge()
        config.userContentController.add(bridge, name: "forjaStorage")
        context.coordinator.bridge = bridge // mantenerlo vivo mientras exista la webview

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.scrollView.bounces = false
        if let url = Bundle.main.url(forResource: "forja", withExtension: "html") {
            webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        }
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}

    class Coordinator {
        var bridge: StorageBridge?
    }
}
