//
//  ProfileViewController.swift
//  TaxiApp
//
//  Created by Ihor Vozhdai on 12.03.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UITableViewController {

    // MARK: Outlets
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userFirstName: UITextField!
    @IBOutlet weak var userSecondName: UITextField!
    @IBOutlet weak var userPhoneNumber: UITextField!
    @IBOutlet weak var userBirthDay: UITextField!
    @IBOutlet weak var userEmail: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        saveButton.isEnabled = false

        userFirstName.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        userSecondName.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        userPhoneNumber.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        userBirthDay.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    }
    
    // MARK: Table view delegate
       override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           if indexPath.row == 0 {

               let cameraIcon = #imageLiteral(resourceName: "camera")
               let photoIcon = #imageLiteral(resourceName: "photo-1")

               let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

               let camera = UIAlertAction(title: "Camera", style: .default) { _ in
                   self.chooseImagePicker(source: .camera)
               }
               camera.setValue(cameraIcon, forKey: "image")
               camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")

               let photo = UIAlertAction(title: "Photo", style: .default) { _ in
                   self.chooseImagePicker(source: .photoLibrary)
               }
               photo.setValue(photoIcon, forKey: "image")
               photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")

               let cancel = UIAlertAction(title: "Cancel", style: .cancel)

               actionSheet.addAction(camera)
               actionSheet.addAction(photo)
               actionSheet.addAction(cancel)

               present(actionSheet, animated: true)
           } else {
               view.endEditing(true)
           }
       }

    @objc private func textFieldChanged() {
           if (userFirstName.text?.isEmpty == false
            || userSecondName.text?.isEmpty == false
            || userPhoneNumber.text?.isEmpty == false
            || userBirthDay.text?.isEmpty == false
            || userEmail.text?.isEmpty == false ) {
               saveButton.isEnabled = true
           } else {
               saveButton.isEnabled = false
           }
       }

    func saveData() {
        let db = Firestore.firestore()
        db.collection("users").addDocument(data: [
            "firstName": userFirstName.text!,
            "secondName": userSecondName.text!,
            "phoneNumber": userPhoneNumber.text!,
            "dateOfBirth": userBirthDay.text!,
            "email": userEmail.text!
        ]) { err in
            if let err = err {
                print("Error adding document: \(err.localizedDescription)")
            } else {
                print("Document added")
            }
        }

    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        saveData()
        let alert = UIAlertController(title: "Info", message: "Your data was saved.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: Work with image
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        userImage.image = info[.editedImage] as? UIImage
        userImage.contentMode = .scaleAspectFill
        userImage.clipsToBounds = true
        dismiss(animated: true)
    }
}
