//
//  NetworkClient.swift
//  AB3AD
//
//  Created by Apple on 06/08/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import Alamofire

class NetworkClient : NSObject {
    
    func commonAPICallingWithFormData(url:String,parameter:[String:Any],completionHandler: @escaping ((Data?, Error?) -> Void)){
        
        let error = NSError()
        Alamofire.request(url, method: .post, parameters: parameter, encoding: URLEncoding.default).validate(statusCode: 200..<299).responseJSON(completionHandler: { response in
                   switch response.result {
                   case .success(let data):
                    let jsondata = try! JSONSerialization.data(withJSONObject: data, options: .fragmentsAllowed)
                    completionHandler(jsondata as? Data,error)
                   case .failure(let error):
                        completionHandler(Data(),error)
                       // Do your code here...
                }
        })
    }
}
