//
//  WebView.swift
//  ComcastCore
//
//  Created by David Vallas on 7/18/19.
//  Copyright © 2019 David Vallas. All rights reserved.
//

import UIKit
import WebKit

public class WebVC: UIViewController, WKUIDelegate {
    
    var webView: WKWebView!
    var url: URL = URL(string:"https://www.apple.com")!
    
    override public func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        title = "Character Info"
        view = webView
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        let myRequest = URLRequest(url: url)
        webView.load(myRequest)
    }
}
