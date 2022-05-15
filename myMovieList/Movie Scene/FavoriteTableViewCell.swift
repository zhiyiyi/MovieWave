//
//  FavoriteTableViewCell.swift
//  myMovieList
//
//  Created by Zhiyi Chen on 5/14/22.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var numOfReviewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCellWithValuesOf(_ movie: Movie, numOfReviews: Int) {
        titleLabel.text = movie.title
        rateLabel.text = String(format: "%.1f", movie.voteAverage!)
        numOfReviewLabel.text = "Reviews: \(numOfReviews)"
        guard let posterString = movie.posterPath else { return }
        let urlString = "http://image.tmdb.org/t/p/w300" + posterString
        let posterImageURL = URL(string: urlString)!
        ApiService.shared.getImageDataFrom(url: posterImageURL) { image in
            self.posterImageView.image = image
        }
    }
}
