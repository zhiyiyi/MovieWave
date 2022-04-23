//
//  ReviewDataManager.swift
//  myMovieList
//
//  Created by Zhiyi Chen on 4/23/22.
//

import Foundation
import FirebaseDatabase

//func fetchReviews() {
//    self.reviews.removeAll()
//    Database.database().reference().child("movieReviews").child(String((movie?.id)!)).observe(.childAdded, with: { (snapshot) in
//        if let dict = snapshot.value as? [String: Any] {
//            let temp = ReviewModel()
//            temp.dislikes = dict["dislikes"] as? Int
//            temp.likes = dict["likes"] as? Int
//            temp.review = dict["review"] as? String
//            temp.username = dict["username"] as? String
//            temp.id = dict["id"] as? String
//            self.reviews.append(temp)
//        }
//        DispatchQueue.main.async {
//            self.reviewTableView.reloadData()
//        }
//        //
//    }, withCancel: nil)
//}
