//
//  User.swift
//  YouDJ
//
//  Created by Soren Nelson on 9/23/15.
//  Copyright © 2015 Jordan Nelson. All rights reserved.
//

import Foundation
import Firebase

class User: NSObject {

    let email: String
    let password: String
    let name: String
    let usersRef: Firebase?
    let uid: String
    
    init(email: String, password: String, name: String, uid: String) {
        
        self.email = email
        self.password = password
        self.name = name
        self.usersRef = nil
        self.uid = uid
    }
    
    init(snapshot: FDataSnapshot) {
        email = snapshot.value["email"] as! String
        password = snapshot.value["password"] as! String
        name = snapshot.value["name"] as! String
        usersRef = snapshot.ref
        uid = snapshot.value["uid"] as! String
    }
    
    func toAnyObject () -> AnyObject {
        return [
            "email": email,
            "password": password,
            "name": name,
            "uid": uid
        ]
    }
}

