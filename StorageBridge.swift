import Foundation
import WebKit

/// Puente entre el JavaScript de forja.html y el disco real del dispositivo.
/// Funciona idéntico en macOS y en iOS — FileManager.applicationSupportDirectory
/// existe en las dos plataformas y en iOS cae dentro del contenedor propio
/// de la app (privado, persistente, con backup automático a iCloud/iTunes).
final class StorageBridge: NSObject, WKScriptMessageHandler {
    private let dir: URL

    override init() {
        let base = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        let kvDir = base.appendingPathComponent("Forja", isDirectory: true)
                         .appendingPathComponent("kv", isDirectory: true)
        try? FileManager.default.createDirectory(at: kvDir, withIntermediateDirectories: true)
        self.dir = kvDir
        super.init()
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let body = message.body as? [String: Any],
              let id = body["id"] as? String,
              let action = body["action"] as? String else { return }
        let key = body["key"] as? String

        var resultJson: String
        switch action {
        case "get":
            if let key, let data = try? Data(contentsOf: fileURL(for: key)),
               let value = String(data: data, encoding: .utf8) {
                resultJson = jsonEncode(["value": value])
            } else {
                resultJson = jsonEncode(["error": "Clave no encontrada"])
            }
        case "set":
            if let key, let value = body["value"] as? String {
                try? value.data(using: .utf8)?.write(to: fileURL(for: key))
                resultJson = jsonEncode(["value": value])
            } else {
                resultJson = jsonEncode(["error": "Faltan datos"])
            }
        case "delete":
            if let key { try? FileManager.default.removeItem(at: fileURL(for: key)) }
            resultJson = jsonEncode(["value": NSNull()])
        case "list":
            let prefix = (body["prefix"] as? String) ?? ""
            let files = (try? FileManager.default.contentsOfDirectory(atPath: dir.path)) ?? []
            let keys = files.filter { prefix.isEmpty || $0.hasPrefix(prefix) }
            resultJson = jsonEncode(["value": keys])
        default:
            resultJson = jsonEncode(["error": "Acción desconocida"])
        }

        let escaped = resultJson
            .replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "'", with: "\\'")
        let js = "window.__forjaStorageResolve('\(id)', '\(escaped)')"
        message.webView?.evaluateJavaScript(js, completionHandler: nil)
    }

    private func fileURL(for key: String) -> URL { dir.appendingPathComponent(key) }

    private func jsonEncode(_ dict: [String: Any]) -> String {
        guard let data = try? JSONSerialization.data(withJSONObject: dict) else { return "{}" }
        return String(data: data, encoding: .utf8) ?? "{}"
    }
}
