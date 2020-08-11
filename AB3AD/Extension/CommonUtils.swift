//
//  CommonUtils.swift
//  AB3AD
//
//  Created by Apple on 06/08/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIViewController {
   func popupAlert(title: String?, message: String?, actionTitles:[String?], actionStyle:[UIAlertAction.Style], actions:[((UIAlertAction) -> Void)?], vc: UIViewController) {
          let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
          for (index, title) in actionTitles.enumerated() {
               let action = UIAlertAction(title: title, style: actionStyle[index], handler: actions[index])
               alert.addAction(action)
          }
          vc.present(alert, animated: true, completion: nil)
     }
    func showAlertMessage(message: String, title: String = "") {
       let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
       let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
       alertController.addAction(OKAction)
       self.present(alertController, animated: true, completion: nil)
     }
}

 
extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}

extension UIImageView {
    
        func imageFromServerURL(_ URLString: String, placeHolder: UIImage?) {

        self.image = nil
        //If imageurl's imagename has space then this line going to work for this
        let imageServerUrl = URLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if let cachedImage = imageCache.object(forKey: NSString(string: imageServerUrl)) {
            self.image = cachedImage
            return
        }

        if let url = URL(string: imageServerUrl) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in

                //print("RESPONSE FROM API: \(response)")
                if error != nil {
                    print("ERROR LOADING IMAGES FROM URL: \(error)")
                    DispatchQueue.main.async {
                        self.image = placeHolder
                    }
                    return
                }
                DispatchQueue.main.async {
                    if let data = data {
                        if let downloadedImage = UIImage(data: data) {
                            imageCache.setObject(downloadedImage, forKey: NSString(string: imageServerUrl))
                            self.image = downloadedImage
                        }
                    }
                }
            }).resume()
        }
    }
}



