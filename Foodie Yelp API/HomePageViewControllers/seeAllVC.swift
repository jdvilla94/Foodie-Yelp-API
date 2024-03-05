//
//  seeAllVC.swift
//  Foodie Yelp API
//
//  Created by JD Villanueva on 1/31/24.
//

import UIKit

class seeAllVC: UIViewController {
    
    var name: [String] = []
    var address: [String] = []
    var restImage: [String] = []
    var rating: [Float] = []
    
    var currentIndex:Int?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.50)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "nearbyToRestInfo"{
            let destVC = segue.destination as! restaurantInfo
            destVC.name = name[currentIndex!]
            destVC.address = address[currentIndex!]
            destVC.rating = 4.0
            destVC.image = restImage[currentIndex!]
        }
    }
    
}

extension seeAllVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return name.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "seeAllCell", for: indexPath) as! seeAllCell
        
        cell.name.text = name[indexPath.row]
        cell.address.text = address[indexPath.row]
        fetchBusinessInfo.shared.loadImageFromUrl(urlString: self.restImage[indexPath.row]) { image in
            if let image = image {
                // Use the downloaded image
                DispatchQueue.main.async {
                    cell.restImage.layer.cornerRadius = 15
                    cell.restImage.image = image
                }
                
            }
        }
        cell.rating.text = String(4.0)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentIndex = indexPath.row
        performSegue(withIdentifier: "nearbyToRestInfo", sender: nil)
    }
    
    
}
