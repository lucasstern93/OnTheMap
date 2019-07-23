//
//  User.swift
//  OnTheMap
//
//  Created by Lucas Stern on 04/06/2018.
//  Copyright © 2018 Stern. All rights reserved.
//

import Foundation
struct User {
    
    var id: String = ""
    var firstName: String = ""
    var lastName: String = ""
    
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
    
    init(dictionary: [String : AnyObject]) {
        id = dictionary["id"] as! String
        firstName = dictionary["firstName"] as! String
        lastName = dictionary["lastName"] as! String
    }
}
