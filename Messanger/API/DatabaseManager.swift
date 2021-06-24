//
//  DatabaseManager.swift
//  Messanger
//
//  Created by MackBookAir on 12/06/21.
//

import Foundation
import Firebase

struct DatabaseManager {
    static func userInserts(_ uid: String, values: [String: AnyObject]) {
        let ref = Database.database().reference()
        let usersReference = ref.child(Constants.users).child(uid)
        
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if let err = err {
                print(err.localizedDescription)
                
                return
            }
        })
    }
    
    static func getAllUsers(Completion: @escaping ([User]) -> Void){
        var users = [User]()
        Database.database().reference().child(Constants.users).observe(.childAdded, with : {
            (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let user = User(dictionary: dictionary)
                user.id = snapshot.key
                if user.id != Auth.auth().currentUser?.uid {
                    users.append(user)
                }
                Completion(users)
            }
        })
    }
    
    static func sendImage(_ imageUrl: String,image: UIImage, id:String,completion: @escaping ((Error?, DatabaseReference) -> Void)){
        let ref = Database.database().reference().child(Constants.messages)
        let childRef = ref.childByAutoId()
        let toId = id
        let fromId = Auth.auth().currentUser!.uid
        let timestamp = Int(Date().timeIntervalSince1970)
        
        let values = [Constants.imageUrl: imageUrl, Constants.toId: toId, Constants.fromId: fromId, Constants.timestamp: timestamp,Constants.imageWidth: image.size.width as AnyObject, Constants.imageHeight: image.size.height ] as [String : Any]
        childRef.updateChildValues(values,withCompletionBlock: completion )
    }
    
    static func senderReciptanatMessage( messageId:String, toId: String) {
        let fromId = Auth.auth().currentUser!.uid
        let userMessagesRef = Database.database().reference().child(Constants.userMessages).child(fromId).child(toId).child(messageId)
        userMessagesRef.setValue(1)
        
        let recipientUserMessagesRef = Database.database().reference().child(Constants.userMessages).child(toId).child(fromId).child(messageId)
        recipientUserMessagesRef.setValue(1)
    }
}
