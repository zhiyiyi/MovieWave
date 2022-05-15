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
    @IBOutlet weak var likesButton: UIButton!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var dislikesButton: UIButton!
    @IBOutlet weak var dislikesLabel: UILabel!
    
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
    
    func setupLikes(likes: Int) {
        likesLabel.text = String(likes)
    }
    
    func setupDislikes(dislikes: Int) {
        dislikesLabel.text = String(dislikes)
    }
}
