//
//  NetworkClient.swift
//  IDFC Mobile Banking
//
//  Created by Basant Sarda on 18/11/19.
//  Copyright © 2019 IDFC Bank. All rights reserved.
//

import UIKit
enum Result<T> {
    case success(T)
    case failure(Error)
}

class NetworkClient: NSObject ,URLSessionDelegate{
    var baseURL: URL
    var errorUtils: ErrorUtils

    static var configBaseUrl: URL {
        return URL(string: "https://ecomuat.idfcbank.com/")!
    }
    
    init(baseURL: URL? = nil, errorUtils: ErrorUtils = ErrorUtils()) {
        self.baseURL = baseURL ?? NetworkClient.configBaseUrl
        self.errorUtils = errorUtils
        super.init()
    }

    // public methods to be used by client.

    func get<T: Decodable>(
        path: String,
        queryParams: [(name: String, value: String)]? = [],
        headers: [(name: String, value: String)]? = [],
        body: [(name: String, value: Any)]? = [],
        expectedResponseType: T.Type,
        completionHandler: ((T?, Error?) -> Void)? = { _, _ in }
    ) {
        executeRequestInternal(
            request: createURLRequest(
                method: "GET",
                path: path,
                queryParams: queryParams,
                headers: headers,
                body: body,
                customBody: ""
            ),
            expectedResponseType: expectedResponseType,
            completionHandler: completionHandler!
        )
    }

    func post<T: Decodable>(
        path: String,
        headers: [(name: String, value: String)]? = [],
        expectedResponseType: T.Type,
        body: Any? = nil,
        customBody: String = "",
        completionHandler: ((T?, Error?) -> Void)? = { _, _ in }
    ) {
        executeRequestInternal(
            request: createURLRequest(
                method: "POST",
                path: path,
                queryParams: [],
                headers: headers,
                body: body,
                customBody: customBody
            ),
            expectedResponseType: expectedResponseType,
            completionHandler: completionHandler!
        )
    }

    // utility methods

    private func executeRequestInternal<T: Decodable>(
        request: URLRequest,
        expectedResponseType: T.Type,
        completionHandler: ((T?, Error?) -> Void)? = { _, _ in }
    ) {
   

        let session = URLSession(
               configuration: URLSessionConfiguration.default,
               delegate: self,
               delegateQueue: nil)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
        print(error as Any)
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode < 300, let data = data {
                
                let headers = httpStatus.allHeaderFields
               
                print(String(decoding: data, as: UTF8.self))

                completionHandler!(self.processSuccess(expectedResponseType, data: data), nil)
            } else {
                if let data = data {
                    print(String(decoding: data, as: UTF8.self))
                }
                completionHandler!(nil, self.processError(data: data, httpResponse: response as? HTTPURLResponse))
            }
        }.resume()
    }
    
    
//    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
//          if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
//              if let serverTrust = challenge.protectionSpace.serverTrust {
//                  let filenameList = ["ServerCertificate"]
//                  let certificateVerified = Utility.validateCertificate(serverTrust, withFileName: filenameList, withHost: challenge.protectionSpace.host)
//                  Utility.validateCertificate(serverTrust, withFileName: filenameList, withHost: challenge.protectionSpace.host)
//
//                  if (certificateVerified){
//                      completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust:serverTrust))
//                      return
//                  }else{
//                      completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
//                  }
//              }
//          }
//      }
    func processError(data: Data?, httpResponse: HTTPURLResponse?) -> Error {
        return errorUtils.getErrorFromData(data: data, response: httpResponse)!
    }

    func processSuccess<T: Decodable>(_ type: T.Type, data: Data) -> T? {
        switch type {
        case is Bool.Type:
            return true as? T
        case is Data.Type:
            return data as? T
        case is String.Type:
            return String(decoding: data, as: UTF8.self) as? T
        default:
            do {
                return try JSONDecoder().decode(type, from: data)
            } catch {
                return nil
            }
        }
    }

    func createURLRequest(method: String,
                          path: String,
                          queryParams: [(name: String, value: String)]?,
                          headers: [(name: String, value: String)]?,
                          body: Any?, customBody: String) -> URLRequest {
        var urlComponent = URLComponents(string: baseURL.appendingPathComponent(path).absoluteString)
        
        // add query parameters if available
        urlComponent!.queryItems = []
        for queryParam in queryParams! {
            urlComponent!.queryItems?.append(URLQueryItem(name: queryParam.name, value: queryParam.value))
        }

        var urlRequest = URLRequest(url: (urlComponent?.url)!)
        urlRequest.httpMethod = method

        // set XSRF token header
        if let headers = headers {
            for header in headers {
                urlRequest.setValue(header.value, forHTTPHeaderField: header.name)
            }
        }

        // set body if present
        if body != nil {
            if urlRequest.value(forHTTPHeaderField: "Content-Type") != nil {
                // in case if content type is provided, then just pass the body
                if customBody.isEmpty {
                    if let body = body as? Data {
                        urlRequest.httpBody = body
                    } else {
                        urlRequest.httpBody = getFormBody(body as? [String: String])
                    }
                } else {
                    urlRequest.httpBody = customBody.data(using: .utf8)
                }
            } else {
                // by default serialize body to json and set content type.
                urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: body!)
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        }

        return urlRequest
    }

    func getFormBody(_ parameters: [String: String]?) -> Data? {
        let arr = parameters?.map { (key, value) -> String in
            key + "=" + value
        }
        return arr?.joined(separator: "&").data(using: .utf8)
    }
    
    static func fetchInsuranceData<T: Decodable>(insuSSranceJsonStr: String, anyTypeObject: T.Type, completion: @escaping (_ result: T) -> Void) {
    print(anyTypeObject)
    if let path = Bundle.main.path(forResource: insuranceJsonStr, ofType: "json"){
        let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        if let data = data{
       
            do {
                   let json = try
                       JSONDecoder().decode(anyTypeObject.self, from: data)
                   completion(json)
                      // print(boats)
               } catch {
                  // print(err)
               }
       
       }
      }
    }
    
    
}
