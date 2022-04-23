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
    @IBOutlet weak var imageView: UIImageView!
    
    var email: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let gesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        gesture.numberOfTouchesRequired = 1
        gesture.numberOfTapsRequired = 1
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(gesture)
    }
    
    @objc func imageTapped() {
        // print("Image tapped")
        presentPhotoActionSheet()
    }
    
    @IBAction func userClickedLogout(_ sender: Any) {
        do {
            try? Auth.auth().signOut()
            self.dismiss(animated: true, completion: nil)
        } catch {
            showError()
        }
    }
    
    @IBAction func userClickedCreateProfile(_ sender: Any) {
        let appUser = MovieAppUser(firstName: firstName.text!, lastName: lastName.text!, emailAddress: email)
        DatabaseManager.shared.insertUser(with: appUser, completion: { success in
            if success {
                // upload image
                guard let image = self.imageView.image, let data = image.pngData() else {
                    return
                }
                let filename = appUser.profilePictureFileName
                StorageManager.shared.uploadProfilePicture(with: data, fileName: filename, completion: { result in
                    switch result {
                    case .success(let downloadUrl):
                        UserDefaults.standard.set(downloadUrl, forKey: "profile_picture_url")
                        print(downloadUrl)
                    case .failure(let error):
                        print("Storage manager error: \(error)")
                    }
                })
            }
        })
        
        let navViewController = self.storyboard?.instantiateViewController(withIdentifier: "mainpage") as? UINavigationController
        self.view.window?.rootViewController = navViewController
        self.view.window?.makeKeyAndVisible()
    }
    
    func showError() {
        let alert = UIAlertController(title: "Logout Error", message: "Could Not logout", preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
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
        vc.allowsEditing = true // user can crop and edit photos the have picked
        present(vc, animated: true)
    }
    
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true // user can crop and edit photos the have picked
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
