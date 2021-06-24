//
//  ConversationViewController.swift
//  Messanger
//
//  Created by MackBookAir on 12/06/21.
//

import UIKit
import Firebase

class ConversationController: UITableViewController {
    
    var messages = [Message]()
    
    var timer: Timer?
    
    var messageDictionary = [String: Message]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add",
                                                            style: .plain,
                                                            target: self,
                                                            action: nil)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose,
                                                            target: self,
                                                            action: #selector(didTappedComposeButton))
        
        tableView.register(ConversationCell.self, forCellReuseIdentifier: Constants.reuseIdentifier)
        messages.removeAll()
        messageDictionary.removeAll()
        tableView.reloadData()
        tableView.allowsMultipleSelectionDuringEditing = true
        observeUserMessages()
    }
    @objc func didTappedComposeButton(){
        let newConversationVC = NewMessageController()
        newConversationVC.conversationVC = self
        let navVC = UINavigationController(rootViewController: newConversationVC)
        modalPresentationStyle = .fullScreen
        present(navVC, animated: true, completion: nil)
    }
    
    func showChatVCForUser(user: User) {
        let chatVC = ChatController(collectionViewLayout: UICollectionViewFlowLayout())
        chatVC.user = user
        modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(chatVC, animated: true)
    }
    
    func observeUserMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let ref = Database.database().reference().child(Constants.userMessages).child(uid)
        ref.observe(.childAdded) { (snapshot) in
            let userId = snapshot.key
            Database.database().reference().child(Constants.userMessages).child(uid).child(userId).observe(.childAdded) { (snapshot) in
                let messageId = snapshot.key
                self.fetchMessageWithMessageId(messageId: messageId)
            }
        }
        ref.observe(.childRemoved) { (snapshot) in
            self.messageDictionary.removeValue(forKey: snapshot.key)
            self.attemptReloadTable()
        }
    }
    
    private func fetchMessageWithMessageId(messageId: String) {
        let messageReference = Database.database().reference().child(Constants.messages).child(messageId)
        messageReference.observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let message = Message(dictionary: dictionary)
                if let chatPartnerId = message.chatPartnerId() {
                    self.messageDictionary[chatPartnerId] = message
                }
                self.attemptReloadTable()
                
            }
        }
    }
    
    private func attemptReloadTable() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.reloadTable), userInfo: nil, repeats: false)
    }
    
    @objc func reloadTable() {
        self.messages = Array(self.messageDictionary.values)
        self.messages.sort(by: { (message1, message2) -> Bool in
            return message1.timestamp!.intValue > message2.timestamp!.intValue
        })
        DispatchQueue.main.async(execute: {
            print("reload")
            self.tableView.reloadData()
        })
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let message = self.messages[indexPath.row]
        if let chatPartnerId = message.chatPartnerId() {
            Database.database().reference().child(Constants.userMessages).child(uid).child(chatPartnerId).removeValue { (error, ref) in
                if error != nil {
                    print("failed to delete message:\(error!)")
                    return
                }
                self.messageDictionary.removeValue(forKey: chatPartnerId)
                self.attemptReloadTable()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.reuseIdentifier, for: indexPath) as! ConversationCell
        let message = messages[indexPath.row]
        cell.conversation = message
        if cell.messageLabel.text == nil {
            cell.messageLabel.text = "Media"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        guard let chatPartnerId = message.chatPartnerId() else {
            return
        }
        let ref = Database.database().reference().child(Constants.users).child(chatPartnerId)
        ref.observe(.value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            let user = User(dictionary: dictionary)
            user.id = chatPartnerId
            self.showChatVCForUser(user: user)
        }
    }
}
