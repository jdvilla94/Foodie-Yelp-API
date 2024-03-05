//
//  searchCell.swift
//  Foodie Yelp API
//
//  Created by JD Villanueva on 11/10/23.
//

import UIKit

class searchCell: UITableViewCell {
    
    


    @IBOutlet var resturantImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var ratingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        resturantImage.layer.cornerRadius = 15
//        roundedView.layer.borderWidth = 2
//        roundedView.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
//        roundedView.layer.cornerRadius = 15
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
