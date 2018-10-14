//
//  BaseNetworkCall.swift
//  AskNot
//
//  Created by Elliot Schrock on 2/8/17.
//  Copyright © 2017 billygoatsgruff. All rights reserved.
//

import UIKit

class BaseNetworkCall: NSObject {
    let hostName: String = "asknot.herokuapp.com"
    let scheme: String = "https"
    let apiVersion: String = "/api/v1"
    var endpoint: String!
    var httpMethod: String!
    var postData: Data?
    var headers: Dictionary<String, String>?
    
    func execute(_ completion: @escaping ((AnyObject?, NSError?) -> Void)){
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let request = NSMutableURLRequest(url: NSURL(scheme: scheme, host: hostName, path: apiVersion + endpoint) as! URL)
        request.httpMethod = httpMethod;
        request.setValue("application/json", forHTTPHeaderField: "Content-type")
        if let data = postData, httpMethod != "GET" {
            request.httpBody = data
        }
        if let unwrappedHeaders = headers {
            for key in unwrappedHeaders.keys {
                request.addValue(unwrappedHeaders[key]!, forHTTPHeaderField: key)
            }
        }
        
        session.dataTask(with: request as URLRequest) { (data, response, error) in
            DispatchQueue.main.async {
                if let connectionError = error {
                    notify(error: connectionError as NSError)
                    completion(nil, connectionError as NSError?)
                }else if let responseCode = (response as? HTTPURLResponse)?.statusCode {
                    if responseCode < 299 {
                        if let jsonData = data {
                            do {
                                let json = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments)
                                completion(json as AnyObject?, nil)
                            } catch let parseError as NSError {
                                completion(nil, parseError)
                            }
                        }else {
                            completion(nil, nil)
                        }
                    }else {
                        let url = request.url?.absoluteString ?? ""
                        let serverError = NSError(domain: "Server", code: responseCode, userInfo: ["url" : url])
                        notify(error: serverError)
                        completion(nil, serverError)
                    }
                }
            }
        }.resume();
    }
}

