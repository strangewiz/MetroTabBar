import SwiftUI
import WebKit

struct WKWebViewWrapper: UIViewRepresentable {
    let url: URL?
    let isLocalHTML: Bool
    var onStationFragmentTapped: ((String) -> Void)? = nil
    @Binding var isLoading: Bool
    
    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        
        if !isLocalHTML {
            // Register the script message handler for Xcode console logging
            configuration.userContentController.add(context.coordinator, name: "logger")
            
            // Hide the body initially at document start to prevent flashing the header/footer
            let hideSource = """
            var style = document.createElement('style');
            style.id = 'hide-body-style';
            style.innerHTML = 'body { display: none !important; }';
            document.documentElement.appendChild(style);
            """
            let hideScript = WKUserScript(source: hideSource, injectionTime: .atDocumentStart, forMainFrameOnly: true)
            configuration.userContentController.addUserScript(hideScript)
            
            // Use MutationObserver at document start to wait for the target div to appear dynamically (React/Next.js hydration)
            let observerSource = """
            (function() {
                function log(msg) {
                    if (window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.logger) {
                        window.webkit.messageHandlers.logger.postMessage(msg);
                    }
                }
                
                function isolate(targetDiv) {
                    log("Target div '.tabs.tabs-details' found! Isolating content.");
                    document.body.innerHTML = '';
                    document.body.appendChild(targetDiv);
                    
                    // Add clean styling for the isolated content
                    var style = document.createElement('style');
                    style.innerHTML = 'body { display: block !important; padding: 16px !important; background-color: transparent !important; }';
                    document.documentElement.appendChild(style);
                }
                
                log("Setting up MutationObserver to watch for dynamic DOM hydration...");
                
                var targetDiv = document.querySelector('div.tabs.tabs-details');
                if (targetDiv) {
                    isolate(targetDiv);
                } else {
                    var observer = new MutationObserver(function(mutations, obs) {
                        var targetDiv = document.querySelector('div.tabs.tabs-details');
                        if (targetDiv) {
                            obs.disconnect();
                            isolate(targetDiv);
                        }
                    });
                    
                    observer.observe(document.documentElement, {
                        childList: true,
                        subtree: true
                    });
                    
                    // Safety fallback: if it doesn't appear in 5 seconds, reveal the body and dump DOM info
                    setTimeout(function() {
                        observer.disconnect();
                        var style = document.getElementById('hide-body-style');
                        if (style) {
                            log("Target div '.tabs.tabs-details' not found after 5s timeout. Revealing default page.");
                            style.remove();
                            
                            // Dump structural details of the DOM for debugging
                            var firstDivs = Array.from(document.querySelectorAll('div'))
                                .slice(0, 15)
                                .map(function(d) { return d.tagName + (d.className ? '.' + d.className.split(' ').join('.') : '') + (d.id ? '#' + d.id : ''); });
                            log("Top 15 DOM elements found: " + JSON.stringify(firstDivs));
                        }
                    }, 5000);
                }
            })();
            """
            let observerScript = WKUserScript(source: observerSource, injectionTime: .atDocumentStart, forMainFrameOnly: true)
            configuration.userContentController.addUserScript(observerScript)
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
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WKWebViewWrapper
        var lastLoadedURL: URL? = nil
        var lastLoadedLocalHTML = false
        
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

extension WKWebViewWrapper.Coordinator: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "logger" {
            print("WKWebView [JS LOG]: \(message.body)")
        }
    }
}
