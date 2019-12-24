import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {

    var webView : WKWebView!
    var progressView: UIProgressView!
    var webSites = ["apple.com","hackingwithswift.com"]
    var selectedWebSite : String?
    
    override func loadView() {
        
        webView = WKWebView()
        webView.navigationDelegate = self

        view = webView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        let backButton = UIBarButtonItem(barButtonSystemItem: .rewind, target: webView, action: #selector(webView.goBack))
        let forwardButton = UIBarButtonItem(barButtonSystemItem: .play, target: webView, action: #selector(webView.goForward))
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        toolbarItems = [progressButton,spacer,backButton,forwardButton,refresh]
        navigationController?.isToolbarHidden = false
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        guard let selectedSiteUnwraped = selectedWebSite else {return}
        
        let url = URL(string: "http://"+selectedSiteUnwraped)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true

    }

    @objc func openTapped(){
        
        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        
        for webSite in webSites {
            ac.addAction(UIAlertAction(title: webSite, style: .default, handler: openPage))
        }
        ac.addAction(UIAlertAction(title: "uol.com", style: .default, handler: openPage))

        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac,animated: true)
        
    }
    
    func openPage(action: UIAlertAction){
        
        guard let actionTitle = action.title else {return}
        guard let url = URL(string: "https://"+actionTitle) else {return}
        
        webView.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        progressView.progress = Float(webView.estimatedProgress)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        let url = navigationAction.request.url
        
        if let host = url?.host {
            for webSite in webSites {
                if host.contains(webSite){
                    print("passou por aqui \(host)")
                    decisionHandler(.allow)
                    return
                }
            }

            let alertController = UIAlertController(title: "Alert", message: "Parça não faz isso", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Acesso negado", style: .default, handler: nil))
            present(alertController,animated: true)
        }
        
        decisionHandler(.cancel)
        
    }
    
}

