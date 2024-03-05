//
//  popUpCard.swift
//  Foodie Yelp API
//
//  Created by JD Villanueva on 12/14/23.
//

import UIKit
import CoreLocation

class popUpCard: UIViewController {
    
    @IBOutlet var nameText: UILabel!
    @IBOutlet var image: UIImageView!
    @IBOutlet var addressLabel: UILabel!
    
    var restName: String?
    var addressBusin:String?
    var lat: Double?
    var long: Double?
    
    @IBOutlet var popupCardView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popupCardView.layer.cornerRadius = 15
    }
    
    func changeContainerData(name:String, imageString: String,address: String){
        nameText.text = name
        addressLabel.text = address
        restName = name
        addressBusin = address
        
        //this only rounds the top and left corners instead of all of the corners
        let maskPath = UIBezierPath(
            roundedRect: image.bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: 15, height: 15)
        )
        //this only rounds the top and left corners instead of all of the corners
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        //this only rounds the top and left corners instead of all of the corners
        image.layer.mask = maskLayer
        image.layer.masksToBounds = true
        
//        image.layer.cornerRadius = 15
        fetchBusinessInfo.shared.loadImageFromUrl(urlString: imageString) { image in
            if let image = image {
                // Use the image
                DispatchQueue.main.async {
                    // Update your UI with the downloaded image
                    self.image.image = image
                }
            }
            
        }
        
    }
}





