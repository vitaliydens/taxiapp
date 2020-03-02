//
//  LoginViewController.swift
//  TaxiApp
//
//  Created by Ihor Vozhdai on 02.03.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    // MARK: IBOtlets
    @IBOutlet private weak var warningLabel: UILabel!
    @IBOutlet private weak var emailOrPhoneTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        warningLabel.alpha = 0
    }

    // MARK: Functions

    // hide navigation bar for login view
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    // hide keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    private func navigateToMapStoryboard() {
        let mapVC = Storyboard.map.instanceOf(viewController: MapViewController.self, identifier: "MapViewController")!
        self.navigationController?.pushViewController(mapVC, animated: true)
    }
    
    private func navigateToRegistrationStoryboard() {
        let registrationVC = Storyboard.registration.instanceOf(viewController: RegistrationViewController.self, identifier: "RegistrationViewController")!
        self.navigationController?.pushViewController(registrationVC, animated: true)
    }

    // animation for error message
    private func displayWarningLabel(withText text: String) {
        warningLabel.text = text
        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1,
                       options: .curveEaseOut, animations: { [weak self] in self?.warningLabel.alpha = 1
            })
        { [weak self] complete in self?.warningLabel.alpha = 0
        }
    }

    // MARK: IBActions
    @IBAction func loginTapped(_ sender: UIButton) {
        guard let email = emailOrPhoneTextField.text, let password = passwordTextField.text, email != "", password != "" else {
            displayWarningLabel(withText: "Credentials is incorrect")
            return
        }
        let loginManager = FirebaseAuthManager()
        loginManager.signIn(email: email, pass: password) { [weak self] (success) in
        if (success) {
            self?.navigateToMapStoryboard()
        } else {
            self?.displayWarningLabel(withText: "User not found.")
            }
        }
    }
    
    @IBAction func registerTapped(_ sender: UIButton) {
        self.navigateToRegistrationStoryboard()
    }
}
