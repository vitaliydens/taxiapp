//
//  FirebaseAuthManager.swift
//  TaxiApp
//
//  Created by Ihor Vozhdai on 02.03.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import UIKit
import Firebase

class FirebaseAuthManager {

    func createUser(email: String, password: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if (authResult?.user) != nil {
                completionBlock(true)
            } else {
                completionBlock(false)
            }
        }
    }

    func signIn(email: String, pass: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: pass) { (result, error) in
            if let error = error, let _ = AuthErrorCode(rawValue: error._code) {
                completionBlock(false)
            } else {
                completionBlock(true)
            }
        }
    }

    func signOut() {
        do {
            try? Auth.auth().signOut()
        }
    }

    func resetPassword(email: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if error != nil {
                completionBlock(true)
            } else {
                completionBlock(false)
            }
        }
    }
}
