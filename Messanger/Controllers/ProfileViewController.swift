//
//  ProfileViewController.swift
//  Messanger
//
//  Created by MackBookAir on 12/06/21.
//

import UIKit
import SDWebImage

final class ProfileViewController: UIViewController {
    
    var user: User?
    
    var imageUrl = ""

    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var accountButton: UIButton!
    @IBOutlet weak var notificationButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        //downloadImage()
        innerView.layer.masksToBounds = true
        innerView.layer.cornerRadius = 40
        
        outerView.layer.masksToBounds = true
        outerView.layer.cornerRadius = 40

        
        accountButton.layer.masksToBounds = true
        accountButton.layer.cornerRadius = 12
        
        notificationButton.layer.masksToBounds = true
        notificationButton.layer.cornerRadius = 12
        
        settingButton.layer.masksToBounds = true
        settingButton.layer.cornerRadius = 12
        
        logOutButton.layer.masksToBounds = true
        logOutButton.layer.cornerRadius = 12
        
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 3
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 70
        
        nameLabel.text = UserDefaults.standard.value(forKey: Constants.name) as? String
        emailLabel.text = UserDefaults.standard.value(forKey: Constants.email) as? String
        
        imageUrl = UserDefaults.standard.value(forKey: Constants.profileImageUrl) as! String
        downloadImage()
    }
    
    @IBAction func logOutButtonTapped(){
        let actionSheet = UIAlertController(title: "",
                                            message: "",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Log Out",
                                            style: .destructive,
                                            handler: { _ in
                                                UserDefaults.standard.setValue(nil, forKey: Constants.email)
                                                UserDefaults.standard.setValue(nil, forKey: Constants.name)
                                                AuthenticationManager.userLogout()
                                                let storyboard = UIStoryboard(name: Constants.Main, bundle: nil)
                                                let LoginVC = storyboard.instantiateViewController(identifier: Constants.LoginNavigationVC)
                                                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(LoginVC)
                                            }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
        self.present(actionSheet, animated: true)
    }
    
    func downloadImage(){
        guard let url = URL(string: (imageUrl)) else {return}
        imageView.sd_setImage(with: url)
    }
}
