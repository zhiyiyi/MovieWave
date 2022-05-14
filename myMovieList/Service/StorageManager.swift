//
//  StorageManager.swift
//  myMovieList
//
//  Created by Zhiyi Chen on 4/22/22.
//

import Foundation
import FirebaseStorage
import UIKit

final class StorageManager {
    
    static let shared = StorageManager()
    private let storage = Storage.storage().reference()
    
    // completion: a result object, success -> return a string, fail -> return an error
    public typealias UploadPictureCompletion = (Bool) -> Void
    public typealias DownloadURLCompletion = (Result<URL, Error>) -> Void
    
    /// Uploads picture to firebase storage and returns completion with url string to download
    public func uploadProfilePicture(with image: UIImage, userID: String, completion: @escaping UploadPictureCompletion) {
        let data = image.pngData()
        storage.child("images").child(userID).putData(data!, metadata: nil) { metadata, error in
            guard error == nil else {
                print("Failed to upload profile photo to Firebase")
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    public func downloadProfilePicture(with userID: String, completion: @escaping (UIImage) -> Void) {
        let ref = storage.child("images").child(userID)
        ref.downloadURL { url, error in
            if let error1 = error {
                print(error1)
                completion(UIImage(systemName: "photo.artframe")!)
            } else {
                if let urlData = url, let data = try? Data(contentsOf: urlData.absoluteURL) {
                    let image = UIImage(data: data)
                    completion(image!)
                }
            }
            
        }
    }
}
