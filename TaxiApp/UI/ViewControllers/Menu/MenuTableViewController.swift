//
//  MenuViewController.swift
//  TaxiApp
//
//  Created by Developer on 27.02.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class MenuTableViewController: UITableViewController {
    
// MARK: - IBOutlet
    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var lblUserName: UILabel!
    @IBOutlet private weak var lblUserPhone: UILabel!

// MARK: - Variables
    var users = [User]()
    var imageReference: StorageReference {
           return Storage.storage().reference().child("images")
       }

// MARK: - Tableview delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let profileVC = Storyboard.profile.instanceOf(viewController: ProfileViewController.self, identifier: "ProfileViewController")!
            self.navigationController?.pushViewController(profileVC, animated: true)
        case 2:
            let mapVC = Storyboard.map.instanceOf(viewController: MapViewController.self, identifier: "MapViewController")!
            self.navigationController?.pushViewController(mapVC, animated: true)
        default:
            print(indexPath.row)
        }
    }

// MARK: - Function
    override func viewDidLoad() {
        super.viewDidLoad()
        FireStoreManager.shared.read(from: .users, returning: User.self) { (users) in
            self.users = users
            let currentUserUid = Auth.auth().currentUser?.uid
            let currentUser = users.filter{ $0.uid == currentUserUid }
            let user = currentUser[0]
            if user.firstName == "" {
                self.lblUserName.text = "Enter your name"
            } else {
                self.lblUserName.text = user.firstName
            }
            if user.phoneNumber == "" {
                self.lblUserPhone.text = "Enter your phone number"
            } else {
                self.lblUserPhone.text = user.phoneNumber
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        downloadImage()
    }

    func downloadImage() {
        let uid = Auth.auth().currentUser?.uid
        let downloadImageRef = imageReference.child("\(String(describing: uid!)).jpg")
        downloadImageRef.getData(maxSize: 1024*1024*12) { (dataResponse, errorResponse) in
            if let data = dataResponse{
                let image = UIImage(data: data)
                self.userImageView.image = image
                self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width / 2
                self.userImageView.clipsToBounds = true
            }
        }
    }

    private func navigateToLoginStoryboard() {
           let loginVC = Storyboard.login.instanceOf(viewController: LoginViewController.self, identifier: "LoginViewController")!
           self.navigationController?.pushViewController(loginVC, animated: true)
       }
    
// MARK: - IBAction
    @IBAction func signOutButton(_ sender: UIButton) {
        let authManager = FirebaseAuthManager()
        authManager.signOut()
        dismiss(animated: true, completion: nil)
    }
}
    

