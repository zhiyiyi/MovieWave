//
//  DataViewController.swift
//  myMovieList
//
//  Created by Zhiyi Chen on 3/31/22.
//

import UIKit
import Firebase
import SwiftUI

class DetailViewController: UIViewController {
    
    @IBOutlet var theMovieTitle: UILabel!
    @IBOutlet var theMovieYear: UILabel!
    @IBOutlet var theMovieOverview: UILabel!
    @IBOutlet var theMovieRate: UILabel!
    @IBOutlet var theMovieGenre: UILabel!
    @IBOutlet var detailCollectionView: UICollectionView!
    
    var movie: Movie?
    var idMovie: Movie?
    var posters: [UIImage] = []
    let currentUID = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        //layout.itemSize = CGSize(width: 240, height: 128)
        layout.scrollDirection = .horizontal
        detailCollectionView.collectionViewLayout = layout
        detailCollectionView.delegate = self
        detailCollectionView.dataSource = self
        detailCollectionView.register(DetailCollectionViewCell.nib(), forCellWithReuseIdentifier: DetailCollectionViewCell.identifier)
        
        createNavHeader()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let id = movie?.id
        let movieIdLink = "https://api.themoviedb.org/3/movie/\(id!)?api_key=5500afde12ee9320ce1ca032c03b6165&language=en-US"
        let movieIdURL = URL(string: movieIdLink)!
        ApiService.shared.getMovieDataFrom(url: movieIdURL) { result in
            self.idMovie = result
            self.setWithValuesOf(self.idMovie!)
        }
    }
    
    func setWithValuesOf(_ movie: Movie) {
        theMovieTitle.text = movie.title
        theMovieYear.text = movie.releaseDate
        theMovieOverview.text = movie.overview
        theMovieRate.text = movie.ratingText
        theMovieGenre.text = movie.genreText
        
        guard let posterString = movie.posterPath else { return }
        let urlPosterString = "http://image.tmdb.org/t/p/w300" + posterString
        let posterURL = URL(string: urlPosterString)!
        
        guard let backdropString = movie.backdropPath else { return }
        let urlBackdropString = "http://image.tmdb.org/t/p/w300" + backdropString
        let backdropURL = URL(string: urlBackdropString)!
        
        // Before we download the image we clear out the old one
        //self.posters = []
        ApiService.shared.getImageDataFrom(url: posterURL) { image1 in
            self.posters.append(image1)
            ApiService.shared.getImageDataFrom(url: backdropURL) { image2 in
                self.posters.append(image2)
                self.detailCollectionView.reloadData()
            }
        }
    }
    
    func createNavHeader() {
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(didTapLogout))
        ]
        StorageManager.shared.downloadProfilePicture(with: currentUID!) { image in
            let button = UIButton(type: .custom)
            button.frame = CGRect(x: 0.0, y: 0.0, width: 24, height: 24)
            button.setImage(image, for: .normal)
            button.addTarget(self, action: #selector(self.didTapProfilePhoto), for: .touchUpInside)
            let barButtonItem = UIBarButtonItem(customView: button)
            let currWidth = barButtonItem.customView?.widthAnchor.constraint(equalToConstant: 24)
            currWidth?.isActive = true
            let currHeight = barButtonItem.customView?.heightAnchor.constraint(equalToConstant: 24)
            currHeight?.isActive = true
            self.navigationItem.rightBarButtonItems?.append(barButtonItem)
        }
    }
    
    @objc func didTapLogout() {
        do {
            try? Auth.auth().signOut()
            let navViewController = self.storyboard?.instantiateViewController(withIdentifier: "loginpage") as? UINavigationController
            self.view.window?.rootViewController = navViewController
            self.view.window?.makeKeyAndVisible()
        }
    }
    
    @objc func didTapProfilePhoto() {
        do {
            performSegue(withIdentifier: "detailToProfile", sender: self)
        }
    }
    
    @IBAction func didTapReview(_ sender: Any) {
        performSegue(withIdentifier: "detailToReview", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailToReview" {
            let reviewViewController = segue.destination as! ReviewViewController
            reviewViewController.movieID = movie?.id
        }
        
        if segue.identifier == "detailToProfile" {
            let profileViewController = segue.destination as! ProfileViewController
            profileViewController.currentUID = currentUID!
        }
    }
}

extension DetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCollectionViewCell.identifier, for: indexPath) as! DetailCollectionViewCell
        let poster = posters[indexPath.row]
        cell.configure(with: poster)
        return cell
    }
}

extension DetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 240, height: 128)
    }
}
