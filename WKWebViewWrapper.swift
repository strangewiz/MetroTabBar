import SwiftUI
import WebKit

struct WKWebViewWrapper: UIViewRepresentable {
    let url: URL?
    let isLocalHTML: Bool
    var onStationFragmentTapped: ((String) -> Void)? = nil
    @Binding var isLoading: Bool
    
    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        
        // Make the background transparent to look integrated
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = .clear
        
        // Custom interactive zoom features for map if needed
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.scrollView.showsVerticalScrollIndicator = false
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if isLocalHTML {
            // Load the DC Metro interactive HTML map from bundle resources
            if let htmlPath = Bundle.main.path(forResource: "dc-metro-silver", ofType: "html") {
                let htmlURL = URL(fileURLWithPath: htmlPath)
                uiView.loadFileURL(htmlURL, allowingReadAccessTo: Bundle.main.bundleURL)
            }
        } else if let url = url {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WKWebViewWrapper
        
        init(_ parent: WKWebViewWrapper) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            DispatchQueue.main.async {
                self.parent.isLoading = true
            }
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            DispatchQueue.main.async {
                self.parent.isLoading = false
            }
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            DispatchQueue.main.async {
                self.parent.isLoading = false
            }
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let url = navigationAction.request.url {
                // If the tapped link has a fragment (hash tag) e.g., file:///...html#G03
                if let fragment = url.fragment, !fragment.isEmpty {
                    parent.onStationFragmentTapped?(fragment)
                    decisionHandler(.cancel)
                    return
                }
                
                // Also support custom URL schemes or fragments formatted differently depending on OS loading
                let absoluteString = url.absoluteString
                if absoluteString.contains("#") {
                    let parts = absoluteString.components(separatedBy: "#")
                    if parts.count > 1, let lastPart = parts.last, !lastPart.isEmpty {
                        parent.onStationFragmentTapped?(lastPart)
                        decisionHandler(.cancel)
                        return
                    }
                }
            }
            decisionHandler(.allow)
        }
    }
}
