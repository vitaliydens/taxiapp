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
        Auth.auth().createUser(withEmail: email, password: password) {(authResult, error) in
            if let user = authResult?.user {
                print(user)
                completionBlock(true)
            } else {
                completionBlock(false)
            }
        }

        let db = Firestore.firestore()
             db.collection("users").addDocument(data: [
                 "email": email,
             ]) { err in
                 if let err = err {
                     print("Error adding document: \(err.localizedDescription)")
                 } else {
                     print("Document added")
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
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
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
