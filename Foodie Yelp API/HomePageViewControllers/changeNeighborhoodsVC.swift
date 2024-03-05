//
//  changeNeighborhoodsVC.swift
//  Foodie Yelp API
//
//  Created by JD Villanueva on 11/15/23.
//

import UIKit
import CoreLocation

class changeNeighborhoodsVC: UIViewController {
    var city: String?
    var neighboorhood: String?
    var coordinates: CLLocationCoordinate2D?
    var reference:String?

    
    var chicagoNeighborhoods: [String:CLLocationCoordinate2D] = Chicago.chicagoNeighborhoods
    var seattleNeighborhoods: [String:CLLocationCoordinate2D] = Seattle.seattleNeighborhoods
    var newOrleansNeighborhoods: [String:CLLocationCoordinate2D] = NewOrleans.newOrleansNeighborhoods
    var austinNeighborhoods: [String:CLLocationCoordinate2D] = Austin.austinNeighborhoods
    var bostonNeightborhoods: [String:CLLocationCoordinate2D] = Boston.bostonNeighborhoods
    var losAngelesNeighborhoods: [String:CLLocationCoordinate2D] = LosAngeles.losAngelesNeighborhoods
    var miamiNeighborhoods:[String:CLLocationCoordinate2D] =  Miami.miamiNeighborhoods
    var newYorkNeighborhoods:[String:CLLocationCoordinate2D] = NewYork.newYorkNeighborhoods
    var dummyArray: [String:CLLocationCoordinate2D] = [:]
    var mainKeyArray: [String] = []

 
    @IBOutlet var saveButton: UIBarButtonItem!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        arrayCount()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let destVC = segue.destination as! searchController
//        destVC.neighborhood = neighboorhood
        if reference == "map"{
            let destVC = segue.destination as? mapVC
            destVC?.neighborhood = neighboorhood
            destVC?.neighborhoodCoordinate = coordinates
            destVC?.city = city
        }else{
            let destVC = segue.destination as? searchController
            destVC?.neighborhood = neighboorhood
        }
      

 
//        let secondDestVC = segue.destination as! mapVC
//        secondDestVC.city = neighboorhood
    }
    

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        if reference == "home"{
            performSegue(withIdentifier: "unwindToSearchController", sender: self)
            print("home")
        }else{
            performSegue(withIdentifier: "unwindToMap", sender: self)
            print("map")
        }
    }
    
    
    
    func arrayCount(){
        if city! == "Seattle"{
            dummyArray = seattleNeighborhoods
        } else if city! == "Chicago"{
            dummyArray = chicagoNeighborhoods
        } else if city! == "New Orleans"{
            dummyArray = newOrleansNeighborhoods
        } else if city! == "Austin"{
            dummyArray = austinNeighborhoods
        } else if city! == "Boston" {
            dummyArray = bostonNeightborhoods
        }else if city! == "Los Angeles"{
            dummyArray = losAngelesNeighborhoods
        }else if city! == "Miami"{
            dummyArray = miamiNeighborhoods
        }else if city! == "New York"{
            dummyArray = newYorkNeighborhoods
        }
    }
    

    
}

extension changeNeighborhoodsVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "changeNeighborhoodCell") as! changeNeighborhoodCell
        let keysArray = Array(dummyArray.keys)
        mainKeyArray = keysArray
        let keys = keysArray[indexPath.row]
        if let value = dummyArray[keys]{
            print("Key: \(keys), Value: \(value)")
            cell.cityLabel.text = keys
            coordinates = value
        }
        
        //the above code refactors the bottom code so we dont need to write all of the if statements
        
//        if city! == "Seattle"{
//            let keysArray = Array(seattleNeighborhoods.keys)
//            mainKeyArray = keysArray
//            let keys = keysArray[indexPath.row]
//            cell.cityLabel.text = keys
//        } else if city! == "Chicago"{
//            let keysArray = chicagoNeighborhoods.keys.map { $0 }
//            mainKeyArray = keysArray
//            print(keysArray)
//
//            let keys = keysArray[indexPath.row]
//            if let value = chicagoNeighborhoods[keys] {
//                print("Key: \(keys), Value: \(value)")
//                cell.cityLabel.text = keys
//                coordinates = value
//            }
////            let keysArray = Array(chicagoNeighborhoods.keys)
////            print(keysArray)
////            let keys = keysArray[indexPath.row]
////            let valuesArray = Array(chicagoNeighborhoods.values)
////            print(valuesArray)
////            let values = valuesArray[indexPath.row]
////            cell.cityLabel.text = keys
//////            coordinates = values
//        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? changeNeighborhoodCell {
            // Change the image of the button for the selected cell
            cell.radioButton.isEnabled = true
            cell.radioButton.setImage(UIImage(systemName: "button.programmable"), for: .normal)
            cell.radioButton.tintColor = .red
            saveButton.isEnabled = true

            let keys = mainKeyArray[indexPath.row]
            if let value = dummyArray[keys] {
                print("Key: \(keys), Value: \(value)")
                cell.cityLabel.text = keys
                coordinates = value
                neighboorhood = keys
            }
        }

    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? changeNeighborhoodCell {
            // Change the image of the button for the selected cell
            cell.radioButton.isEnabled = false
            cell.radioButton.setImage(UIImage(systemName: "circle"), for: .normal)

        }
    }
    
    
}
