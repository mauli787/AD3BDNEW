//
//  BaseUrl.swift
//  AB3AD
//
//  Created by Abhishek Singh on 09/08/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation


class LastAB3ADAPI {
    static let baseURLString = "http://150.129.62.46:8081/osamaecommerce/"
    static let companyes = "items.php"
}

protocol UrlConverting {
    
    func url() -> URL?
}

enum AB3ADRequestTypesCheck{
   
    case Company_List_Fetch
    
}

extension AB3ADRequestTypesCheck: UrlConverting{
    
    func url() -> URL? {
        
      //  var logintokenfetch: TokenShareAnyWhere!
     //   var token = String()
        //Sent Service Layer For API
        //Mark Login Token Fetch
     //   logintokenfetch = TokenShareAnyWhere()
     //   token = logintokenfetch.logintokenShare()
        
        switch self {
        case .Company_List_Fetch:
            let companyListBindStr = "\(LastAB3ADAPI.companyes)"
            return URL(string: "\(LastAB3ADAPI.baseURLString)\(companyListBindStr)")
            
        default:
            return URL(string: "")
        }
    }
    
    func str() -> String? {
        switch self {
        case .Company_List_Fetch:
            let companyListBindStr = "\(LastAB3ADAPI.companyes)"
            return "\(LastAB3ADAPI.baseURLString)\(companyListBindStr)"
            
        default:
            return ""
        }
    }
}

