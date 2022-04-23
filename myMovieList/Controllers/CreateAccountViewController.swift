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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
            } else {
                if let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "Profile") as? ProfileViewController
                {
                    profileViewController.email = self.userEmailTextField.text!
                    self.present(profileViewController, animated: true, completion: nil)
                }
            }
        }
    }
    
    func showError(userError: NSError) {
        let alert = UIAlertController(title: "Create Account Error", message: userError.localizedDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
