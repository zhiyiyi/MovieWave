//
//  NowPlayingTableViewCell.swift
//  myMovieList
//
//  Created by Zhiyi Chen on 5/14/22.
//

import UIKit

class NowPlayingTableViewCell: UITableViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCellWithValuesOf(_ movie: Movie) {
        titleLabel.text = movie.title
        yearLabel.text = movie.releaseDate
        rateLabel.text = String(format: "%.1f", movie.voteAverage!)
        overviewLabel.text = movie.overview
        
        guard let posterString = movie.posterPath else { return }
        let urlString = "http://image.tmdb.org/t/p/w300" + posterString
        let posterImageURL = URL(string: urlString)!
        ApiService.shared.getImageDataFrom(url: posterImageURL) { image in
            self.posterImageView.image = image
        }
    }

}
