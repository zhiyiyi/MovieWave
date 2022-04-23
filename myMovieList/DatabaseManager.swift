//
//  DatabaseManager.swift
//  myMovieList
//
//  Created by Zhiyi Chen on 4/21/22.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager { // this class can not be subclassed
    
    // want it to be a singleton
    static let shared = DatabaseManager()
    private let database = Database.database().reference()
}
    
// MARK: - Account Management

extension DatabaseManager {
    
    public func userExits(with email: String, completion: @escaping ((Bool) -> Void)) {
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        database.child(safeEmail).observeSingleEvent(of: .value) { snapshot in
            guard snapshot.value as? String != nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    /// Inserts new user to database
    public func insertUser(with user: MovieAppUser) {
        database.child(user.safeEmail).setValue([
            "first_name": user.firstName,
            "last_name": user.lastName
        ])
    }
}

struct MovieAppUser {
    let firstName: String
    let lastName: String
    let emailAddress: String
    
    var safeEmail: String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    // let profilePictureUrl: String
}
