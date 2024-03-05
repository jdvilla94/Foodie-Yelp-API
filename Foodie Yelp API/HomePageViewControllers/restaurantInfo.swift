//
//  restaurantInfo.swift
//  Foodie Yelp API
//
//  Created by JD Villanueva on 11/13/23.
//

import UIKit
import MapKit
import FirebaseAuth
import FirebaseFirestore

class restaurantInfo: UIViewController {
    
    
    var name:String?
    var address:String?
    var image: String?
    var rating: Float?
    let locationManager = CLLocationManager()
    var lat: Double?
    var long: Double?
    
    let regionRadius: CLLocationDistance = 1000
    
    
    @IBOutlet var heart: UIButton!
    var heartActive = false
    
   
    @IBOutlet var visited: UIButton!
    var visitedActive = false
    
    @IBOutlet var viewForInteractiveButtons: UIView!
    
    
    @IBOutlet var restaurantImage: UIImageView!
//    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var map: MKMapView!
    @IBOutlet var addressLabel: UILabel!
    
    
    @IBOutlet var oneStar: UIImageView!
    @IBOutlet var twoStar: UIImageView!
    @IBOutlet var threeStar: UIImageView!
    @IBOutlet var fourStar: UIImageView!
    @IBOutlet var fiveStar: UIImageView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        addInfoToVC()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.viewForInteractiveButtons.layer.cornerRadius = 20
            authService.shared.getFavoritesSaved { favorites, error in
                if let error = error {
                    print("Error fetching favorites: \(error.localizedDescription)")
                    return
                }
                // Use the favorites array
                if let favorites = favorites {
                    for favorite in favorites {
                        if self.name == favorite.name{
                            self.heart.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                            self.heartActive = true
                        }
                    }
                    
                }
                

            }
            authService.shared.getVisitedSaved { visited, error in
                if let error = error{
                    print("Error fetching favorites: \(error.localizedDescription)")
                    return
                }
                
                //use the visited array
                if let visited = visited {
                    for (index,visy) in visited.enumerated(){
                        if self.name == visy.name{
                            self.visited.setImage(UIImage(systemName: "location.fill"), for: .normal)
                            self.visitedActive = true
                            
                        }
                    }
                }
            }
        }

        
    }
    

    
    func addInfoToVC(){
        restaurantImage.layer.cornerRadius = 15
        fetchBusinessInfo.shared.loadImageFromUrl(urlString: image!) { image in
            if let image = image {
                // Use the image
                DispatchQueue.main.async {
                    // Update your UI with the downloaded image
                    // imageView.image = image
                    self.restaurantImage.image = image
                }
            }
        }
        
        self.navigationItem.title = name
//        nameLabel.text = name
        ratingLabel.text = "\(rating!)"
        addressLabel.text = address
        map.layer.cornerRadius = 15
        
        if rating! < 2{
            oneStar.alpha = 1
        }else if rating! < 3{
            oneStar.alpha = 1
            twoStar.alpha = 1
        }else if rating! < 4{
            oneStar.alpha = 1
            twoStar.alpha = 1
            threeStar.alpha = 1
        }else if rating! < 5 {
            oneStar.alpha = 1
            twoStar.alpha = 1
            threeStar.alpha = 1
            fourStar.alpha = 1
        }else{
            oneStar.alpha = 1
            twoStar.alpha = 1
            threeStar.alpha = 1
            fourStar.alpha = 1
            fiveStar.alpha = 1
        }
    }
    
    @IBAction func directionsTapped(_ sender: UIButton) {
        displayAddressOnMap(location: CLLocation(latitude: lat!, longitude: long!))
    }
    
    @IBAction func heartTapped(_ sender: UIButton) {
        if heartActive == false {
            sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            heartActive = true
            let favorites = favoritesSaved(name: name, address: address, image: image, rating: rating, lat: lat, long: long)
            
            let topTen = topTenSaved(name: name, address: address, image: image, rating: rating, lat: lat, long: long)

            authService.shared.setFavoritesSaved(favorites) { error in
                if let error = error {
                    print("Error setting favorites: \(error.localizedDescription)")
                } else {
                    print("Favorites set successfully.")
                }
            }
                                
        } else {
            DispatchQueue.main.async {
                authService.shared.getFavoritesSaved { favorites, error in
                    if let error = error{
                        print("Error fetching favorites: \(error.localizedDescription)")
                        return
                    }
                    if let favorites = favorites {
                        for (index,favorite) in favorites.enumerated(){
                            if self.name == favorite.name{
                                self.removeFavsFromFirebase(index: index)
                                
                            }
                        }
                    }
                }
            }

            sender.setImage(UIImage(systemName: "heart"), for: .normal)
            heartActive = false
        }
    }
    
    
    
    @IBAction func visitedTapped(_ sender: UIButton) {
        if visitedActive == false {
            sender.setImage(UIImage(systemName: "location.fill"), for: .normal)
            visitedActive = true
            let visited = visitedSaved(name: name, address: address, image: image, rating: rating, lat: lat, long: long)
            
            authService.shared.setVisitedSaved(visited) { error in
                if let error = error {
                    print("Error setting favorites: \(error.localizedDescription)")
                } else {
                    print("Favorites set successfully.")
                }
            }
        } else {
            DispatchQueue.main.async {
                authService.shared.getVisitedSaved { visited, error in
                    if let error = error{
                        print("Error fetching favorites: \(error.localizedDescription)")
                        return
                    }
                    
                    //use the visited array
                    if let visited = visited {
                        for (index,visy) in visited.enumerated(){
                            if self.name == visy.name{
                                self.removeVisFromFirebase(index: index)
                                
                            }
                        }
                    }
                }
            }

            sender.setImage(UIImage(systemName: "location"), for: .normal)
            visitedActive = false
        }
    }
    
    func removeVisFromFirebase(index: Int) {
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        
        let userDocRef = Firestore.firestore().collection("users").document(userUID)

            // Fetch the existing favorites array from Firestore
            userDocRef.getDocument { (document, error) in
                guard let document = document, document.exists else {
                    print("Document does not exist")
                    return
                }
                //this is the array to get the
                var visitedArray = document["visited"] as? [[String: Any]] ?? []

                // Check if the index is valid
                guard index < visitedArray.count else {
                    print("Invalid index")
                    return
                }

                // Remove the element at the specified index
                visitedArray.remove(at: index)//this removes all field and data at this index

                // Update the favorites array in Firebase
                userDocRef.updateData([
                    "visited": visitedArray//replacing the new array and all fields
                ]) { error in
                    if let error = error {
                        print("Error removing element from Firebase: \(error.localizedDescription)")
                    } else {
                        print("Element removed successfully from Firebase")
                    }
                }
            }
        
    }
    
    func removeFavsFromFirebase(index: Int) {
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        
        let userDocRef = Firestore.firestore().collection("users").document(userUID)

            // Fetch the existing favorites array from Firestore
            userDocRef.getDocument { (document, error) in
                guard let document = document, document.exists else {
                    print("Document does not exist")
                    return
                }
                //this is the array to get the
                var favoritesArray = document["favorites"] as? [[String: Any]] ?? []

                // Check if the index is valid
                guard index < favoritesArray.count else {
                    print("Invalid index")
                    return
                }

                // Remove the element at the specified index
                favoritesArray.remove(at: index)//this removes all field and data at this index

                // Update the favorites array in Firebase
                userDocRef.updateData([
                    "favorites": favoritesArray//replacing the new array and all fields
                ]) { error in
                    if let error = error {
                        print("Error removing element from Firebase: \(error.localizedDescription)")
                    } else {
                        print("Element removed successfully from Firebase")
                    }
                }
            }
        
        
    }
    
    
    

    
    
    
}


extension restaurantInfo: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            //handle updated location
            print("Location is \(location.coordinate.latitude), and \(location.coordinate.longitude)")
            geocodeAddress(address!) { coordinates, error in
                if let coordinates = coordinates {
                    // Save or use the coordinates here
//                    print("Received coordinates: \(coordinates.latitude), \(coordinates.longitude)")
                    self.lat = coordinates.latitude
                    self.long = coordinates.longitude
                    self.addPinToMap(location: CLLocation(latitude: self.lat!, longitude: self.long!))
                    self.centerMapOnLocation(location: CLLocation(latitude: self.lat!, longitude: self.long!))
                } else {
                    print("Unable to retrieve coordinates.")
                }
            }
//
        }
        locationManager.stopUpdatingLocation()
    }
    
    func addPinToMap(location:CLLocation){
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        annotation.title = name
        map.addAnnotation(annotation)
    }
    
    func centerMapOnLocation(location: CLLocation){
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        map.setRegion(coordinateRegion, animated: true)
    }
    
    func geocodeAddress(_ address: String,completion: @escaping(CLLocationCoordinate2D?,Error?)-> Void){
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address) {placemarks, error in
            if let error = error {
                   print("Geocoding error: \(error.localizedDescription)")
                   completion(nil, error)
                   return
               }

               if let placemark = placemarks?.first {
                   // Access the coordinates
                   if let coordinates = placemark.location?.coordinate {
                       print("Coordinates are: \(coordinates.latitude), \(coordinates.longitude)")
                       completion(coordinates, nil)
                   } else {
                       // Handle the case where coordinates are not available
                       completion(nil, nil)
                   }
               } else {
                   // Handle the case where no placemarks are found
                   completion(nil, nil)
               }
        }
    }
    
    

    func displayAddressOnMap(location: CLLocation){
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) {(placemarks, error) in
            if let error = error {
                print("Reverse geocoding error: \(error.localizedDescription)")
                return
            }
            
            if let placemark = placemarks?.first{
                //use placemark data to display address on the map
                let mapItem = MKMapItem(placemark: MKPlacemark(placemark: placemark))
                self.showMapItem(mapItem)
            }
        }
    }
    
    func showMapItem(_ mapItem: MKMapItem){
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        mapItem.openInMaps(launchOptions: launchOptions)
    }
}
