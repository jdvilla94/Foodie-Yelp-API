//
//  changeCityVC.swift
//  Foodie Yelp API
//
//  Created by JD Villanueva on 11/15/23.
//

import UIKit

class changeCityVC: UIViewController {
    
    var city: String?
    
    var cityArray: [String: UIImage] = Cities.allCities
    @IBOutlet var saveButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! homepageVC
        destVC.city = city
        print("NEW CITY IS: \(city)")
    }
    

}

extension changeCityVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "changeCityCell") as! changeCityCell
        let keysArray = cityArray.keys.map{ $0 }
        let keys = keysArray[indexPath.row]
        cell.cityNameLabel.text = keys
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? changeCityCell {
            // Change the image of the button for the selected cell
            saveButton.isEnabled = true
            city = cell.cityNameLabel.text
        }

    }
    
    
}
