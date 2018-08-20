//
//  UserManager.swift
//  FinalProjectToDo
//
//  Created by Jonathan Compton on 8/19/18.
//  Copyright © 2018 Jonathan Compton. All rights reserved.
//

import Foundation
import FirebaseAuth

class UserManager: NSObject {
    
    static let shared = UserManager()
    
    var loggedIn = false
    var userName: String?
    var userId: String?
    
    func didLogIn(user: User) {
        UserManager.shared.userName = user.displayName
        UserManager.shared.loggedIn = true
        UserManager.shared.userId = user.uid
    }
}
