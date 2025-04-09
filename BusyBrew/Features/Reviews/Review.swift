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
    var text: String
    var wifi: Int
    var cleanliness: Int
    var outlets: Int
    var photos: [String]
        
    init(uid: String, date: String, text: String, wifi: Int, cleanliness: Int, outlets: Int, photos: [String]) {
        self.uid = uid
        self.date = date
        self.text = text
        self.wifi = wifi
        self.cleanliness = cleanliness
        self.outlets = outlets
        self.photos = photos
    }
}

extension Review {
    // empty cafe on creation
    static func empty(uid: String) -> Review {
        return
            Review(
                 uid: uid,
                 date: "",
                 text: "",
                 wifi: 0,
                 cleanliness: 0,
                 outlets: 0,
                 photos: []
            )
    }
}

