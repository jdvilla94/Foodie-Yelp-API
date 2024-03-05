//
//  seeAllCell.swift
//  Foodie Yelp API
//
//  Created by JD Villanueva on 2/1/24.
//

import UIKit

class seeAllCell: UITableViewCell {
    

    @IBOutlet var restImage: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var rating: UILabel!
    @IBOutlet var address: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
