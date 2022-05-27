//
//  FavoriteTableViewController.swift
//  myMovieList
//
//  Created by Zhiyi Chen on 5/14/22.
//

import UIKit
import Firebase
import FirebaseDatabase

class FavoriteTableViewController: UITableViewController {
    
    var favorites: [Movie] = []
    var numOfReviews: [Int] = []
    let currentUID = Auth.auth().currentUser?.uid
    let db = Database.database().reference()

    @IBOutlet var favoriteTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteTableView.delegate = self
        favoriteTableView.dataSource = self
        fetchUserFavorites()
    }
    
    func fetchUserFavorites() {
        db.child("users").child(currentUID!).child("favorites").observe(.value) { snapshot in
            guard let snapCollection = snapshot.value as? [String: String] else {
                print("ERROR")
                return }
            let movieIDs = snapCollection.keys
            self.favorites = []
            self.numOfReviews = []
            for movieID in movieIDs {
                print(movieID)
                let id = Int(movieID)
                let movieIdLink = "https://api.themoviedb.org/3/movie/\(id!)?api_key=5500afde12ee9320ce1ca032c03b6165&language=en-US"
                let movieIdURL = URL(string: movieIdLink)!
                ApiService.shared.getMovieDataFrom(url: movieIdURL) { [self] result in
                    favorites.append(result)
                    // tried to obtain # of reviews failed, put in dummy data first
                    numOfReviews.append(0)
//                    db.child("reviews").child(movieID).observe(.value) { [self] snapshot in
//                        if snapshot.exists() {
//                            let fetchedNumOfReviews = snapshot.childrenCount
//                            numOfReviews.append(Int(fetchedNumOfReviews))
//                        }
//                        else {
//                            numOfReviews.append(0)
//                        }
//                        favoriteTableView.reloadData()
//                    }
                    favoriteTableView.reloadData()
                }
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favorites.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as! FavoriteTableViewCell
        let item = favorites[indexPath.row]
        let reviewNum = numOfReviews[indexPath.row]
        cell.setCellWithValuesOf(item, numOfReviews: reviewNum)
        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "favoriteToDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let movie = favorites[indexPath.row]
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.movie = movie
            }
        }
    }
}
