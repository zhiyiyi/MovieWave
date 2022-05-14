//
//  DatabaseManager.swift
//  myMovieList
//
//  Created by Zhiyi Chen on 4/21/22.
//

import Foundation
import Firebase
import FirebaseDatabase

final class DatabaseManager { // this class can not be subclassed
    // want it to be a singleton
    static let shared = DatabaseManager()
    private let database = Database.database().reference()
}
    
// MARK: - Account Management

extension DatabaseManager {
    
//    public func userExits(with userID: String, completion: @escaping ((Bool) -> Void)) {
//        database.child("users").child(userID).observeSingleEvent(of: .value) { snapshot in
//            guard snapshot.value as? [String: Any] != nil else {
//                completion(false)
//                return
//            }
//            completion(true)
//        }
//    }
    
    /// Inserts new user to database
    public func insertUser(with user: MovieAppUser, completion: @escaping (Bool) -> Void) {
        database.child("users").child(user.userID).setValue([
            "firstname": user.firstname,
            "lastname": user.lastname,
            "username": user.username
        ]) { error, _ in
            guard error == nil else {
                print("Failed to insert user to the database")
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    public func insertReview(with review: Review, completion: @escaping (Bool) -> Void) {
        database.child("reviews").child(String(review.movieID)).child(review.userID).setValue([
            "movieid": review.movieID,
            "userid": review.userID,
            "username": review.username,
            "likes": review.likes,
            "dislikes": review.dislikes,
            "reviewtext": review.reviewText
        ]) { error, _ in
            guard error == nil else {
                print("Failed to insert review to the database")
                completion(false)
                return
            }
            completion(true)
        }
    }
}

