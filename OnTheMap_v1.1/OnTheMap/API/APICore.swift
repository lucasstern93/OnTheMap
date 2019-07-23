//
//  APICore.swift
//  OnTheMap
//
//  Created by Lucas Stern on 01/06/2018.
//  Copyright © 2018 Stern. All rights reserved.
//

import Foundation
class APICore: NSObject {
    var session = URLSession.shared
    var headers: [String: String] = [String: String]()
    enum Method: String {
        case Get
        case Post
        case Put
        case Delete
    }
    
    override init() {
        super.init()
    }
    
    func prepareRequest(url: String, method: Method, parameters: [String: AnyObject]?, body: Any?) -> NSMutableURLRequest {
        
        var components = URLComponents()
        components.queryItems = [URLQueryItem]()
        
        if let parameters = parameters {
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }
        
        let request = NSMutableURLRequest(url: components.url(relativeTo: URL(string: url)!)!)
        
        request.httpMethod = method.rawValue.uppercased()
        
        if method == Method.Delete {
            var xsrfCookie: HTTPCookie? = nil
            let sharedCookieStorage = HTTPCookieStorage.shared
            for cookie in sharedCookieStorage.cookies! {
                if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
            }
            if let xsrfCookie = xsrfCookie {
                request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
            }
        }
        else {
            for (header, value) in headers {
                request.addValue(value, forHTTPHeaderField: header)
            }
        }
        
        if body != nil {
            do {
                request.httpBody = try! JSONSerialization.data(withJSONObject: body!, options: .prettyPrinted)
            }
        }
        
        return request
    }
    
    func taskForCallAPI(url: String, method: Method, parameters: [String: AnyObject], handler: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) {
        taskForCallAPI(url: url, method: method, parameters: parameters, body: nil, handler: handler)
    }
    
    func taskForCallAPI(url: String, method: Method, body: Any?, handler: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) {
        taskForCallAPI(url: url, method: method, parameters: nil, body: body, handler: handler)
    }
    
    func taskForCallAPI(url: String, method: Method, parameters: [String: AnyObject]?, body: Any?, handler: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) {
        let request = prepareRequest(url: url, method: method, parameters: parameters, body: body)
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                handler(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            guard error == nil else {
                print("Error in response")
                sendError("Connection error")
                return
            }
            
            guard let status = (response as? HTTPURLResponse)?.statusCode, status != 403 else {
                print("Wrong response status code (403)")
                sendError("Username or password is incorrect")
                return
            }
            
            guard status >= 200 && status <= 299 else {
                print("Wrong response status code \(status)")
                sendError("Connection error")
                return
            }
            
            guard let data = data else {
                print("Wrong response data")
                sendError("Connection error")
                return
            }
            
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: handler)
        }
        
        task.resume()
    }
    
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var newData = data
        if self.isKind(of: UdacityAPI.self) {
            let range = Range(5..<data.count)
            newData = data.subdata(in: range) /* subset response data! */
        }
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
}
