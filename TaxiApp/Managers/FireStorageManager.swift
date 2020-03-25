//
//  FireStorageManager.swift
//  TaxiApp
//
//  Created by Ihor Vozhdai on 25.03.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

class StorageManager {

    func uploadImage(_ image: UIImage, completion: @escaping ((_ url: String?) -> ())) {

        guard let uid = Auth.auth().currentUser?.uid else { return }

        // Data in memory
        let data = Data()

        // Create a reference to the file you want to upload
       let storageRef = Storage.storage().reference().child("user \(uid)")

        // Upload the file to the path "images/rivers.jpg"
        let uploadTask = storageRef.putData(data, metadata: nil) { (metadata, error) in
          guard let metadata = metadata else {
            // Uh-oh, an error occurred!
            return
          }
          // Metadata contains file metadata such as size, content-type.
          let size = metadata.size
          // You can also access to download URL after upload.
            storageRef.downloadURL { (url, error) in
            guard let downloadURL = url else {
              // Uh-oh, an error occurred!
              return
            }
          }
        }
    }

    func downloadImage() {

        guard let uid = Auth.auth().currentUser?.uid else { return }
        let storageRef = Storage.storage().reference().child("user \(uid)")
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        storageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
          if let error = error {
            // Uh-oh, an error occurred!
          } else {
            // Data for "images/island.jpg" is returned
            let image = UIImage(data: data!)
          }
        }
    }
}
