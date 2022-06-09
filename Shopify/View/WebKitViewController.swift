//
//  WebKitViewController.swift
//  Shopify
//
//  Created by Trident on 08/06/22.
//

import UIKit
import WebKit

class WebKitViewController: UIViewController, WKUIDelegate {
    @IBOutlet public var webView : WKWebView!
    var webViewHtml = EmptyStr
    var webViewCofig = WKWebViewConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
        // Load HTML content in WebView
        webView.loadHTMLStringWithMagic(content: "\(greaterPLesser) \(webViewHtml) \(greaterPLesser)", baseURL: nil)
    }
    
    override func loadView() {
        webView = WKWebView(frame: .zero, configuration: webViewCofig)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.hidesBackButton = true
    }
    
    //For title in navigation bar
    func setUpNavBar(){
        self.navigationController?.view.backgroundColor = UIColor.AppWhite.Base
        self.navigationController?.view.tintColor = UIColor.AppBlack.Base
        self.navigationItem.title = Description
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    //For back button in navigation bar
    let backButton : UIBarButtonItem = {
        let back = UIBarButtonItem()
        back.title = Back
        return back
    }()
    
    
}

