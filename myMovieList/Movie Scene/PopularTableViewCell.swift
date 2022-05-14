//
//  MovieCell.swift
//  myMovieList
//
//  Created by Zhiyi Chen on 3/31/22.
//

import Foundation
import UIKit

class PopularTableViewCell: UITableViewCell {
    
    @IBOutlet var movieTitle: UILabel!
    @IBOutlet var movieYear: UILabel!
    @IBOutlet var movieOverview: UILabel!
    @IBOutlet var moviePoster: UIImageView!
    @IBOutlet var movieRate: UILabel!

    func setCellWithValuesOf(_ movie: Movie) {
        movieTitle.text = movie.title
        movieYear.text = movie.releaseDate
        movieRate.text = String(format: "%.1f", movie.voteAverage!)
        movieOverview.text = movie.overview
        
        guard let posterString = movie.posterPath else { return }
        let urlString = "http://image.tmdb.org/t/p/w300" + posterString
        let posterImageURL = URL(string: urlString)!
        ApiService.shared.getImageDataFrom(url: posterImageURL) { image in
            self.moviePoster.image = image
        }
    }
}
