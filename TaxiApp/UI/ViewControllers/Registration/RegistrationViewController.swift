//
//  RegistrationViewController.swift
//  TaxiApp
//
//  Created by Ihor Vozhdai on 02.03.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import UIKit
import Firebase

class RegistrationViewController: UIViewController {

    // MARK: IBOutlets
    @IBOutlet private weak var warningLabel: UILabel!
    @IBOutlet private weak var emailOrPhoneTextField: UITextField!
    @IBOutlet private weak var passTextField: UITextField!
    @IBOutlet private weak var confirmPassTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        warningLabel.alpha = 0
    }

    // animation for error message
    private func showWarningLabel(withText text: String) {
        warningLabel.text = text
        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1,
                       options: .curveEaseOut, animations: { [weak self] in self?.warningLabel.alpha = 1
            })
        { [weak self] complete in self?.warningLabel.alpha = 0
        }
    }

    private func navigateToLoginScreen() {
        let loginVC = Storyboard.login.instanceOf(viewController: LoginViewController.self, identifier: "LoginViewController")!
        self.navigationController?.pushViewController(loginVC, animated: true)
    }

    // MARK: IBActions
    @IBAction func registrationButtonTapped(_ sender: UIButton) {
        guard let email = emailOrPhoneTextField.text, let password = passTextField.text, let confirmPassword = confirmPassTextField.text, email != "", password != "", confirmPassword != "" else {
            showWarningLabel(withText: "All fields is required")
            return
        }
        if password == confirmPassword {
            let signUpManager = FirebaseAuthManager()
            signUpManager.createUser(email: email, password: password) { [weak self] (success) in
                self?.navigateToLoginScreen()
            }
        } else {
            showWarningLabel(withText: "Passwords is not the same!")
        }
    }
}

