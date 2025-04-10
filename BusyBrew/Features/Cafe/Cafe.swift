//
//  Cafe.swift
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

struct Cafe: Codable, Identifiable {
    @DocumentID var id: String?
    
    var uid: String // uid will store name-lat-lon
    var name: String
    var reviews: [Review]
    var status: String
    var image: String
        
    init(uid: String, name: String, reviews: [Review], status: String, image: String) {
        self.uid = uid
        self.name = name
        self.reviews = reviews
        self.status = status
        self.image = image
    }
    
    var dictionary: [String: Any] {
        return [
            "uid": uid,
            "name": name,
            "reviews": reviews,
            "status": status,
            "image": image
        ]
    }
}


extension Cafe {
    // empty cafe on creation
    static func empty(uid: String, name: String) -> Cafe {
        return
            Cafe(
                 uid: uid,
                 name: name,
                 reviews: [],
                 status: "No Status Reported",
                 image: "cafe.png"
            )
    }
}
