//
//  secondFavoritesVC.swift
//  Foodie Yelp API
//
//  Created by JD Villanueva on 1/25/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class secondFavoritesVC: UIViewController {

    var reference:String?
    var uid:String?
    
    @IBOutlet var emptyState: UIImageView!
    
    @IBOutlet var collectionView: UICollectionView!
//    @IBOutlet var tableView: UITableView!
//    @IBOutlet var emptyStateImage: UIImageView!
    
    
    var favoriteNames: [String] = []
    var favoriteImages: [String] = []
    var favoriteAddress:[String] = []
    var favoriteRating: [Float] = []
    var pathNum:Int?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        // Do any additional setup after loading the view.

        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.50)
//        print("the uid currently is: \(uid)")
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.favoriteNames.removeAll()
            self.favoriteImages.removeAll()
            self.favoriteRating.removeAll()
            self.favoriteAddress.removeAll()
            
            
            
//            authService.shared.getFavoritesSaved { favorites, error in
            authService.shared.getFriendsFavoritesSaved(friendsUID: self.uid!) { favorites, error in
                if let error = error {
                    print("Error fetching favorites: \(error.localizedDescription)")
                    return
                }
                // Use the favorites array
                if let favorites = favorites {
                    for favorite in favorites {
                        self.favoriteNames.append(favorite.name!)
                        self.favoriteImages.append(favorite.image!)
                        self.favoriteRating.append(favorite.rating!)
                        self.favoriteAddress.append(favorite.address!)
                    }
                    if self.favoriteNames.isEmpty{
//                        self.emptyStateImage.alpha = 1
                    }else{
//                        self.emptyStateImage.alpha = 0
                    }
//                    self.tableView.reloadData()
                    self.collectionView.reloadData()
                }
                

            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! restaurantInfo
        destVC.name = favoriteNames[pathNum!]
        destVC.address = favoriteAddress[pathNum!]
        destVC.image = favoriteImages[pathNum!]
        destVC.rating = 4.0
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Handle search button click here
        if let searchText = searchBar.text {
            print("Search text: \(searchText)")
            // Perform search or other actions as needed
        }

        // Dismiss the keyboard
        searchBar.resignFirstResponder()
    }

    

}

extension secondFavoritesVC: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if favoriteNames.count == 0{
            DispatchQueue.main.async {
                self.emptyState.alpha = 1
            }
            return favoriteNames.count
        }else{
            DispatchQueue.main.async {
                self.emptyState.alpha = 0
            }
            return favoriteNames.count
        }
//        return favoriteNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "secondFavoritesCell", for: indexPath) as! secondFavoritesCell
        
        cell.name.text = favoriteNames[indexPath.row]
        fetchBusinessInfo.shared.loadImageFromUrl(urlString: favoriteImages[indexPath.row]  ) { image in
            if let image = image {
                // Use the image
                DispatchQueue.main.async {
                    // Update your UI with the downloaded image
                    cell.imageForFav.image = image
                    cell.imageForFav.layer.cornerRadius = 15
                }
            }
            
            
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        pathNum = indexPath.row

        performSegue(withIdentifier: "secondFavToRest", sender: nil)
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



