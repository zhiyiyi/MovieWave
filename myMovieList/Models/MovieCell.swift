//
//  MovieCell.swift
//  myMovieList
//
//  Created by Zhiyi Chen on 3/31/22.
//

import Foundation
import UIKit

class MovieCell: UITableViewCell {
    
    @IBOutlet var movieTitle: UILabel!
    @IBOutlet var movieYear: UILabel!
    @IBOutlet var movieOverview: UILabel!
    @IBOutlet var moviePoster: UIImageView!
    @IBOutlet var movieRate: UILabel!
    
    private var urlString: String = ""
    
    // Setup movies values
    func setCellWithValuesOf(_ movie: Movie) {
        updateUI(title: movie.title, releaseData: movie.year, rating: movie.rate, overview: movie.overview, poster: movie.posterImage)
    }
    
    // Update the UI Views
    private func updateUI(title: String?, releaseData: String?, rating: Double?, overview: String?, poster: String?) {
        self.movieTitle.text = title
        self.movieYear.text = convertDateFormatter(releaseData)
        guard let rate = rating else { return }
        self.movieRate.text = String(rate)
        self.movieOverview.text = overview
        
        guard let posterString = poster else { return }
        urlString = "http://image.tmdb.org/t/p/w300" + posterString
        
        guard let posterImageURL = URL(string: urlString) else {
            self.moviePoster.image = UIImage(named: "noimage")
            return
        }
        
        // Before we download the image we clear out the old one
        self.moviePoster.image = nil
        getImageDataFrom(url: posterImageURL )
        
        
    }
    
    // Get image data
    private func getImageDataFrom(url: URL) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            // Handle error
            if let error = error {
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                // Handle empty data
                print("Empty Data")
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    self.moviePoster.image = image
                }
            }
        }.resume()
    }
    
    // Convert date format
    func convertDateFormatter(_ date: String?) -> String {
        var fixDate = ""
        let dateFormatter  = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let originalDate = date {
            if let newDate = dateFormatter.date(from: originalDate) {
                dateFormatter.dateFormat = "MM.dd.yyyy"
                fixDate = dateFormatter.string(from: newDate)
            }
        }
        return fixDate
    }
}
