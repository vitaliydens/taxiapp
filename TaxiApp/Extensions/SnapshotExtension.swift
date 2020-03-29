//
//  SnapshotExtension.swift
//  TaxiApp
//
//  Created by Ihor Vozhdai on 17.03.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Firebase

extension DocumentSnapshot {

    func decode<T: Decodable>(as objectType: T.Type, includingId: Bool = true) throws -> T {

        var documentJson = data()
        if includingId {
            documentJson!["id"] = documentID
        }

        let documentData = try JSONSerialization.data(withJSONObject: documentJson!, options: [])
        let decodedObject = try JSONDecoder().decode(objectType, from: documentData)
        return decodedObject
    }
}
