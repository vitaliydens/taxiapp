//
//  ProfileViewController.swift
//  TaxiApp
//
//  Created by Ihor Vozhdai on 12.03.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class ProfileViewController: UITableViewController {

    // MARK: - Outlets
    @IBOutlet private weak var saveButton: UIBarButtonItem!
    @IBOutlet private weak var userImage: UIImageView!
    @IBOutlet private weak var userFirstName: UITextField!
    @IBOutlet private weak var userSecondName: UITextField!
    @IBOutlet private weak var userPhoneNumber: UITextField!
    @IBOutlet private weak var userBirthDay: UITextField!
    @IBOutlet private weak var userEmail: UITextField!

    // MARK: - Variables
    var users = [User]()
    private var datePicker: UIDatePicker?
    var imageReference: StorageReference {
        return Storage.storage().reference().child("images")
    }
    private var imageIsChanged: Bool = false

    // MARK: - Functions
    private func reference(to collectionReference: FirestoreCollectionReference) -> CollectionReference {
        return Firestore.firestore().collection(collectionReference.rawValue)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        FireStoreManager.shared.read(from: .users, returning: User.self) { (users) in
            self.users = users
            let currentUserEmail = Auth.auth().currentUser?.email
            let currentUser = users.filter{ $0.email == currentUserEmail }
            let user = currentUser[0]
            self.userFirstName.text = user.firstName
            self.userSecondName.text = user.secondName
            self.userPhoneNumber.text = user.phoneNumber
            self.userBirthDay.text = user.birthDay
            self.userEmail.text = user.email
        }
        downloadImage()
        saveButton.isEnabled = false
        userFirstName.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        userSecondName.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        userPhoneNumber.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        userBirthDay.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        userEmail.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)

        createDatePicker()
        createToolbar()
    }

    func createDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        userBirthDay.inputView = datePicker
        datePicker.addTarget(self, action: #selector(ProfileViewController.dateChanged(datePicker:)), for: .valueChanged)
        let calendar = Calendar(identifier: .gregorian)
        let currentDate = Date()
        var components = DateComponents()
        components.calendar = calendar
        components.year = -18
        let maxDate = calendar.date(byAdding: components, to: currentDate)!
        datePicker.maximumDate = maxDate
    }

    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        userBirthDay.text = dateFormatter.string(from: datePicker.date)
    }

    func createToolbar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(ProfileViewController.dismissKeyboard))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        userBirthDay.inputAccessoryView = toolBar
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: - Table view delegate
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

    func updateUser(user: User, completion: @escaping (User) -> Void) {
        let currentUserEmail = Auth.auth().currentUser?.email
        let currentUser = users.filter{ $0.email == currentUserEmail }
        var updateUser = currentUser[0]
        updateUser.firstName = userFirstName.text
        updateUser.secondName = userSecondName.text
        updateUser.phoneNumber = userPhoneNumber.text
        updateUser.birthDay = userBirthDay.text
        updateUser.email = userEmail.text!
        completion(updateUser)
    }

    func uploadImage() {
        guard let image = userImage.image else { return }
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }

        let uid = Auth.auth().currentUser?.uid
        let uploadImageRef = imageReference.child("\(String(describing: uid!)).jpg")

        let uploadTask = uploadImageRef.putData(imageData, metadata: nil) { (metadata, error) in
            print("Upload task complete!")
        }
        uploadTask.resume()
    }

    func downloadImage() {
        let uid = Auth.auth().currentUser?.uid
        let downloadImageRef = imageReference.child("\(String(describing: uid!)).jpg")
        downloadImageRef.getData(maxSize: 1024*1024*12) { (dataResponse, errorResponse) in
            if let data = dataResponse{
                let image = UIImage(data: data)
                self.userImage.image = image
            }
            print(errorResponse ?? "No error")
        }
    }
    
    // MARK: - IBActions
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        updateUser(user: users[0]) { updateUser in
            FireStoreManager.shared.update(for: updateUser, in: .users)
        }
        let alert = UIAlertController(title: "Info", message: "Your data was saved.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - Work with image
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
        uploadImage()
        imageIsChanged = true
        dismiss(animated: true)
    }
}
