
//
//  LoginViewController.swift
//  TestCase
//
//  Created by Omar Al tawashi on 5/7/19.
//  Copyright © 2019 Omar Al tawashi. All rights reserved.
//

import UIKit
extension UIViewController{
    func showAlert(with title: String?, message: String?) {
        DispatchQueue.main.async {
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
}
class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let _ = UserDefaults.standard.value(forKey: "token") as? Data {
            
            self.GoHome()
            
        }
        // Do any additional setup after loading the view.
    }
    func GoHome(){
        
        DispatchQueue.main.async {
            let HomeNav = self.storyboard?.instantiateViewController(withIdentifier: "HomeNav")
            
            let window = (UIApplication.shared.delegate as? AppDelegate)?.window
            
            window?.rootViewController = HomeNav
        }
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func loginPressed(_ sender: Any) {
        
        let email = (emailTextField.text ?? "").lowercased()
        let password = passwordTextField.text ?? ""
        
        let url = URL(string: "https://test.gamiphy.co/bots/api/v1/5ccffa1f0aa74700178e4c83/auth/login")!
        
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        let postData = NSMutableData(data: "email=\(email)&password=\(password)".data(using: String.Encoding.utf8)!)
        let request1 = NSMutableURLRequest(url: url,
                                           cachePolicy: .useProtocolCachePolicy,
                                           timeoutInterval: 10.0)
        request1.httpMethod = "POST"
        request1.allHTTPHeaderFields = headers
        request1.httpBody = postData as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request1 as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error!)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse!)
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary
                    print(json)
                    
                    if  let token = json?["token"] as? String {
                        print(token)
                        
                        UserDefaults.standard.setValue(token, forKey: "token")
                        UserDefaults.standard.setValue(data, forKey: "userLogin")
                        
                        UserDefaults.standard.synchronize()
                        
                        self.GoHome()
                    }
                    else{
                        self.showAlert(with: "Error", message: "\(String(describing: json))")
                    }
                } catch {
                    print(error)
                }
                
            }
        })
        dataTask.resume()
        
        
    }
    
    
    @IBAction func registerPressed(_ sender: Any) {
        
        let email = (emailTextField.text ?? "").lowercased()
        let password = passwordTextField.text ?? ""
        let name = nameTextField.text ?? ""
        
        let url = URL(string: "https://test.gamiphy.co/bots/api/v1/5ccffa1f0aa74700178e4c83/auth/signup")!
        
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        let postData = NSMutableData(data: "name=\(name)&email=\(email)&password=\(password)".data(using: String.Encoding.utf8)!)
        let request1 = NSMutableURLRequest(url: url,
                                           cachePolicy: .useProtocolCachePolicy,
                                           timeoutInterval: 10.0)
        request1.httpMethod = "POST"
        request1.allHTTPHeaderFields = headers
        request1.httpBody = postData as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request1 as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error!)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse!)
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary
                    if let token = json?["token"] as? String {
                        print(token)
                        
                        UserDefaults.standard.setValue(token, forKey: "token")
                        UserDefaults.standard.setValue(data, forKey: "userLogin")
                        UserDefaults.standard.synchronize()
                        self.GoHome()
                        
                    }
                    else{
                        self.showAlert(with: "Error", message: "\(String(describing: json))")
                        
                    }
                } catch {
                    print(error)
                }
                
            }
        })
        dataTask.resume()
        
        
    }
    
    
    
}


