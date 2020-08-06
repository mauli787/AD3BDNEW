//
//  ViewController.swift
//  AB3AD
//
//  Created by Apple on 06/08/20.
//  Copyright © 2020 Apple. All rights reserved.
// SDFSF 

import UIKit

let BaseUrl = "http://150.129.62.46:8081/osamaecommerce/profile.php"


class LoginViewController: UIViewController {


    @IBOutlet weak var userNameTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    lazy var netClient : NetworkClient = NetworkClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func loginButtonClickAction(_ sender: UIButton) {
        
        if userNameTxtField.text!.isEmpty {
             self.showAlertMessage(message: "Enter your register mobile number", title: "")
        }else if passwordTxtField.text!.isEmpty{
            self.showAlertMessage(message: "Enter your valid password", title: "")
        }else{
            let url = BaseUrl
            let reqParams:[String: String] = ["tag" : "login", "mobile_no" : self.userNameTxtField.text!, "password" : self.passwordTxtField.text!]
            netClient.commonAPICallingWithFormData(url: url, parameter: reqParams) { (data, error) in
                if let data = data{
                    do {
                        if let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary{
                            if let message = jsonObject.value(forKey: "status") as? String {
                                self.showAlertMessage(message: message, title: "")
                            }else{
                                self.showAlertMessage(message: error!.localizedDescription, title: "")
                            }
                        }
                    } catch let error {
                        print(error)
                    }
                }
            }
        }
        
    }
    
    @IBAction func signupButtonClickAction(_ sender: UIButton) {
     let storyboard = UIStoryboard(name: "Main", bundle: nil)
     let createVC = storyboard.instantiateViewController(withIdentifier: "RegisterationViewController") as! RegisterationViewController
     self.navigationController?.pushViewController(createVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        adjustInsetForKeyboardShow(true, notification: notification)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        adjustInsetForKeyboardShow(false, notification: notification)
    }
    func adjustInsetForKeyboardShow(_ show: Bool, notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey]
                as? NSValue
            else {
                return
        }
        if show {
           // self.view.contentInset.bottom = keyboardFrame.cgRectValue.height
        }else{
          //  self.view.contentInset.bottom = 0.0
        }
    }

}

