//
//  Message.swift
//  Messanger
//
//  Created by MackBookAir on 13/06/21.
//

import UIKit
import Firebase

class Message: NSObject {
    var fromId: String?
    var text: String?
    var timestamp: NSNumber?
    var toId: String?
    var user: User?
    var imageUrl: String?
    var imageWidth: NSNumber?
    var imageHeight: NSNumber?
    
    init(dictionary: [String: Any]) {
        self.fromId = dictionary[Constants.fromId] as? String
        self.text = dictionary[Constants.text] as? String
        self.timestamp = dictionary[Constants.timestamp] as? NSNumber
        self.toId = dictionary[Constants.toId] as? String
        self.imageUrl = dictionary[Constants.imageUrl] as? String
        self.imageWidth = dictionary[Constants.imageWidth] as? NSNumber
        self.imageHeight = dictionary[Constants.imageHeight] as? NSNumber
    }
    func chatPartnerId() -> String? {
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
    }
}
