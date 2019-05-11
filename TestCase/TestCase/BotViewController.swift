//
//  BotViewController.swift
//  TestCase
//
//  Created by Omar Al tawashi on 5/7/19.
//  Copyright © 2019 TestCase. All rights reserved.
//

import UIKit
import WebKit

class BotViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let config = WKWebViewConfiguration()
        let userContentController = WKUserContentController()
        
        // Add script message handlers that, when run, will make the function
        // window.webkit.messageHandlers.test.postMessage() available in all frames.
        userContentController.add(self, name: "test")
        
        if let data = UserDefaults.standard.value(forKey: "userLogin") as? Data{
            do {
                
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary
                let token = json?["token"] as? String
                
                let scriptSource = "window.postMessage({origin: 'Gamiphy', type: 'init',  data: {token: '\(token!)'}},'*')"
                
                let userScript = WKUserScript(source: scriptSource, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
                userContentController.addUserScript(userScript)
                
                config.userContentController = userContentController
                
            } catch {
                print(error)
            }
        }
        
        let webView = WKWebView(frame: .zero, configuration: config)
        
        view.addSubview(webView)
        
        let layoutGuide = view.safeAreaLayoutGuide
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: layoutGuide.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor).isActive = true
        
        // Make sure in Info.plist you set `NSAllowsArbitraryLoads` to `YES` to load
        // URLs with an HTTP connection. You can run a local server easily with services
        // such as MAMP.
        if let url = URL(string: "https://5ccffa1f0aa74700178e4c83.test.bot.gamiphy.co") {
            webView.load(URLRequest(url: url))
        }

        let LogoutItem = UIBarButtonItem(title: "Logout", style: .plain, target:self, action:  #selector(LogoutAction(_:)))
        LogoutItem.tintColor = .orange
        self.navigationItem.rightBarButtonItems = [LogoutItem]
    }
    
    @IBAction func LogoutAction(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.removeObject(forKey: "userLogin")
        UserDefaults.standard.synchronize()
        
        let HomeNav = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
        
        let window = (UIApplication.shared.delegate as? AppDelegate)?.window
        
        window?.rootViewController = HomeNav
    }
}

extension BotViewController: WKScriptMessageHandler {

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if let messageBody = message.body as? String {
            print(messageBody)
        }
    }
    
    
}

