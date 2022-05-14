//
//  LoginViewController.swift
//  myMovieList
//
//  Created by Zhiyi Chen on 4/17/22.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userEmailIdTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userPasswordTextField.isSecureTextEntry = true
    }
    
    @IBAction func userClickedLogin(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: userEmailIdTextField.text!, password: userPasswordTextField.text!) {
            result, error in
            if let loggedInUserError = error {
                self.showError(userError: loggedInUserError as NSError)
            } else {
                let tarBarViewController = self.storyboard?.instantiateViewController(withIdentifier: "mainTarBar") as? UITabBarController
                self.view.window?.rootViewController = tarBarViewController
                self.view.window?.makeKeyAndVisible()
            }
        }
    }
    
    func showError(userError: NSError) {
        let alert = UIAlertController(title: "Login Error", message: userError.localizedDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }

}
