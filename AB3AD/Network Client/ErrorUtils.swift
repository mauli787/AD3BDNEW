//
//  ErrorUtils.swift
//  IDFC Mobile Banking
//
//  Created by Basant Sarda on 18/11/19.
//  Copyright © 2019 IDFC Bank. All rights reserved.
//

import UIKit

class ErrorUtils: NSObject {
    var errorMessage = "Sorry! Due to some technical issue the request could not be processed. Please try again in a while."

    func getErrorFromData(data: Data?, response: HTTPURLResponse?) -> Error? {
        let genericError = NSError(domain: NSURLErrorDomain,
                                   code: 401,
                                   userInfo: [NSLocalizedDescriptionKey: errorMessage])
        
        guard let errorCode = response?.statusCode, let data = data else {
            return genericError
        }
        
        if let errorDict = String(bytes: data, encoding: .utf8)?.convertToDictionary(), let errorMsg = errorDict["message"] as? String {
            errorMessage = errorMsg
            if let errorCode = errorDict["code"] as? String {
                errorMessage = errorMessage + "*****" + errorCode
            }
        }
        
        if let errorDict = String(bytes: data, encoding: .utf8)?.convertToDictionary(), let errorMsg = errorDict["rsn"] as? String, !errorMsg.isEmpty {
            errorMessage = errorMsg
            if let erroRCode = errorDict["cd"] as? String {
               // errorMessage = errorMessage + "*****" + erroRCode
               // DBManager.shared()?.errorCode = erroRCode
            }
        }
            
        if errorCode == 503 {
            errorMessage = "We are trying to cool the server, please check back after a few minutes."
        }
        
        return NSError(
            domain: NSURLErrorDomain,
            code: errorCode,
            userInfo: [
                NSLocalizedDescriptionKey: errorMessage
            ]
        )
    }
}


extension String {
    func convertToDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {}
        }
        return nil
    }
}
