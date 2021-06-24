//
//  StorageManager.swift
//  Messanger
//
//  Created by MackBookAir on 12/06/21.
//

import Foundation
import FirebaseStorage

struct StorageManager {

    static func profileImage(profileImage:UIImage,completion:@escaping ((URL?,Error?)->Void) ){
        
        let imageName = UUID().uuidString
        let storageRef = Storage.storage().reference().child(Constants.profile_images).child("\(imageName).png")
        if let uploadData = profileImage.pngData() {
            storageRef.putData(uploadData, metadata: nil,  completion: { (_, err) in
                storageRef.downloadURL(completion: completion)
                
            })
        }
    }
    
    static func uploadImageMessageToFirebase(_ image: UIImage, completion: @escaping (_ imageUrl: String) -> ()) {
        let imageName = UUID().uuidString
        let ref = Storage.storage().reference().child(Constants.message_images).child(imageName)
        if let uploadData = image.jpegData(compressionQuality: 0.2) {
            ref.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print("Failed to upload image:", error!)
                    return
                }
                ref.downloadURL(completion: { (url, err) in
                    if let err = err {
                        print(err)
                        return
                    }
                    completion(url?.absoluteString ?? "")
                })
            })
        }
    }
}
