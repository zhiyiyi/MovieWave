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

        // Do any additional setup after loading the view.
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
//                let vc = TableViewController()
//                let nav = UINavigationController(rootViewController: vc)
//                nav.modalPresentationStyle = .fullScreen
//                self.present(nav, animated: true)
                let tableViewController = self.storyboard?.instantiateViewController(withIdentifier: "tableview") as? TableViewController

                self.view.window?.rootViewController = tableViewController
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
