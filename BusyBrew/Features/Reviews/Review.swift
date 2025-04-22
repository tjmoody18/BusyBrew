//
//  Review.swift
//  BusyBrew
//
//  Created by Thomas Moody on 4/8/25.
//

import Foundation
import FirebaseFirestore

struct Review: Codable, Identifiable {
    @DocumentID var id: String?
    
    var uid: String // uid of user who created review
    var displayName: String
    var date: String
    var text: String
    var wifi: Int
    var cleanliness: Int
    var outlets: Int
    var photos: [String]
        
    init(uid: String, displayName: String, date: String, text: String, wifi: Int, cleanliness: Int, outlets: Int, photos: [String]) {
        self.uid = uid
        self.displayName = displayName
        self.date = date
        self.text = text
        self.wifi = wifi
        self.cleanliness = cleanliness
        self.outlets = outlets
        self.photos = photos
    }
    
    var dictionary: [String: Any] {
        return [
            "uid": uid,
            "displayName": displayName,
            "date": date,
            "text": text,
            "wifi": wifi,
            "cleanliness": cleanliness,
            "outlets": outlets,
            "photos" : photos
        ]
    }
}
