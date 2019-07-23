//
//  LocationAPI.swift
//  OnTheMap
//
//  Created by Lucas Stern on 01/06/2018.
//  Copyright © 2018 Stern. All rights reserved.
//

import Foundation
class LocationAPI: APICore {
    let apiUrl = "https://parse.udacity.com/parse/classes/StudentLocation"
    
    private override init() {
        super.init()
        
        self.headers = [
            "X-Parse-Application-Id": APICore.Constants.ApplicationID,
            "X-Parse-REST-API-Key": APICore.Constants.ApiKey,
            "Content-Type": "application/json",
        ]
    }
    
    class func sharedInstance() -> LocationAPI {
        struct Singleton {
            static var sharedInstance = LocationAPI()
        }
        return Singleton.sharedInstance
    }
    
    func getStudents(handler: @escaping (_ students: [Student]?, _ error: String?) -> Void) {
        
        let parameters: [String : AnyObject] = ["limit": 100 as AnyObject, "order": "-updatedAt" as AnyObject]
        
        super.taskForCallAPI(url: apiUrl, method: .Get, parameters: parameters) { (results, error) in
            guard error == nil else {
                handler(nil, error?.localizedDescription)
                return
            }
            
            guard let results = results?["results"] as? [[String : AnyObject]] else {
                print("Can't find [results] in response")
                handler(nil, "Connection error")
                return
            }
            
            var students: [Student] = []
            
            for result in results {
                students.append(Student(result))
            }
            
            handler(students, nil)
        }
    }
    
    func getStudent(userKey: String, handler: @escaping (_ result: Student?, _ error: String?) -> Void) {
        let parameters: [String : AnyObject] = ["where": "{\"uniqueKey\":\"\(userKey)\"}" as AnyObject]
        super.taskForCallAPI(url: apiUrl, method: .Get, parameters: parameters) { (results, error) in
            guard error == nil else {
                handler(nil, error?.localizedDescription)
                return
            }
            
            guard let results = results?["results"] as? [[String : AnyObject]] else {
                print("Can't find [results] in response")
                handler(nil, "Connection error")
                return
            }
            
            if let dictionary = results.first {
                handler(Student(dictionary), nil)
            }
            else {
                handler(nil, nil)
            }
        }
    }
    
    func postStudent(student: Student, handler: @escaping (_ error: String?) -> Void) {
        let body: Any = [
            "uniqueKey": student.uniqueKey,
            "firstName": student.firstName,
            "lastName": student.lastName,
            "mapString": student.mapString,
            "mediaURL": student.mediaURL,
            "latitude": student.latitude,
            "longitude": student.longitude,
            ]
        super.taskForCallAPI(url: apiUrl, method: .Post, body: body) { (results, error) in
            guard error == nil else {
                handler(error?.localizedDescription)
                return
            }
            
            guard let createdAt = results?["createdAt"] as? String, let objectId = results?["objectId"] as? String else {
                handler("Could not parse the data")
                return
            }
            
            print("\(createdAt) \(objectId)")
            handler(nil)
        }
    }
    
    func putStudent(student: Student, handler: @escaping (_ error: String?) -> Void) {
        let body: Any = [
            "uniqueKey": student.uniqueKey,
            "firstName": student.firstName,
            "lastName": student.lastName,
            "mapString": student.mapString,
            "mediaURL": student.mediaURL,
            "latitude": student.latitude,
            "longitude": student.longitude,
            ]
        super.taskForCallAPI(url: apiUrl + "/\(student.locationID!)", method: .Put, body: body) { (results, error) in
            guard error == nil else {
                handler(error?.localizedDescription)
                return
            }
            
            guard let updatedAt = results?["updatedAt"] as? String else {
                handler("Could not parse the data")
                return
            }
            
            print("\(updatedAt)")
            handler(nil)
        }
    }
}
