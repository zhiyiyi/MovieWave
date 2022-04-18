//
//  DataViewController.swift
//  myMovieList
//
//  Created by Zhiyi Chen on 3/31/22.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var theMovieTitle: UILabel!
    @IBOutlet var theMovieYear: UILabel!
    @IBOutlet var theMovieOverview: UILabel!
    @IBOutlet var theMovieRate: UILabel!
    @IBOutlet var theMovieGenre: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    
    var movie: Movie? {
        didSet {
            let id = movie?.id
            let movieIdLink = "https://api.themoviedb.org/3/movie/\(id!)?api_key=5500afde12ee9320ce1ca032c03b6165&language=en-US"
            let movieIdUrl = URL(string: movieIdLink)
            getMovieDataFrom(url: movieIdUrl!)
        }
    }
    
    var idMovie: Movie?
    var posters: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 240, height: 128)
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MyCollectionViewCell.nib(), forCellWithReuseIdentifier: MyCollectionViewCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let movieData = idMovie else { return }
        self.setWithValuesOf(movieData)
    }
    
    private var urlPosterString: String = ""
    private var urlBackdropString: String = ""
    
    // Setup movies values
    func setWithValuesOf(_ movie: Movie) {
        updateUI(title: movie.title, releaseData: movie.year, rating: movie.ratingText, genre: movie.genreText, overview: movie.overview, poster: movie.posterImage, backdrop: movie.backdropPath)
    }
    
    // Update the UI Views
    private func updateUI(title: String?, releaseData: String?, rating: String?, genre: String?, overview: String?, poster: String?, backdrop: String?) {
        self.theMovieTitle.text = title
        self.theMovieYear.text = releaseData
        self.theMovieOverview.text = overview
        self.theMovieRate.text = rating
        self.theMovieGenre.text = genre
        
        guard let posterString = poster else { return }
        urlPosterString = "http://image.tmdb.org/t/p/w300" + posterString
        
        guard let posterImageURL = URL(string: urlPosterString) else {
            self.posters.append(UIImage(named: "noimage")!)
            return
        }
        
        guard let backdropString = backdrop else { return }
        urlBackdropString = "http://image.tmdb.org/t/p/w300" + backdropString
        
        guard let backdropImageURL = URL(string: urlBackdropString) else {
            self.posters.append(UIImage(named: "noimage")!)
            return
        }
        
        // Before we download the image we clear out the old one
        //self.posters = []
        getImageDataFrom(url: posterImageURL)
        getImageDataFrom(url: backdropImageURL)
    }
    
    
    // Get image data
    private func getImageDataFrom(url: URL) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            // Handle empty data
            guard let data = data else {
                print("Empty Data")
                return
            }
            
            // Handle error
            if let error = error {
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            
            // Update UI in the main thread
            //DispatchQueue.main.async {
            if let image = UIImage(data: data) {
                self.posters.append(image)
            } else {
                self.posters.append(UIImage(named: "noimage")!)
            }
            //}
        }.resume()
    }
    
    private func getMovieDataFrom(url: URL) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            // Handle empty data
            guard let data = data else {
                print("Empty Data")
                return
            }
            // Handle error
            if let error = error {
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            do {
                self.idMovie = try JSONDecoder().decode(Movie.self, from: data)
            } catch {
                print("JSON Downloading Error!")
            }
        }.resume()
    }
    
}

extension DetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("You tapped me!")
    }
}

extension DetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return 2
        return posters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCollectionViewCell.identifier, for: indexPath) as! MyCollectionViewCell
        // cell.configure(with: UIImage(named: "star")!)
        cell.configure(with: posters[indexPath.row])
        return cell
    }
}

extension DetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 240, height: 128)
    }
}
