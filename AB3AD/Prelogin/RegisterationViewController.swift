//
//  RegisterationViewController.swift
//  AB3AD
//
//  Created by Apple on 06/08/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class RegisterationViewController: UIViewController {

    @IBOutlet weak var userNameTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var mobileNumberTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    lazy var netClient : NetworkClient = NetworkClient()
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.userNameTxtField.delegate = self
        self.passwordTxtField.delegate = self
        self.mobileNumberTxtField.delegate = self
        self.emailTxtField.delegate = self
       
    }
    @IBAction func signupButtonClickAction(_ sender: UIButton) {
        
        if userNameTxtField.text!.isEmpty {
            print("")
        }else if passwordTxtField.text!.isEmpty{
            
        }else if mobileNumberTxtField.text!.isEmpty{
            
        }else if emailTxtField.text!.isValidEmail() == false{
            
        }else{
            let url = BaseUrl
            let reqParams:[String: String] = ["tag" : "register", "user_name" : userNameTxtField.text!, "mobile_no" : mobileNumberTxtField.text!, "password" : self.passwordTxtField.text!,"email":emailTxtField.text!,"user_type":"customer"]
            netClient.commonAPICallingWithFormData(url: url, parameter: reqParams) { (data, error) in
                if let data = data{
                    do {
                        if let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary{
                            print(jsonObject.value(forKey: "message"))
                        }
                    } catch let error {
                        print(error)
                    }
                }
            }
        }
        
    }
    
    @IBAction func loginButtonClickAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
            self.scrollView.contentInset.bottom = keyboardFrame.cgRectValue.height
        }else{
            self.scrollView.contentInset.bottom = 0.0
        }
    }
}

extension RegisterationViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       textField.resignFirstResponder()
       return true
    }
}
