//
//  ConversationCell.swift
//  Messanger
//
//  Created by MackBookAir on 14/06/21.
//

import Foundation
import UIKit
import Firebase

class ConversationCell: UITableViewCell{
    
    var messages = [Message]()
    
    var conversation: Message? {
        didSet { downloadImage()}
    }
    
    let profileImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .link
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .darkGray
        return label
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()


    var messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .gray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        profileImageView.layer.cornerRadius = 35
        
        let stack = UIStackView(arrangedSubviews: [nameLabel, messageLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 2
        addSubview(stack)
        stack.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        stack.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 5).isActive = true
        
        addSubview(timeLabel)
        timeLabel.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: nameLabel.heightAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func downloadImage(){
        guard let conversation = conversation else {return}
        messageLabel.text = conversation.text
        if let seconds = conversation.timestamp?.doubleValue {
            let timestampDate = Date(timeIntervalSince1970: seconds)
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "hh:mm a"
            timeLabel.text = dateFormater.string(from: timestampDate)
        }
        if let id = conversation.chatPartnerId() {
            let ref = Database.database().reference().child(Constants.users).child(id)
            ref.observe(.value) { (snapshot) in
                if let dictionary = snapshot.value as? [String: Any] {
                    self.nameLabel.text = dictionary[Constants.name] as? String
                    if let profileImageUrl = dictionary[Constants.profileImageUrl] as? String {
                        self.profileImageView.sd_setImage(with: URL(string:profileImageUrl))
                    }
                }
            }
        }
    }
}
