//
//  User.swift
//  BusyBrew
//
//  Created by Thomas Moody on 4/8/25.
//

import Foundation
import FirebaseFirestore

struct User: Codable, Identifiable {
    @DocumentID var id: String?
    
    let uid: String
    var email: String
    var displayName: String
    var photoURL: String
    var favorites: [Cafe] = []
    var friends: [String] = []
    
    init(uid: String, email: String, displayName: String, photoURL: String, favorites: [String], friends: [String]) {
        self.uid = uid
        self.email = email
        self.displayName = ""
        self.photoURL = ""
        self.favorites = []
        self.friends = []
    }
    
    
    
    var dictionary: [String: Any] {
        return [
            "uid": uid,
            "email": email,
            "displayName": displayName,
            "photoURL": photoURL,
            "favorites": favorites,
            "friends": friends
        ]
    }
}

extension User {
    // initialize just uid and email, leave rest empty for initial creating of User during registration
    static func empty(uid: String, email: String) -> User {
        return
            User(
                 uid: uid,
                 email: email,
                 displayName: "",
                 photoURL: "",
                 favorites: [],
                 friends: []
            )
    }
}
