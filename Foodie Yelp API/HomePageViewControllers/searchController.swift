//
//  searchController.swift
//  Foodie Yelp API
//
//  Created by JD Villanueva on 11/9/23.
//

import UIKit

class searchController: UIViewController {
    
    var food: String?
    var city: String?
    var neighborhood: String?
    var reference: String?

    
    var name:String?
    var address:String?
    var image: String?
    var rating: Float?
    
    var businesses: [Business] = []
    var nameBusiness: [String] = []
    var addreessBusiness: [String] = []
    var restuarantImage: [String] = []
    var ratings: [Float] = []
    
    var foodEmojiArray: [String:UIImage] = FoodEmojis.allFoods
    var foodCorrectArray: [String] = []
    
    @IBOutlet var searchBar: UISearchBar!
    
    var filteredData: [String] = []
    var currentIndex:Int?
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        // Do any additional setup after loading the view.
        
        searchBar.delegate = self
        
        //        fetchBusinessInfo.shared.getBuisnessData(location: "logan square", category: food!, limit: 30, sortBy: "price", locale: "en_US") { (response, error) in
        //            print("THE RESPONSE IS \(String(describing: response))")
        //                if let response = response {
        //                    for business in response{
        //                        self.nameBusiness.append(business.name!)
        //                        self.addreessBusiness.append(business.address!)
        //                        self.restuarantImage.append(business.image!)
        //                        self.ratings.append(business.rating!)
        //                        self.filteredData = self.nameBusiness
        //                    }
        //                    
        //                    print("WE HAVE SUCCES")
        //                    DispatchQueue.main.async {
        //                        self.tableView.reloadData()
        //                    }
        //                    }else{
        //                        print("The error is \(String(describing: error))")
        //                    }
        //                }
        
        fetchBusinessInfo.shared.getBuisnessData(location: city!, category: food!, limit: 20, sortBy: "rating", locale: "en_US") { (response, error) in
//            print("THE RESPONSE IS \(String(describing: response))")
            if let response = response {
                for business in response{
                    self.nameBusiness.append(business.name!)
                    self.addreessBusiness.append(business.address!)
                    self.restuarantImage.append(business.image!)
                    self.ratings.append(business.rating!)
                    self.filteredData = self.nameBusiness
                }
                
                print("WE HAVE SUCCES")
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }else{
                print("The error is \(String(describing: error))")
            }
        }
    
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.50)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "restaurantInfo"  {
            let destVC = segue.destination as! restaurantInfo
            destVC.name = name
            destVC.address = address
            destVC.image = image
            destVC.rating = rating
        }else if segue.identifier == "toNeighborhoodVC"{
            let destVC = segue.destination as! changeNeighborhoodsVC
            destVC.city = city
            destVC.reference = reference
        }
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if neighborhood != nil{
            print("THE NEIGHTBORHOOD IS: \(neighborhood!)")
        }
        
        
        
    }
    
    @IBAction func unwindToSearchController(_ sender: UIStoryboardSegue){}
    
    @IBAction func settingsTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "toNeighborhoodVC", sender: nil)
    }
    
}

extension searchController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
 
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell") as! searchCell
        // Find the index in the original array
        let filteredIndex = nameBusiness.firstIndex(of: filteredData[indexPath.row])

            if let index = filteredIndex {
                cell.nameLabel.text = nameBusiness[index]
                cell.addressLabel.text = addreessBusiness[index]
                cell.ratingLabel.text = String(ratings[index])
                fetchBusinessInfo.shared.loadImageFromUrl(urlString: restuarantImage[index]) { image in
                    if let image = image {
                        // Use the image
                        DispatchQueue.main.async {
                            // Update your UI with the downloaded image
                            // imageView.image = image
                            cell.resturantImage.image = image
                        }
                    }
                }
            }
//        cell.nameLabel.text = nameBusiness[indexPath.row]
//        cell.addressLabel.text = addreessBusiness[indexPath.row]
//        cell.ratingLabel.text = String(ratings[indexPath.row])
//        fetchBusinessInfo.shared.loadImageFromUrl(urlString: restuarantImage[indexPath.row]) { image in
//            if let image = image {
//                // Use the image
//                DispatchQueue.main.async {
//                    // Update your UI with the downloaded image
//                    // imageView.image = image
//                    cell.resturantImage.image = image
//                }
//            }
//        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return business.count
        return filteredData.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let filteredIndex = nameBusiness.firstIndex(of: filteredData[indexPath.row])

            if let index = filteredIndex {
                name = nameBusiness[index]
                address = addreessBusiness[index]
                image = restuarantImage[index]
                rating = ratings[index]
                performSegue(withIdentifier: "restaurantInfo", sender: (name,address,image,rating))
            }
//        name = nameBusiness[indexPath.row]
//        address = addreessBusiness[indexPath.row]
//        image = restuarantImage[indexPath.row]
//        rating = ratings[indexPath.row]
//        performSegue(withIdentifier: "restaurantInfo", sender: (name,address,image,rating))

    }
    
    
}

extension searchController: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foodEmojiArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "foodIconCell", for: indexPath) as! foodIconCell
        let valuesArray = foodEmojiArray.values.map { $0 }
        let keysArray = foodEmojiArray.keys.map { $0 }
        let values = valuesArray[indexPath.row]
        let keys = keysArray[indexPath.row]
        foodCorrectArray = keysArray
//        print("THE keys are \(keysArray) and the values are \(valuesArray)")
        cell.foodIconImage.image = values
        
        // Check if the current key equals the desired text
        if keys == "chicken_wings" {
            // Replace the text with the new text
            cell.foodIconLabel.text = "wings"
        } else if keys == "pastashops"{
            cell.foodIconLabel.text = "pasta"
        }else{
            cell.foodIconLabel.text = keys
        }

//        cell.foodIconLabel.text = keys
//        print("THe values array is: \(valuesArray)")
        print("THE keys array is: \(keysArray)")
//        food = keys
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("The selected food item is: \(foodCorrectArray[indexPath.row])")
        
        // Clear existing data
        nameBusiness.removeAll()
        addreessBusiness.removeAll()
        restuarantImage.removeAll()
        ratings.removeAll()
        filteredData.removeAll()
//        
        var selectedFoodCategory = foodCorrectArray[indexPath.row]

//
        fetchBusinessInfo.shared.getBuisnessData(location: city!, category: selectedFoodCategory, limit: 30, sortBy:"rating", locale: "en_US") { (response, error) in
//            print("THE RESPONSE IS \(String(describing: response))")
            if let response = response {
                for business in response {
                    self.nameBusiness.append(business.name!)
                    self.addreessBusiness.append(business.address!)
                    self.restuarantImage.append(business.image!)
                    self.ratings.append(business.rating!)
                    self.filteredData = self.nameBusiness
                }
                
                print("WE HAVE SUCCESS")
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                print("The error is \(String(describing: error))")
            }
        }

        }
        
}

extension searchController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = []
        
        if searchText == ""{
            filteredData = nameBusiness
        }else{
            for name in nameBusiness{
                if name.lowercased().contains(searchText.lowercased()){
                    filteredData.append(name)
                    print("FILTERED DATA IS: \(filteredData)")
                }
            }
            
        }
        self.tableView.reloadData()
    }

    
    }

