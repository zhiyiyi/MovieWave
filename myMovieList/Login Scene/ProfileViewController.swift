//
//  ProfileViewController.swift
//  myMovieList
//
//  Created by Zhiyi Chen on 4/17/22.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    var currentUID: String = ""
    //let currentUID = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(gesture)
        
        print(currentUID)
        StorageManager.shared.downloadProfilePicture(with: currentUID) { image in
            self.imageView.image = image
        }
    }
    
    @objc func imageTapped() {
        presentPhotoActionSheet()
    }
    
    @IBAction func userClickedLogout(_ sender: Any) {
        do {
            try? Auth.auth().signOut()
            // _ = navigationController?.popToRootViewController(animated: true)
            let navViewController = self.storyboard?.instantiateViewController(withIdentifier: "loginpage") as? UINavigationController
            self.view.window?.rootViewController = navViewController
            self.view.window?.makeKeyAndVisible()
        }
    }
    
    @IBAction func userClickedCreateProfile(_ sender: Any) {
        if firstName.text != nil && lastName.text != nil && currentUID != "" {
            let movieAppUser = User(firstname: firstName.text!, lastname: lastName.text!, username: userName.text!, userID: currentUID)
            DatabaseManager.shared.insertUser(with: movieAppUser) { success in
                if success { // upload image
                    guard let image = self.imageView.image else {
                        return
                    }
                    StorageManager.shared.uploadProfilePicture(with: image, userID: self.currentUID) { success in
                        if success {
                            let navViewController = self.storyboard?.instantiateViewController(withIdentifier: "mainpage") as? UINavigationController
                            self.view.window?.rootViewController = navViewController
                            self.view.window?.makeKeyAndVisible()
                        }
                    }
                }
                else {
                    print("Failed to upload profile photo")
                }
            }
        }
        else {
            let alert = UIAlertController(title: "Missing Information", message: "Please fill in all the information needed", preferredStyle: .alert)
            let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Profile Picture", message: "How would you like to select a picture", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler:{[weak self] _ in
            self?.presentCamera()}))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: {[weak self] _ in
            self?.presentPhotoPicker()}))
        present(actionSheet, animated: true)
    }
    
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self // need to add UINavigationControllerDelegate
        vc.allowsEditing = true // user can crop and edit photos they have picked
        present(vc, animated: true)
    }
    
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        self.imageView.image = selectedImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
