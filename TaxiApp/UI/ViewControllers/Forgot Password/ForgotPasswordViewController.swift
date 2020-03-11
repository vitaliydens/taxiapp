//
//  ForgotPasswordViewController.swift
//  TaxiApp
//
//  Created by Ihor Vozhdai on 03.03.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import UIKit
import Firebase

class ForgotPasswordViewController: UIViewController {

    // MARK: IBOutlets
    @IBOutlet private weak var warningLabel: UILabel!
    @IBOutlet private weak var emailTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        warningLabel.alpha = 0

    }

    // Functions
    private func navigateToLoginStoryboard() {
        let loginVC = Storyboard.login.instanceOf(viewController: LoginViewController.self, identifier: "LoginViewController")!
        self.navigationController?.pushViewController(loginVC, animated: true)
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

    // MARK: IBActions
    @IBAction func resetPasswordButton(_ sender: UIButton) {
        guard let email = emailTextField.text, email != "" else { return }

        let authManager = FirebaseAuthManager()
        authManager.resetPassword(email: email) { (success) in
            if success {
                self.showWarningLabel(withText: "Email incorrect")
            } else {
                self.showWarningLabel(withText: "Email for reset password was sent to your email")
            }
        }
    }
}
