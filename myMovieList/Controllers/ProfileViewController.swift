//
//  ProfileViewController.swift
//  myMovieList
//
//  Created by Zhiyi Chen on 4/17/22.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func userClickedLogout(_ sender: Any) {
        do {
            try? Auth.auth().signOut()
            self.dismiss(animated: true, completion: nil)
        } catch {
            showError()
        }
    }
    
    func showError() {
        let alert = UIAlertController(title: "Logout Error", message: "Could Not logout", preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
