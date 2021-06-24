//
//  ChatInputContainerView.swift
//  Messanger
//
//  Created by MackBookAir on 16/06/21.
//

import Foundation
import UIKit

class ChatInputContainerView: UIView, UITextFieldDelegate{

    var chatController: ChatController? {
        didSet {
            sendButton.addTarget(chatController, action: #selector(ChatController.sendButtonTapped), for: .touchUpInside)
            uploadImageView.addGestureRecognizer(UITapGestureRecognizer(target: chatController, action: #selector(ChatController.uploadButtonTapped)))
        }
    }
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Message..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()
    
    let sendButton: UIButton = {
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        return sendButton
    }()
    
    let uploadImageView: UIImageView = {
        let uploadImageView = UIImageView()
        uploadImageView.translatesAutoresizingMaskIntoConstraints = false
        uploadImageView.image = UIImage(systemName: "paperclip")
        uploadImageView.isUserInteractionEnabled = true
        return uploadImageView
    }()
    
    let separaterView : UIView = {
        let separaterView = UIView()
        separaterView.backgroundColor = .lightGray
        separaterView.translatesAutoresizingMaskIntoConstraints = false
        return separaterView
    }()
    
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white

        addSubview(uploadImageView)
        uploadImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        uploadImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        uploadImageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        uploadImageView.heightAnchor.constraint(equalToConstant: 33).isActive = true
        
        addSubview(sendButton)
        //constraints
        sendButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: heightAnchor).isActive = true


        addSubview(self.inputTextField)
        //constraints
        self.inputTextField.leftAnchor.constraint(equalTo: uploadImageView.rightAnchor, constant: 8).isActive = true
        self.inputTextField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        self.inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        self.inputTextField.heightAnchor.constraint(equalTo: heightAnchor).isActive = true

        addSubview(separaterView)
        //constraints
        separaterView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        separaterView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        separaterView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        separaterView.heightAnchor.constraint(equalToConstant: 1).isActive = true

    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        chatController?.sendButtonTapped()
        return true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
