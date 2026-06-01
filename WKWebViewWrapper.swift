import SwiftUI
import WebKit

struct WKWebViewWrapper: UIViewRepresentable {
    let url: URL?
    let isLocalHTML: Bool
    var onStationFragmentTapped: ((String) -> Void)? = nil
    @Binding var isLoading: Bool
    @Binding var errorMessage: String?

    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()

        if !isLocalHTML {
            // Register the script message handler for Xcode console logging
            configuration.userContentController.add(context.coordinator, name: "logger")

            // Inject CSS isolation stylesheet at document start.
            // This immediately hides non-essential layouts (header, footer, map, back button)
            // and styles the main container to be clean, transparent, and responsive.
            let cssSource = """
            (function() {
                var style = document.createElement('style');
                style.id = 'metro-isolation-styles';
                style.innerHTML = `
                    /* Hide header/footer wrapper divs and non-essential side elements */
                    body > div {
                        display: none !important;
                    }
                    .rider-tools-map-content-wrapper,
                    .back-button,
                    .sidebar__slider-bar,
                    .sidebar__slider-spacer {
                        display: none !important;
                    }

                    /* Make ancestors and containers transparent and borderless */
                    html, body,
                    .wmata-app-wrapper,
                    .sidebar,
                    .sidebar__slider-container,
                    .expandable-sidebar__content,
                    .tabs-details {
                        border: none !important;
                        box-shadow: none !important;
                        width: 100% !important;
                        max-width: 100% !important;
                        min-width: 0 !important;
                        margin: 0 !important;
                    }

                    /* Override static margins/positioning for proper iOS viewport flow */
                    .wmata-app-wrapper,
                    .sidebar,
                    .sidebar__slider-container,
                    .expandable-sidebar__content {
                        position: static !important;
                        transform: none !important;
                        height: auto !important;
                        padding: 0 !important;
                    }

                    /* Prevent horizontal scroll and add high-end native padding */
                    html, body {
                        overflow-x: hidden !important;
                    }
                    body {
                        padding: 16px !important;
                        display: block !important;
                    }
                `;
                if (document.documentElement) {
                    document.documentElement.appendChild(style);
                } else {
                    var observer = new MutationObserver(function(mutations, obs) {
                        if (document.documentElement) {
                            document.documentElement.appendChild(style);
                            obs.disconnect();
                        }
                    });
                    observer.observe(document, { childList: true, subtree: true });
                }
            })();
            """
            let cssScript = WKUserScript(source: cssSource, injectionTime: .atDocumentStart, forMainFrameOnly: true)
            configuration.userContentController.addUserScript(cssScript)

            // Keep a clean instrumentation script to notify Xcode of loading success/state
            let instrumentSource = """
            (function() {
                function log(msg) {
                    if (window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.logger) {
                        window.webkit.messageHandlers.logger.postMessage(msg);
                    }
                }
                
                log("Metro Tab Bar: Injected isolation styles successfully.");
                
                // Watch for arrivals hydration and log state change
                var checkHydration = setInterval(function() {
                    var arrivals = document.querySelector('.service-nearby-times');
                    if (arrivals) {
                        clearInterval(checkHydration);
                        log("Metro Tab Bar: Live arrivals hydrated successfully.");
                    }
                }, 500);
                
                // Clear check after 10s to prevent infinite loops
                setTimeout(function() {
                    clearInterval(checkHydration);
                }, 10000);
            })();
            """
            let instrumentScript = WKUserScript(source: instrumentSource, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
            configuration.userContentController.addUserScript(instrumentScript)
        }

        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator

        // Make the background transparent to look integrated
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = .clear

        // Custom interactive zoom features for map if needed
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.scrollView.showsVerticalScrollIndicator = false

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(context.coordinator, action: #selector(Coordinator.refreshWebView(_:)), for: .valueChanged)
        webView.scrollView.refreshControl = refreshControl

        context.coordinator.webView = webView

        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let coordinator = context.coordinator
        coordinator.parent = self

        if isLocalHTML {
            if !coordinator.lastLoadedLocalHTML {
                coordinator.lastLoadedLocalHTML = true
                if let htmlPath = Bundle.main.path(forResource: "dc-metro-silver", ofType: "html") {
                    let htmlURL = URL(fileURLWithPath: htmlPath)
                    uiView.loadFileURL(htmlURL, allowingReadAccessTo: Bundle.main.bundleURL)
                }
            }
        } else if let url = url {
            if coordinator.lastLoadedURL != url {
                coordinator.lastLoadedURL = url
                let request = URLRequest(url: url)
                uiView.load(request)
            }
        }
    }

    static func dismantleUIView(_ uiView: WKWebView, coordinator _: Coordinator) {
        uiView.configuration.userContentController.removeAllScriptMessageHandlers()
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WKWebViewWrapper
        var lastLoadedURL: URL?
        var lastLoadedLocalHTML = false
        weak var webView: WKWebView?

        init(_ parent: WKWebViewWrapper) {
            self.parent = parent
        }

        @objc func refreshWebView(_: UIRefreshControl) {
            webView?.reload()
        }

        func webView(_: WKWebView, didStartProvisionalNavigation _: WKNavigation!) {
            parent.isLoading = true
            parent.errorMessage = nil
        }

        func webView(_ webView: WKWebView, didFinish _: WKNavigation!) {
            parent.isLoading = false
            webView.scrollView.refreshControl?.endRefreshing()
        }

        func webView(_ webView: WKWebView, didFail _: WKNavigation!, withError error: Error) {
            parent.isLoading = false
            parent.errorMessage = error.localizedDescription
            webView.scrollView.refreshControl?.endRefreshing()
        }

        func webView(_ webView: WKWebView, didFailProvisionalNavigation _: WKNavigation!, withError error: Error) {
            parent.isLoading = false
            parent.errorMessage = error.localizedDescription
            webView.scrollView.refreshControl?.endRefreshing()
        }

        func webView(_: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let url = navigationAction.request.url {
                // If the tapped link has a fragment (hash tag) e.g., file:///...html#G03
                if let fragment = url.fragment, !fragment.isEmpty {
                    parent.onStationFragmentTapped?(fragment)
                    decisionHandler(.cancel)
                    return
                }
            }
            decisionHandler(.allow)
        }
    }
}

extension WKWebViewWrapper.Coordinator: WKScriptMessageHandler {
    func userContentController(_: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "logger" {
            #if DEBUG
                print("WKWebView [JS LOG]: \(message.body)")
            #endif
        }
    }
}
