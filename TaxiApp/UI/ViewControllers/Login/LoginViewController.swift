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

    private func displayWarningLable(withText text: String) {
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
            displayWarningLable(withText: "Credentials is incorrect")
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (user, error) in
            if error != nil {
                self?.displayWarningLable(withText: "Error occurred")
                return
            }
            if user != nil {
                self?.navigateToMapStoryboard()
                return
            }
            self?.displayWarningLable(withText: "No such user")
        }
    }
    
    @IBAction func registerTapped(_ sender: UIButton) {
        self.navigateToRegistrationStoryboard()
    }

}
