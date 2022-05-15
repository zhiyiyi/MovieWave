//
//  NowPlayingTableViewController.swift
//  myMovieList
//
//  Created by Zhiyi Chen on 5/14/22.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase

class NowPlayingTableViewController: UITableViewController {
    
    var movies: [Movie] = []
    let nowPlayingMoviePath = "https://api.themoviedb.org/3/movie/now_playing?api_key=5500afde12ee9320ce1ca032c03b6165&language=en-US&page=1"
    let currentUID = Auth.auth().currentUser?.uid
    let sr = Storage.storage().reference()
    let db = Database.database().reference()
    var isFavorite = false

    @IBOutlet var nowPlayingTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nowPlayingTableView.delegate = self
        nowPlayingTableView.dataSource = self
        
        fetchNowPlayingMoviesData()
    }
    
    func fetchNowPlayingMoviesData() {
        guard let nowPlayingMovieURL = URL(string: nowPlayingMoviePath) else { return }
        ApiService.shared.getMoviesDataFrom(with: nowPlayingMovieURL, completion: { result in
            switch result {
            case .success(let movieList):
                DispatchQueue.main.async {
                    self.movies = movieList.movies
                    self.nowPlayingTableView.reloadData()
                }
            case .failure(let error):
                print("Error processing json data: \(error)")
            }
        })
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nowPlayingCell", for: indexPath) as! NowPlayingTableViewCell
        let item = movies[indexPath.row]
        cell.setCellWithValuesOf(item)
        cell.favoriteButton.tag = indexPath.row
        cell.favoriteButton.addTarget(self, action: #selector(didTapFavorite(sender:)), for: .touchUpInside)
        return cell
    }
    
    @objc func didTapFavorite(sender: UIButton) {
        // print(sender.tag)
        let movieID = movies[sender.tag].id
        if isFavorite == false {
            isFavorite = true
            sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            db.child("users").child(currentUID!).child("favorites").child((String(movieID!))).setValue("Yes")
        }
        else {
            isFavorite = false
            sender.setImage(UIImage(systemName: "heart"), for: .normal)
            db.child("users").child(currentUID!).child("favorites").child((String(movieID!))).removeValue()
        }
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            movies.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } // else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        // }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "nowPlayingToDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let movie = movies[indexPath.row]
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.movie = movie
            }
        }
    }

}
