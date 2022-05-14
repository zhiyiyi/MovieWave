//
//  RegisterViewController.swift
//  myMovieList
//
//  Created by Zhiyi Chen on 4/17/22.
//

import UIKit
import Firebase
import CloudKit

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    let db = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userPasswordTextField.isSecureTextEntry = true
    }

    @IBAction func userClickedCreatAccount(_ sender: Any) {
        Auth.auth().createUser(withEmail: userEmailTextField.text!, password: userPasswordTextField.text!) {
            result, error in
            if let createUserError = error {
                self.showError(userError: createUserError as NSError)
                // & don't perform segue
            } else {
                let userID = Auth.auth().currentUser?.uid
                print(userID)
//                self.db.child("users").child(userID!).setValue(["userID": userID])
//                StorageManager.shared.uploadProfilePicture(with: UIImage(named: "profile")!, userID: userID!) { success in
//                    if success {
//                        DispatchQueue.main.async {
//                            _ = self.navigationController?.popViewController(animated: true)
//                        }
//                    }
//                }
                self.performSegue(withIdentifier: "createToProfile", sender: self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createToProfile" {
            let profileViewController = segue.destination as! ProfileViewController
            profileViewController.currentUID = Auth.auth().currentUser!.uid
        }
    }
    
    func showError(userError: NSError) {
        let alert = UIAlertController(title: "Create Account Error", message: userError.localizedDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
