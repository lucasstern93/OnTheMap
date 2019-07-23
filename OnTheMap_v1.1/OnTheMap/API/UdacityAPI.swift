//
//  UdacityAPI.swift
//  OnTheMap
//
//  Created by Lucas Stern on 01/06/2018.
//  Copyright © 2018 Stern. All rights reserved.
//

import Foundation
class UdacityAPI: APICore {
    var sessionId: String? = nil
    var userId: String? = nil
    
    let apiUrl = "https://www.udacity.com/api/session"
    
    private override init() {
        super.init()
        
        self.headers = [
            "Accept": "application/json",
            "Content-Type": "application/json",
        ]
    }
    
    class func sharedInstance() -> UdacityAPI {
        struct Singleton {
            static var sharedInstance = UdacityAPI()
        }
        return Singleton.sharedInstance
    }
    
    func createSession(username: String, password: String, handler: @escaping (_ error: String?) -> Void) {
        
        let body = [
            "udacity": [
                "username": username,
                "password": password
            ]
        ]
        
        super.taskForCallAPI(url: apiUrl, method: .Post, body: body) { (result, error) in
            if let error = error {
                print(error)
                handler(error.localizedDescription)
            } else {
                guard let account = result?["account"] as? [String : AnyObject], let userId = account["key"] as? String else {
                    print("Can't find [account][key] in response")
                    handler("Username or password is incorrect")
                    return
                }
                
                guard let session = result?["session"] as? [String : AnyObject], let sessionId = session["id"] as? String else {
                    print("Can't find [session][id] in response")
                    handler("Username or password is incorrect")
                    return
                }
                
                self.sessionId = sessionId
                self.userId = userId
                
                handler(nil)
            }
        }
    }
    
    func deleteSession(handler: @escaping (_ error: String?) -> Void) {
        
        let _ = super.taskForCallAPI(url: apiUrl, method: .Delete, body: nil) { (result, error) in
            guard error == nil else {
                handler("Logout Failed")
                return
            }
            
            guard let session = result?["session"] as? [String : AnyObject], let sessionId = session["id"] as? String else {
                print("Can't find [session][id] in response")
                handler("Connection error")
                return
            }
            
            self.sessionId = sessionId
            self.userId = nil
            
            handler(nil)
        }
    }
    
    func getUserInfo(handler: @escaping (_ user: User?, _ error: String?) -> Void) {
        super.taskForCallAPI(url: "https://www.udacity.com/api/users/\(UdacityAPI.sharedInstance().userId!)", method: .Get, parameters: nil, body: nil) { (result, error) in
            guard error == nil else {
                handler(nil, error?.localizedDescription)
                return
            }
            
            guard let userData = result?["user"] as? [String : AnyObject] else {
                print("Can't find [user] in response")
                handler(nil, "Connection error")
                return
            }
            
            guard let firstName = userData["first_name"] as? String, let lastName = userData["last_name"] as? String else {
                print("Can't find [user]['first_name'] or [user]['last_name'] in response")
                handler(nil, "Connection error")
                return
            }
            
            let user = User(dictionary: [
                "id": UdacityAPI.sharedInstance().userId! as AnyObject,
                "firstName": firstName as AnyObject,
                "lastName": lastName as AnyObject,
                ])
            
            handler(user, nil)
        }
    }
}
