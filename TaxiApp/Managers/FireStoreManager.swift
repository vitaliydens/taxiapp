//
//  FireStoreManager.swift
//  TaxiApp
//
//  Created by Ihor Vozhdai on 17.03.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

class FireStoreManager {
    private init() {}
    static let shared = FireStoreManager()

    func configure() {
        FirebaseApp.configure()
    }

    private func reference(to collectionReference: FirestoreCollectionReference) -> CollectionReference {
        return Firestore.firestore().collection(collectionReference.rawValue)
    }

    func create<T: Encodable>(for encodableObject: T, in collectionReference: FirestoreCollectionReference) {
        do {
            let json = try encodableObject.toJson()
            reference(to: .users).addDocument(data: json)
        } catch {
            print(error)
        }
    }

    func read<T: Decodable>(from collectionReference: FirestoreCollectionReference,
                            returning objectType: T.Type, completion: @escaping ([T]) -> Void) {
        reference(to: .users).addSnapshotListener { (snapshot, _) in
            guard let snapshot = snapshot else { return }
            do {
                var objects = [T]()
                for document in snapshot.documents {
                    let object = try document.decode(as: objectType.self)
                    objects.append(object)
                }
                completion(objects)
            } catch {
                print(error)
            }
        }
    }

    func update<T: Encodable & Identifiable>(for encodableObject: T, in collectionReference: FirestoreCollectionReference) {
        do {
            let json = try encodableObject.toJson(excluding: ["id"])
            guard let id = encodableObject.id else { throw TaxiAppError.encodingError }
            reference(to: .users).document(id).setData(json)
        } catch {
            print(error)
        }
    }
}
