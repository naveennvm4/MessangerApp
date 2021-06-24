//
//  User.swift
//  Messanger
//
//  Created by MackBookAir on 12/06/21.
//

import Foundation

class User: NSObject {
    var id: String?
    var name: String?
    var email: String?
    var profileImageUrl: String?
    init(dictionary: [String: AnyObject]) {
        self.id = dictionary[Constants.id] as? String
        self.email = dictionary[Constants.email] as? String
        self.name = dictionary[Constants.name] as? String
        self.profileImageUrl = dictionary[Constants.profileImageUrl] as? String
    }
}
