//
//  WebViewController.swift
//  PAYBACK
//
//  Created by Mohammad Takbir on 6/20/21.
//

import UIKit
import WebKit
import SVProgressHUD

class WebViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    var url: URL!
    var tileDetail: Tile!{
        didSet{
            if let data = tileDetail.data{
                url = URL(string: data)!
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    func updateUI(){
        self.navigationItem.title = tileDetail.headline
        
        guard let url = URL(string: tileDetail.data ?? "") else {return}
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
//        webView.uiDelegate = self
        webView.navigationDelegate = self
        
    }
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        SVProgressHUD.show()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
    }
}
