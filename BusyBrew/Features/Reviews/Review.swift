//
//  Review.swift
//  BusyBrew
//
//  Created by Thomas Moody on 4/8/25.
//

import Foundation

//
//  User.swift
//  BusyBrew
//
//  Created by Thomas Moody on 4/8/25.
//

import Foundation
import FirebaseFirestore

struct Review: Codable, Identifiable {
    @DocumentID var id: String?
    
    var uid: String // uid of user who created review
    var date: String
    var wifi: Int
    var cleanliness: Int
    var outlets: Int
        
    init(uid: String, date: String, wifi: Int, cleanliness: Int, outlets: Int) {
        self.uid = uid
        self.date = date
        self.wifi = wifi
        self.cleanliness = cleanliness
        self.outlets = outlets
    }
}

extension Review {
    // empty cafe on creation
    static func empty(uid: String) -> Review {
        return
            Review(
                 uid: uid,
                 date: "",
                 wifi: 0,
                 cleanliness: 0,
                 outlets: 0
            )
    }
}

