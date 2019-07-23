//
//  Storage.swift
//  OnTheMap
//
//  Created by Lucas Stern on 02/06/2018.
//  Copyright © 2018 Stern. All rights reserved.
//

import Foundation
class Storage {
    
    var user: User? = nil
    var student: Student? = nil
    var students: [Student] = [Student]()
    
    /*
     * Return the singleton instance of Storage
     */
    class var shared: Storage {
        struct Static {
            static let instance: Storage = Storage()
        }
        return Static.instance
    }
}
