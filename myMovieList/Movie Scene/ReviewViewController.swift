//
//  ReviewViewController.swift
//  myMovieList
//
//  Created by Zhiyi Chen on 5/13/22.
//

import UIKit
import Firebase
import FirebaseDatabase

class ReviewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

//    struct ReviewSimple {
//        var username: String
//        var reviewText: String
//        var likes: Int
//        var dislikes: Int
//    }
    
    struct ReviewNew {
        var movieID: Int
        var userID: String
        var username: String
        var reviewText: String
    }

    @IBOutlet weak var reviewTextField: UITextField!
    @IBOutlet weak var reviewTableView: UITableView!
    // @IBOutlet weak var likesLabelVC: UILabel!
    
    var movieID: Int?
    let currentUID = Auth.auth().currentUser?.uid
    var reviews: [Review] = []
    let db = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reviewTableView.delegate = self
        reviewTableView.dataSource = self
        print(movieID)
        getMovieReviews()
    }
    
    func getMovieReviews() {
        db.child("reviews").child("\(movieID!)").observeSingleEvent(of: .value) { snapshot in
            guard let snapCollection = snapshot.value as? [String: Any] else {
                print("ERROR")
                return }
            for snap in snapCollection {
                let dict = snap.value as? [String: Any]
                let snapMovieID = dict!["movieid"] as! Int
                let snapUserID = dict!["userid"] as! String
                let snapUsername = dict!["username"] as! String
                let snapLikes = dict!["likes"] as! Int
                let snapDislikes = dict!["dislikes"] as! Int
                let snapReviewText = dict!["reviewtext"] as! String
                let fetchedReview = Review(movieID: snapMovieID, userID: snapUserID, username: snapUsername, likes: snapLikes, dislikes: snapDislikes, reviewText: snapReviewText)
                self.reviews.append(fetchedReview)
                self.reviewTableView.reloadData()
            }
        }
    }
    
//    @IBAction func didTaplikes(_ sender: Any) {
//        let newlikes = Int(likesLabel.text!)! + 1
//        likesLabel.text = String(newlikes)
//        if case let cell as? UITableViewCell {
//            if let indexPath = self.reviewTableView.indexPath(for: cell) {
//                let movieID = reviews[indexPath.row].userID
//                let userID = reviews[indexPath.row].userID
//                db.child("reviews").child("\(movieID)").child(userID).setValue(["likes": newlikes])
//            }
//        }
//    }
    
//    @IBAction func didTapdislikes(_ sender: Any) {
//    }
    
    @IBAction func didTapAddReview(_ sender: Any) {
        db.child("users").child(currentUID!).observeSingleEvent(of: .value) { snapshot1 in
            let dict1 = snapshot1.value as! [String: Any]
            let username = dict1["username"] as! String
            if self.reviewTextField.text != nil {
                let userreview = Review(movieID: self.movieID!, userID: self.currentUID!, username: username, likes: 0, dislikes: 0, reviewText: self.reviewTextField.text!)
                DatabaseManager.shared.insertReview(with: userreview) { success in
                    if success {
                        // fetch data again and reload table view
                        self.reviews = []
                        self.getMovieReviews()
                        self.reviewTextField.text = ""
                    }
                }
            }
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewTableViewCell
        let item = reviews[indexPath.row]
        cell.setup(username: item.username, review: item.reviewText, likes: item.likes, dislikes: item.dislikes)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if reviews[indexPath.row].userID == currentUID {
            return true
        }
        else {
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if reviews[indexPath.row].userID == currentUID {
            return .delete
        }
        else {
            return .none
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deleteMovieID = reviews[indexPath.row].movieID
            let deleteUserID = reviews[indexPath.row].userID
            db.child("reviews").child("\(deleteMovieID)").child(deleteUserID).removeValue()
            
            reviews.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }
    }
}
