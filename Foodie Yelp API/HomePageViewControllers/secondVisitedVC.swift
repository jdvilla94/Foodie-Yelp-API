//
//  secondVisitedVC.swift
//  Foodie Yelp API
//
//  Created by JD Villanueva on 1/25/24.
//

import UIKit

class secondVisitedVC: UIViewController {

    var reference:String?
    var uid:String?
    
    @IBOutlet var emptyState: UIImageView!
    
    @IBOutlet var collectionView: UICollectionView!
//    @IBOutlet var tableView: UITableView!
//    @IBOutlet var emptyStateImage: UIImageView!
    
    
    var visitedNames: [String] = []
    var visitedNamesImages: [String] = []
    var visitedNamesAddress:[String] = []
    var visitedNamesRating: [Float] = []
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
            self.visitedNames.removeAll()
            self.visitedNamesImages.removeAll()
            self.visitedNamesRating.removeAll()
            self.visitedNamesAddress.removeAll()
            
            
            

//            authService.shared.getVisitedSaved { visited, error in
            authService.shared.getFriendsVisitedSaved(friendsUID: self.uid!) { visited, error in 
                if let error = error {
                    print("Error fetching favorites: \(error.localizedDescription)")
                    return
                }
                // Use the favorites array
                if let visited = visited {
                    for visit in visited {
                        self.visitedNames.append(visit.name!)
                        self.visitedNamesImages.append(visit.image!)
                        self.visitedNamesRating.append(visit.rating!)
                        self.visitedNamesAddress.append(visit.address!)
                    }
                    if self.visitedNames.isEmpty{
//                        self.emptyState.alpha = 1
                    }else{
//                        self.emptyState.alpha = 0
                    }
                    self.collectionView.reloadData()
                }
                
                
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! restaurantInfo
        destVC.name = visitedNames[pathNum!]
        destVC.address = visitedNamesAddress[pathNum!]
        destVC.image = visitedNamesImages[pathNum!]
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

extension secondVisitedVC: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if visitedNames.count == 0{
            DispatchQueue.main.async {
                self.emptyState.alpha = 1
            }
            return visitedNames.count
        }else{
            DispatchQueue.main.async {
                self.emptyState.alpha = 0
            }
            return visitedNames.count
        }
//        return visitedNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "secondVisitedCell", for: indexPath) as! secondVisitedCell
        
        cell.name.text = visitedNames[indexPath.row]
        fetchBusinessInfo.shared.loadImageFromUrl(urlString: visitedNamesImages[indexPath.row]  ) { image in
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

        performSegue(withIdentifier: "secondVIsToRest", sender: nil)
    }
    
}
