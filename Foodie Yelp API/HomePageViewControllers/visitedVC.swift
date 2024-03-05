//
//  visitedVC.swift
//  Foodie Yelp API
//
//  Created by JD Villanueva on 1/7/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class visitedVC: UIViewController {
    
    
    @IBOutlet var collectionView: UICollectionView!
    //    @IBOutlet var tableView: UITableView!
    @IBOutlet var emptyState: UIImageView!
    
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.visitedNames.removeAll()
            self.visitedNamesImages.removeAll()
            self.visitedNamesRating.removeAll()
            self.visitedNamesAddress.removeAll()
            
            
            authService.shared.getVisitedSaved { visited, error in
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
                        self.emptyState.alpha = 1
                    }else{
                        self.emptyState.alpha = 0
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
    


}

extension visitedVC: UICollectionViewDataSource,UICollectionViewDelegate{
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "visitedCell", for: indexPath) as! visitedCell
        
        cell.visitedLabel.text = visitedNames[indexPath.row]
        fetchBusinessInfo.shared.loadImageFromUrl(urlString: visitedNamesImages[indexPath.row]  ) { image in
            if let image = image {
                // Use the image
                DispatchQueue.main.async {
                    // Update your UI with the downloaded image
                    cell.imageVis.image = image
                    cell.imageVis.layer.cornerRadius = 15
                }
            }
            
            
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        pathNum = indexPath.row

        performSegue(withIdentifier: "visistedToRestInfo", sender: nil)
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
}

//extension visitedVC: UITableViewDelegate, UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return visitedNames.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "visitedCell", for: indexPath) as! visitedCell
//        cell.visitedLabel.text = visitedNames[indexPath.row]
//        fetchBusinessInfo.shared.loadImageFromUrl(urlString: visitedNamesImages[indexPath.row]  ) { image in
//            if let image = image {
//                // Use the image
//                DispatchQueue.main.async {
//                    // Update your UI with the downloaded image
//                    cell.imageVis.image = image
//                    cell.imageVis.layer.cornerRadius = 15
//                }
//            }
//            
//            
//        }
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        pathNum = indexPath.row
//
//        performSegue(withIdentifier: "visistedToRestInfo", sender: nil)
//    }
//    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
//        if editingStyle == .delete {
//            // 1. Remove the item from your data source
//            visitedNames.remove(at: indexPath.row)
//            visitedNamesImages.remove(at: indexPath.row)
//            visitedNamesRating.remove(at: indexPath.row)
//            visitedNamesAddress.remove(at: indexPath.row)
//            
//            // 2. Delete the row from the table view
//            tableView.deleteRows(at: [indexPath], with: .fade)
//            //3. func to delete data from database
//            removeVisFromFirebase(index: indexPath.row)
//            if self.visitedNames.isEmpty{
//                self.emptyState.alpha = 1
//            }else{
//                self.emptyState.alpha = 0
//            }
//            
//            
//        }
//    }
//    
//    func removeVisFromFirebase(index: Int) {
//        guard let userUID = Auth.auth().currentUser?.uid else { return }
//        
//        let db = Firestore.firestore()
//        
//        let userDocRef = Firestore.firestore().collection("users").document(userUID)
//
//            // Fetch the existing favorites array from Firestore
//            userDocRef.getDocument { (document, error) in
//                guard let document = document, document.exists else {
//                    print("Document does not exist")
//                    return
//                }
//                //this is the array to get the
//                var visitedArray = document["visited"] as? [[String: Any]] ?? []
//
//                // Check if the index is valid
//                guard index < visitedArray.count else {
//                    print("Invalid index")
//                    return
//                }
//
//                // Remove the element at the specified index
//                visitedArray.remove(at: index)//this removes all field and data at this index
//
//                // Update the favorites array in Firebase
//                userDocRef.updateData([
//                    "visited": visitedArray//replacing the new array and all fields
//                ]) { error in
//                    if let error = error {
//                        print("Error removing element from Firebase: \(error.localizedDescription)")
//                    } else {
//                        print("Element removed successfully from Firebase")
//                    }
//                }
//            }
//        
//        
//    }
//    
//    
//}
