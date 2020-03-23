//
//  MenuViewController.swift
//  TaxiApp
//
//  Created by Developer on 27.02.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import UIKit
import Firebase

class MenuTableViewController: UITableViewController {
    
// MARK: - IBOutlet
    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var lblUserName: UILabel!
    @IBOutlet private weak var lblUserPhone: UILabel!

// MARK: - Variables
    var users = [User]()

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
    private func navigateToLoginStoryboard() {
           let loginVC = Storyboard.login.instanceOf(viewController: LoginViewController.self, identifier: "LoginViewController")!
           self.navigationController?.pushViewController(loginVC, animated: true)
       }

    override func viewDidLoad() {
        super.viewDidLoad()
        FireStoreManager.shared.read(from: .users, returning: User.self) { (users) in
            self.users = users
            let currentUserEmail = Auth.auth().currentUser?.email
            let currentUser = users.filter{ $0.email == currentUserEmail }
            let user = currentUser[0]
            self.lblUserName.text = user.firstName
            self.lblUserPhone.text = user.phoneNumber
        }
    }
    
// MARK: - IBAction
    @IBAction func signOutButton(_ sender: UIButton) {
        let authManager = FirebaseAuthManager()
        authManager.signOut()
    }
}
    

