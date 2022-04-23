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
        // let tappedImage = tapGestureRecognizer.view as! UIImageView
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
        DatabaseManager.shared.insertUser(with: MovieAppUser(firstName: firstName.text!, lastName: lastName.text!, emailAddress: email))
        let tableViewController = self.storyboard?.instantiateViewController(withIdentifier: "tableview") as? TableViewController

        self.view.window?.rootViewController = tableViewController
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
