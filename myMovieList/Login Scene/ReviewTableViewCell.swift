//
//  ReviewTableViewCell.swift
//  myMovieList
//
//  Created by Zhiyi Chen on 5/13/22.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var dislikesLabel: UILabel!
    
    // var owner: String
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(username: String, review: String, likes: Int, dislikes: Int) {
        usernameLabel.text = username
        reviewLabel.text = review
        likesLabel.text = String(likes)
        dislikesLabel.text = String(dislikes)
    }

//    @IBAction func didTapLikes(_ sender: Any) {
//    }
}
