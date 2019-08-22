import UIKit
import WebKit

class WebViewController: MTBaseViewController {

    public var urlRequest: URLRequest

    var webView = WKWebView(frame: CGRect.zero, configuration:  WKWebViewConfiguration())

    //web component initialize
    public required init(_ url: URL) {
        self.urlRequest = URLRequest(url: url)
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //back to previous scene
    @objc func pop() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    open override func viewDidLoad() {
        super.viewDidLoad()

        
        webView.allowsBackForwardNavigationGestures = true
        webView.contentMode = .scaleAspectFit
        view.addSubview(webView)
        webView.load(urlRequest)
        
        addNavigationBarLeftButton(self)

        
    }
    

    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        webView.stopLoading()
    }

}




