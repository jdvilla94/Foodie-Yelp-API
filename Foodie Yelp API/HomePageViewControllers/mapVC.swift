//
//  mapVC.swift
//  Foodie Yelp API
//
//  Created by JD Villanueva on 11/6/23.
//

import UIKit
import MapKit
import CoreLocation

class mapVC: UIViewController {
    
    var city:String?
    var food:String?
    var neighborhood: String?
    var neighborhoodCoordinate: CLLocationCoordinate2D?
    var cityNameButton = UILabel()
    var reference:String?
    
    var foodSelected:String?
    
    @IBOutlet var viewForContainer: UIView!
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    var containerVisible = false
    
    var selectedPinIndex = 0
    // Dictionary to store the index for each name
    var nameToIndexMap: [String: Int] = [:]
    var coordToIndexMap: [Int : CLLocationCoordinate2D] = [:]
    var addressToIndexMap: [String:Int] = [:]
    var names:String?
    var address:String?
    var images:String?
    var rating:Float?
    
    var foodEmojiArray: [String:UIImage] = FoodEmojis.allFoods
    var foodCorrectArray: [String] = []
    
    var businesses: [Business] = []
    var nameBusiness: [String] = []
    var addreessBusiness: [String] = []
    var restuarantImage: [String] = []
    var ratings: [Float] = []
    
    @IBOutlet var map: MKMapView!
    let locationManger = CLLocationManager()
    let regionInMeters:Double = 7000
    
    var mapAnnotations: [MKAnnotation] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        checkLocationServices()
        popupCardViewTapped()
        
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.50)
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
                    // Create a UILabel
                    cityNameButton.font = UIFont(name: "Verdana-Bold", size: 18)
                    cityNameButton.text = "\(self.city!) 🏙️"
                    cityNameButton.isUserInteractionEnabled = true
                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cityTitleTapped))
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
        
        
    }
    
    
    func callAPI(){    
        nameBusiness = []
        addreessBusiness = []
        restuarantImage = []
        ratings = []
        
       
        
        fetchBusinessInfo.shared.getBuisnessData(location: city!, category: foodSelected!, limit: 20, sortBy: "rating", locale: "en_US") { [self] (response, error) in
//            print("THE RESPONSE IS \(String(describing: response))")
            // Clear the contents of the nameToIndexMap dictionary before fetching new data
            nameToIndexMap.removeAll()
            if let response = response {
                for business in response{
                    self.nameBusiness.append(business.name!)
                    self.addreessBusiness.append(business.address!)
                    self.restuarantImage.append(business.image!)
                    self.ratings.append(business.rating!)
                }
                for (index,business) in self.addreessBusiness.enumerated(){
                    let pin = MKPointAnnotation()
                    self.mapAnnotations.append(pin)
                    nameToIndexMap[nameBusiness[index]] = index
                    addressToIndexMap[addreessBusiness[index]] = index
                    pin.title = nameBusiness[index]
                    self.geocodeAddress(business) { coordinates, error in
                        if let coordinates = coordinates {
                            // Save or use the coordinates here
                            pin.coordinate = coordinates
                            self.coordToIndexMap[index] = coordinates
//                            print("The coordinates are: \(coordinates)")
//                            pin.subtitle = name
                            self.map.addAnnotation(pin)
                            print("WE HAVE SUCCES")
                        } else {
                            print("Unable to retrieve coordinates.")
                        }
                        
                    }
              

                }

                

                
                

            }else{
                print("The error is \(String(describing: error))")
            }
        }
    }
    


    func setUpLocationManager(){
        locationManger.delegate = self
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
    }

    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            //setup our location manger
            setUpLocationManager()
            checkLocationAuthorization()
        }else{
            //show error lettting teh user know they have to turn this on
        }
    }
    
    func centerViewOnUserLocation(){

        if let location = locationManger.location?.coordinate{
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            map.setRegion(region, animated: true)
        }

    }
    
    func checkLocationAuthorization(){
        switch CLLocationManager.authorizationStatus(){
        case .authorizedWhenInUse:
            //do map stuff
            map.showsUserLocation = true
            centerViewOnUserLocation()
            locationManger.startUpdatingLocation()
            break
        case .denied:
            //show alert instructing them how to turn on permissions
            break
        case .notDetermined:
            locationManger.requestWhenInUseAuthorization()
        case .restricted:
            //show an alert letting them know whatsup
            break
        case .authorizedAlways:
            break
        default:
            break
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if neighborhood != nil{
            print("THE NEIGHTBORHOOD IS: \(neighborhood!)")
            cityNameButton.text = "\(self.neighborhood!) 🏙️"
            print("THE NEIGHBORHOOD COORDINATES ARE: \(neighborhoodCoordinate!)")
            let region = MKCoordinateRegion(center: neighborhoodCoordinate!, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            map.setRegion(region, animated: true)
        }else{
            centerViewOnUserLocation()
        }
    }
    
    // Function to handle label tap
    @objc func cityTitleTapped() {
        print("Title label tapped!")
        // Add your desired action here
        performSegue(withIdentifier: "mapToNeighborhoodVC", sender: nil)
    }
    
    func sendData(name:String, imageString: String,address:String){
        let vc = children.first as! popUpCard
        vc.changeContainerData(name: name,imageString: imageString,address: address)
    }
  
    func addSlideGestureToContainer(){
        let slideGesture = UISwipeGestureRecognizer(target: self, action: #selector(popupSlider))
        slideGesture.direction = .down
//        viewForContainer.isUserInteractionEnabled = true
        viewForContainer.addGestureRecognizer(slideGesture)
    }
    func popupCardViewTapped(){
        viewForContainer.isUserInteractionEnabled = true
        let tapGeseture = UITapGestureRecognizer(target: self, action: #selector(popupCardTapped))
        viewForContainer.addGestureRecognizer(tapGeseture)
    }
    
    @objc func popupCardTapped(){
        performSegue(withIdentifier: "popupMapToRestInfo", sender: nil)
        print("WE TAPPED THE POPUPCARD")

    }
        
    @objc func popupSlider(fromViewController: UIViewController){
        if(containerVisible){
            UIView.animate(withDuration: 0.5,animations:  {
                //hide the menu to the bottom
                self.bottomConstraint.constant = 0 - self.viewForContainer.frame.size.width
                //move the view to original position
//                self.bottomConstraint.constant = 0
                self.view.layoutIfNeeded()
            }, completion: { _ in
                // Reset the container visibility flag
                self.containerVisible = false
            })
        }else{
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.5, animations: {
                //move the bottom card back up to show it
                self.bottomConstraint.constant = 25
                self.view.layoutIfNeeded()
            }, completion: { _ in
                // Reset the container visibility flag
                self.containerVisible = true
            })
        }
        print("The popupslider was tapped")
        containerVisible = !containerVisible
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapToNeighborhoodVC"{
            let destVC = segue.destination as? changeNeighborhoodsVC
            destVC?.reference = "map"
            destVC?.city = city
        }else if segue.identifier == "mapToSearchVC"{
            let destVC = segue.destination as? searchController
            destVC?.reference = "map"
            destVC?.city = city
            destVC?.food = food
        }else if segue.identifier == "popupMapToRestInfo"{
            let destVC = segue.destination as? restaurantInfo
            destVC?.name = names
            destVC?.address = address
            destVC?.image = images
            destVC?.rating = rating
        }
//
//        }
        
    }
       
    
    @IBAction func unwindToMap(_ sender: UIStoryboardSegue){}
    
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
    

    
    
    
}

extension mapVC: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //if there is no locations in array
        guard let location = locations.last else {return}
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        map.setRegion(region, animated: true)

    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}

extension mapVC: MKMapViewDelegate{
    //responsbile for resuning the view, map is smart enough to cachec and deque the pins
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else{
            return nil
        }
        
        var annotionView = map.dequeueReusableAnnotationView(withIdentifier: "custom")
        if annotionView == nil{
            //create the view
            annotionView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
//            annotionView?.canShowCallout = true
            //            foodImage.isUserInteractionEnabled = true
            //            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(popupSlider))
            //            annotionView?.addGestureRecognizer(tapGesture)
            //            annotionView?.rightCalloutAccessoryView
            // Add a custom info button to the callout
//            let infoButton = UIButton(type: .detailDisclosure)
//            annotionView?.rightCalloutAccessoryView = infoButton
        }else{
            annotionView?.annotation = annotation
        }
        
        
//        annotionView?.image = UIImage(systemName: "mappin")
//        annotionView?.image = UIImage(resource: .addressPin)
         var pinImage = UIImage(resource: .addressPin)
         var resizedImage = pinImage.resized(to: CGSize(width: 40, height: 40))

         annotionView?.image = resizedImage
        

        
        return annotionView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("We tapped this pin")
        print(nameToIndexMap)
        print(addressToIndexMap)
        if let pinTitle = view.annotation?.title as? String {
            // Retrieve the index using the stored dictionary
            if let selectedPinIndex = nameToIndexMap[pinTitle] {
                // Store the selected index for later
                print("The address is: \(addreessBusiness[selectedPinIndex])")
                self.selectedPinIndex = selectedPinIndex
                self.sendData(name: nameBusiness[selectedPinIndex], imageString: restuarantImage[selectedPinIndex],address: addreessBusiness[selectedPinIndex])
                self.names = nameBusiness[selectedPinIndex]
                self.address = addreessBusiness[selectedPinIndex]
                self.images = restuarantImage[selectedPinIndex]
                self.rating = 4.0
                if containerVisible == false{
                    popupSlider(fromViewController: self)
                    addSlideGestureToContainer()
                    //                }
                    print("Selected pin index is: \(selectedPinIndex)")
                    
                }
                
                if let pinImage = view.image {
                    var resizedImage = pinImage.resized(to: CGSize(width: 80, height: 80))// Adjust the hue value as needed
                     view.image = resizedImage
                 }
            }
            
        }
        
        
        
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if let pinImage = view.image {
            var resizedImage = pinImage.resized(to: CGSize(width: 40, height: 40))// Adjust the hue value as needed
             view.image = resizedImage
         }
    }
}

extension mapVC: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foodEmojiArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "foodSlider", for: indexPath) as! foodSlider
        let valuesArray = foodEmojiArray.values.map { $0 }
        let keysArray = foodEmojiArray.keys.map { $0 }
        let values = valuesArray[indexPath.row]
        let keys = keysArray[indexPath.row]
        foodCorrectArray = keysArray
        cell.foodimage.image = values
        
        if keys == "chicken_wings" {
            // Replace the text with the new text
            cell.foodLabel.text = "wings"
        } else if keys == "pastashops"{
            cell.foodLabel.text = keys
        }else{
            cell.foodLabel.text = keys
        }
//        cell.foodLabel.text = keys
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        foodSelected = foodCorrectArray[indexPath.row]
        DispatchQueue.main.async {
            self.map.removeAnnotations(self.mapAnnotations)
            self.mapAnnotations.removeAll()
            self.callAPI()
            print("The map annotaion array is: \(self.mapAnnotations)")
        }

        
    }

}

extension UIImage {
    func resized(to newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: newSize))
        return UIGraphicsGetImageFromCurrentImageContext() ?? self
    }
}
