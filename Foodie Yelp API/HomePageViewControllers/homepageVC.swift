//
//  homepageVC.swift
//  Foodie Yelp API
//
//  Created by JD Villanueva on 11/9/23.
//

import UIKit
import FirebaseAuth
import MapKit
import FirebaseStorage
import CoreLocation

class homepageVC: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var business: [Business] = []
//    var neighboorhoodArray: [String] = Neighborhoods.allNeighborhoods
    
    var city: String?
    var food: String?
    
//    var profileImage:UIImage?
    
    var favoriteNames: [String] = []
    var favoriteImages: [String] = []
    var favoriteAddress:[String] = []
    var favoriteRating: [Float] = []

    var cityNameButton = UILabel()
    
    var reference:String?
    var photoReference:String?
    var pathNum:Int?
    
    var businesses: [Business] = []
    var nameBusiness: [String] = []
    var addreessBusiness: [String] = []
    var restuarantImage: [String] = []
    var ratings: [Float] = []
    
    var nameBusinessCloset: [String] = []
    var addreessBusinessCloset: [String] = []
    var restuarantImageCloset: [String] = []
    var ratingsCloset: [Float] = []
    
    var randomNumber:Int?
    var randomImage:String?
    
    
    @IBOutlet var foodImage: UIImageView!
    @IBOutlet var foodTitle: UILabel!
    @IBOutlet var foodAddress: UILabel!
    @IBOutlet var typeOfFoodImage: UIImageView!
        
    var foodEmojiArray: [String:UIImage] = FoodEmojis.allFoods
    var randomImageKey: String?
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        if let user = Auth.auth().currentUser {
            let uid = user.uid
            print("User UID: \(uid)")
        }
        
        // Do any additional setup after loading the view.
        if city == nil {
            authService.shared.getCityandFood { [weak self] item, error in
                guard let self = self else{return}
                if let error = error {
                    print("There was an error in getting favFoodandCity\(error)")
                    return
                }
                
                if let item = item{
                    self.city = item.favCity
                    self.food = item.favFood
                    callAPI()
                    cityNameButton.font = UIFont(name: "Verdana-Bold", size: 18)
                    cityNameButton.text = "\(self.city!) 🏙️"
                    cityNameButton.isUserInteractionEnabled = true
                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(titleLabelTapped))
                    cityNameButton.addGestureRecognizer(tapGesture)
                    
                    // Set the UILabel as the titleView
                    navigationItem.titleView = cityNameButton
                    
                    //change navbar title color and font and size
                    if let navigationController = self.navigationController, let font = UIFont(name: "Verdana-Bold", size: 18) {
                        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 0, green: 0, blue: 0, alpha: 1.0), NSAttributedString.Key.font: font]
                        navigationController.navigationBar.titleTextAttributes = textAttributes
                        
                    }
                }
                
            }
            
            
        }
        
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.50)
        
        addTapToRandomImage()
        foodImage.layer.cornerRadius = 15
        collectionView.showsHorizontalScrollIndicator = false
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("The current user auth is: \(Auth.auth().currentUser?.uid)")
        DispatchQueue.main.async {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startUpdatingLocation()
            self.checkLocationAuthorization()
            print("The user lat: \(self.locationManager.location?.coordinate.latitude) and the long is \(self.locationManager.location?.coordinate.latitude) in view will appear")
        }

//        guard let userLocation = locationManager.location else {
//               // Handle the case where user location is not available
//           
//               return
//           }
//        
//        print("The lat is \(userLocation.coordinate.latitude) and the long is \(userLocation.coordinate.longitude) ")
        
//        startLocationUpdates()
//        checkLocationAuthorization()

        
//        fetchBusinessInfo.shared.getClosetFoodRestaurants(latitude: 41.8781, longitude: -87.6298) { response, error in
//            if let error = error {
//                print("Error: \(error.localizedDescription)")
//            }
//            if let response = response {
//                // Handle the Yelp API response (extract business details)
//                for bus in response{
//                    self.nameBusinessCloset.append(bus.name!)
//                    self.addreessBusinessCloset.append(bus.address!)
//                    self.restuarantImageCloset.append(bus.image!)
//                    self.ratingsCloset.append(bus.rating!)
////                    print("it worked")
//                }
//                DispatchQueue.main.async {
//                    self.collectionView.reloadData()
//                }
////                    print("the getcloset worked")
////                    print("The count of the responses back are: \(response.count)")
////                    print("Yelp API Response: \(response)")
//            }
//
//        }

        
        if city != nil{
            print("THE NEW CITY FROM CHANGE CITY VC: \(city!)")
            cityNameButton.font = UIFont(name: "Verdana-Bold", size: 18)
            cityNameButton.text = "\(city!) 🏙️"
//            authService.shared.getFavoritesSaved { favorites, error in
//                self.favoriteNames.removeAll()
//                self.favoriteImages.removeAll()
//                self.favoriteAddress.removeAll()
//                self.favoriteRating.removeAll()
//                if let error = error {
//                    print("Error fetching favorites: \(error.localizedDescription)")
//                    return
//                }
//                
//                // Use the favorites array
//                if let favorites = favorites {
//                    for favorite in favorites {
//                        self.favoriteNames.append(favorite.name!)
//                        self.favoriteImages.append(favorite.image!)
//                        self.favoriteRating.append(favorite.rating!)
//                        self.favoriteAddress.append(favorite.address!)
//                    }
//                    self.collectionView.reloadData()
//                }
//
//                
//            }
            
        }
        print("THE PHOTO REF = \(self.photoReference)")
        

       
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tochangeCityVC"{
            let destVC = segue.destination as? changeCityVC
            destVC?.city = city
        }else if segue.identifier == "toSearchVC" {
            let destVC = segue.destination as? searchController
            destVC?.food = food
            destVC?.city = city
            destVC?.reference = "home"
        }else if segue.identifier == "fromHometoRestaurantVC"{
            if photoReference == "randomImage"{
                let destVC = segue.destination as! restaurantInfo
                destVC.name = foodTitle.text
                destVC.address = foodAddress.text
                destVC.image = randomImage
                destVC.rating = 4.0
            }else if photoReference == "favImage"{
                let destVC = segue.destination as! restaurantInfo
                destVC.name = nameBusinessCloset[pathNum!]
                destVC.address = addreessBusinessCloset[pathNum!]
                destVC.image = restuarantImageCloset[pathNum!]
//                destVC.name = favoriteNames[pathNum!]
//                destVC.address = favoriteAddress[pathNum!]
//                destVC.image = favoriteImages[pathNum!]
                destVC.rating = 4.0
            }

        } else if segue.identifier == "fromHomeToChangeRestaurantVC"{
            let destVC = segue.destination as! changeNeighborhoodsVC
            destVC.city = city
            
        }else if segue.identifier == "homeToSeeAllTableView"{
            let destVC = segue.destination as! seeAllVC
            destVC.name = nameBusinessCloset
            destVC.restImage = restuarantImageCloset
            destVC.address = addreessBusinessCloset
            destVC.rating = ratingsCloset
        }

    }
        
    func addTapToRandomImage(){
        foodImage.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        foodImage.addGestureRecognizer(tapGesture)
        
    }
    
    func callAPI(){
        fetchBusinessInfo.shared.getBuisnessData(location: city!, category: food!, limit: 50, sortBy: "rating", locale: "en_US") { (response, error) in
//            print("THE RESPONSE IS \(String(describing: response))")
            if let response = response {
                for business in response{
                    self.nameBusiness.append(business.name!)
                    self.addreessBusiness.append(business.address!)
                    self.restuarantImage.append(business.image!)
                    self.ratings.append(4.0)
                }
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
                self.randomNumber = self.business.count
                self.randomImage = self.restuarantImage[self.randomNumber!]
                

                fetchBusinessInfo.shared.loadImageFromUrl(urlString: self.randomImage! ) { image in
                    if let image = image {
                        // Use the image
                        DispatchQueue.main.async {
                            // Update your UI with the downloaded image
                            self.foodImage.image = image
                            self.foodTitle.text = self.nameBusiness[self.randomNumber!]
                            self.foodAddress.text = self.addreessBusiness[self.randomNumber!]
                            self.typeOfFoodImage.image = self.foodEmojiArray[self.food!]
//                            var keysArray = Array(self.foodEmojiArray.keys)
//                            var randomKey = keysArray[Int.random(in: 0..<8)]
//                            self.typeOfFoodImage.image = self.foodEmojiArray[self.food!]
                        }
                    }
                }
            }else{
                print("The error is \(String(describing: error))")
            }
        }

    }
    
    func randomAPICall(){
        var keysArray = Array(self.foodEmojiArray.keys)
        var randomKey = keysArray[Int.random(in: 0..<8)]
        var randomNumber: Int
        print("The randomImageKey is: \(randomImageKey)")
        randomImageKey = randomKey
        nameBusiness = []
        addreessBusiness = []
        restuarantImage = []
        ratings = []
        print("The random Key is: \(randomKey)")
        fetchBusinessInfo.shared.getBuisnessData(location: city!, category: randomKey, limit: 50, sortBy: "rating", locale: "en_US") { (response, error) in
//            print("THE RESPONSE IS \(String(describing: response))")
            if let response = response {
                for business in response{
                    self.nameBusiness.append(business.name!)
                    self.addreessBusiness.append(business.address!)
                    self.restuarantImage.append(business.image!)
                    self.ratings.append(business.rating!)
                    self.randomNumber = Int.random(in: 0..<response.count)
                    print("All of the businesses are: \(business)")
                }
//                DispatchQueue.main.async {
//                    self.typeOfFoodImage.image = self.foodEmojiArray[randomKey]
//                }
//                self.randomNumber = Int.random(in: 0..<49)
//                self.randomNumber = self.business.count
//                print("The random number is: \(self.randomNumber)")
                print("The random number is: \(self.randomNumber)")
                self.randomImage = self.restuarantImage[self.randomNumber!]

                fetchBusinessInfo.shared.loadImageFromUrl(urlString: self.randomImage!) { image in
                    if let image = image {
                        // Use the image
                        DispatchQueue.main.async {
                            // Update your UI with the downloaded image
                            self.foodImage.image = image
                            self.foodTitle.text = self.nameBusiness[self.randomNumber!]
                            self.foodAddress.text = self.addreessBusiness[self.randomNumber!]
                            self.typeOfFoodImage.image = self.foodEmojiArray[randomKey]
                        }
                    }
                }
            }else{
                print("The error is \(String(describing: error))")
            }
        }
    }
    
    @IBAction func randomPressed(_ sender: UIButton) {
        randomAPICall()
    }
    
    @IBAction func unwindToHome(_ sender: UIStoryboardSegue){}
    
    // Function to handle label tap
    @objc func titleLabelTapped() {
        print("Title label tapped!")
        // Add your desired action here
        performSegue(withIdentifier: "tochangeCityVC", sender: nil)
    }
    
    @objc func imageTapped(){
        print("Image pressed")
        photoReference = "randomImage"
        performSegue(withIdentifier: "fromHometoRestaurantVC", sender: (foodImage.image,foodTitle.text,foodAddress.text))
    }
    
    @IBAction func seeAllTapped(_ sender: UIButton) {
//        print("I tapped the see all button")
        performSegue(withIdentifier: "homeToSeeAllTableView", sender: nil)
    }
}

extension homepageVC: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if nameBusinessCloset.isEmpty{
            return 1
        }else{
            return nameBusinessCloset.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoritesSliderCell", for: indexPath) as!favoritesSliderCell
        // Inside the cellForItemAt method
      
        // Reset the transform
        
        cell.transform = CGAffineTransform.identity
        
        if self.nameBusinessCloset.isEmpty {
            // Display the empty state image
            cell.name.text = ""
            cell.image.image = UIImage(resource: .emptyState)
            
        } else {
            // Load the image from the URL
            
            let favName = self.nameBusinessCloset[indexPath.item]
            cell.name.text = favName
            // Load the image from the URL
            
            fetchBusinessInfo.shared.loadImageFromUrl(urlString: self.restuarantImageCloset[indexPath.row]) { image in
                if let image = image {
                    // Use the downloaded image
                    DispatchQueue.main.async {
                        cell.image.image = image
                    }
                    
                }
            }
        }
        cell.image.layer.cornerRadius = 15
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        photoReference = "favImage"
        pathNum = indexPath.row
        print("The path number is \(pathNum)")
        performSegue(withIdentifier: "fromHometoRestaurantVC", sender: nil)
    }
    
}

extension homepageVC: UIScrollViewDelegate{
    // perform scaling whenever the collection view is being scrolled
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // center X of collection View
        let centerX = self.collectionView.center.x
    
        // only perform the scaling on cells that are visible on screen
        for cell in self.collectionView.visibleCells {
            
            // coordinate of the cell in the viewcontroller's root view coordinate space
            let basePosition = cell.convert(CGPoint.zero, to: self.view)
            let cellCenterX = basePosition.x + self.collectionView.frame.size.height / 2.0
            
            let distance = fabs(cellCenterX - centerX)
            
            let tolerance : CGFloat = 0.02
            var scale = 1.00 + tolerance - (( distance / centerX ) * 0.105)
            if(scale > 1.0){
                scale = 1.0
            }
            
            // set minimum scale so the previous and next album art will have the same size
            // I got this value from trial and error
            // I have no idea why the previous and next album art will not be same size when this is not set 😅
            if(scale < 0.860091){
                scale = 0.860091
            }
            
            // Transform the cell size based on the scale
            cell.transform = CGAffineTransform(scaleX: scale, y: scale)
            
            // change the alpha of the image view
            let coverCell = cell as! favoritesSliderCell
            coverCell.image.alpha = changeSizeScaleToAlphaScale(scale)
        }
}
    
// map the scale of cell size to alpha of image view using formula below

    func changeSizeScaleToAlphaScale(_ x : CGFloat) -> CGFloat {
        let minScale : CGFloat = 0.86
        let maxScale : CGFloat = 1.0
        
        let minAlpha : CGFloat = 0.25
        let maxAlpha : CGFloat = 1.0
        
        return ((maxAlpha - minAlpha) * (x - minScale)) / (maxScale - minScale) + minAlpha
        }
    
    // for custom snap-to paging, when user stop scrolling
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        var indexOfCellWithLargestWidth = 0
        var largestWidth : CGFloat = 1
        
        for cell in self.collectionView.visibleCells {
            if cell.frame.size.width > largestWidth {
                largestWidth = cell.frame.size.width
                if let indexPath = self.collectionView.indexPath(for: cell) {
                    indexOfCellWithLargestWidth = indexPath.item
                }
            }
        }
        
        collectionView.scrollToItem(at: IndexPath(item: indexOfCellWithLargestWidth, section: 0), at: .centeredHorizontally, animated: true)
    }

}

extension homepageVC: CLLocationManagerDelegate {
//    func startLocationUpdates() {
//         locationManager.delegate = self
//         locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
////         locationManager.startUpdatingLocation()
//        
//     }
    
    func checkLocationAuthorization(){
        switch CLLocationManager.authorizationStatus(){
        case .authorizedWhenInUse:
            //do map stuff

            break
        case .denied:
            //show alert instructing them how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            //show an alert letting them know whatsup
            break
        case .authorizedAlways:
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Handle location updates
        if let location = locations.last {
            let userLatitude = location.coordinate.latitude
            let userLongitude = location.coordinate.longitude

            // Use the updated location for your needs
            print("Updated user location - Latitude: \(userLatitude), Longitude: \(userLongitude)")

//            // Call the function with updated location
            fetchBusinessInfo.shared.getClosetFoodRestaurants(latitude: userLatitude, longitude: userLongitude) { response, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                }
                if let response = response {
                    // Handle the Yelp API response (extract business details)
                    for bus in response{
                        self.nameBusinessCloset.append(bus.name!)
                        self.addreessBusinessCloset.append(bus.address!)
                        self.restuarantImageCloset.append(bus.image!)
                        self.ratingsCloset.append(4.0)
                    }
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }

                }

            }

        }
    }

}
