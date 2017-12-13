//
//  VKViewController.swift
//  L1_ArtemBelyaev
//
//  Created by Артем Б on 02.10.17.
//  Copyright © 2017 Артем Б. All rights reserved.
//

import UIKit
import  WebKit

class VKLoginVC: UIViewController, UIWebViewDelegate  {
    
    @IBOutlet weak var webView: UIWebView!{
        didSet{
            webView.delegate = self
        }
    }
    
    var globalToken = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let serv = VKLogin()
        webView.loadRequest(serv.executeAutorization())
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if let url = webView.request?.url,
            url.path == "/blank.html",
            let fragment = url.fragment {

            let parametrs = fragment
                .components(separatedBy: "&")
                .map{ $0.components(separatedBy: "=") }
                .reduce([String: String]()){ result, params in
                    var dictionary = result
                    let key = params[0]
                    let value = params[1]
                    dictionary[key] = value
                    return dictionary
            }
            
            print(parametrs)
            
            let tokenOpt = parametrs["access_token"]
            
            
            if let token = tokenOpt{
                let date = Date().timeIntervalSince1970
                
                Constants.TOKEN = token
                UserDefaults.standard.set(date, forKey: "date")
                UserDefaults.standard.set(Constants.TOKEN, forKey: "token")
                UserDefaults.standard.set(true, forKey: "isLogin")
                performSegue(withIdentifier: "unwindToUser", sender: self)
            }
            
            
        }
    }
}
