//
//  UserModel.swift
//  TaxiApp
//
//  Created by Ihor Vozhdai on 17.03.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import Foundation

protocol Identifiable {
    var id: String? { get set }
}

struct User: Codable, Identifiable {
    var id: String? = nil
    var firstName: String?
    var secondName: String?
    var phoneNumber: String?
    var birthDay: String?
    var email: String
    var uid: String?

    init(firstName: String, secondName: String, phoneNumber: String, birthDay: String, email: String, uid: String) {
        self.firstName = firstName
        self.secondName = secondName
        self.phoneNumber = phoneNumber
        self.birthDay = birthDay
        self.email = email
        self.uid = uid
    }
}
