//
//  followingCell.swift
//  Foodie Yelp API
//
//  Created by JD Villanueva on 1/23/24.
//

import UIKit

class followingCell: UITableViewCell {
    
    
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var userName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
