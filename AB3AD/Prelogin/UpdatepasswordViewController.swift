//
//  ForgotPasswordViewController.swift
//  AB3AD
//
//  Created by Apple on 10/08/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class UpdatepasswordViewController: UIViewController {

     lazy var netClient : NetworkClient = NetworkClient()
    
    @IBOutlet weak var passwordTxtField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func forgotButtonClickAction(_ sender: UIButton) {
        if passwordTxtField.text!.isEmpty{
            self.showAlertMessage(message: "Enter your valid password", title: "")
        }else{
            let url = BaseUrl
            let reqParams:[String: String] = ["tag" : "updatepwd", "user_id" : "", "password" : self.passwordTxtField.text!]
            netClient.commonAPICallingWithFormData(url: url, parameter: reqParams) { (data, error) in
                if let data = data{
                    do {
                        if let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary{
                            if let message = jsonObject.value(forKey: "status") as? String {
                               print(message)
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
}
