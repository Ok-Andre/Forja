import SwiftUI
import WebKit

struct ContentView: NSViewRepresentable {
    func makeNSView(context: Context) -> WKWebView {
        let webView = WKWebView()
        if let url = Bundle.module.url(forResource: "forja", withExtension: "html") {
            webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        }
        return webView
    }

    func updateNSView(_ nsView: WKWebView, context: Context) {}
}
