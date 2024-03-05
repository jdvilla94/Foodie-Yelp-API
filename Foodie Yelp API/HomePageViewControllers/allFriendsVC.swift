//
//  allFriendsVC.swift
//  Foodie Yelp API
//
//  Created by JD Villanueva on 1/23/24.
//

import UIKit
import FirebaseStorage

class allFriendsVC: UIViewController {
    
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    var usersData: [nameAndUID] = []
    var uid:String?
    
    var filteredData: [nameAndUID] = []
    var currentIndex:Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self

        // Do any additional setup after loading the view.
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.50)

        self.title = "Find Friends"
        
        authService.shared.getUsernamesAndUIDs { [weak self] user, error in
            guard let self = self else{return}
            if let error = error {
                print("There was an error in getting favFoodandCity\(error)")
                return
            }
            
            if let user = user{
                usersData = user
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }

        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! friendsProfileDetailed
        destVC.friendsUID = uid
    }
    
    func downloadProfileImage(uid: String, completion: @escaping (UIImage?) -> Void) {
        let storage = Storage.storage()
        let storageReference = storage.reference()

        // Construct the path or reference to the file using the UID
        let profileImagePath = "users/\(uid)"  // Use the provided UID instead of the current user's UID
        
        let profileImageReference = storageReference.child(profileImagePath)

        // Download the file to a local URL
        let localURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(uid)

        profileImageReference.write(toFile: localURL) { (url, error) in
            if let error = error {
                // Handle the error
                print("Error downloading profile image: \(error.localizedDescription)")
                completion(nil)
            } else if let localURL = url {
                // Now you can use localURL to access the downloaded file
                print("Profile image downloaded to: \(localURL.absoluteString)")

                // Create a UIImage from the local file URL
                if let profileImage = UIImage(contentsOfFile: localURL.path) {
                    // Return the downloaded image
                    completion(profileImage)
                } else {
                    // Handle the case where creating UIImage from localURL fails
                    print("Failed to create UIImage from local URL")
                    completion(nil)
                }
            }
        }
    }


}

extension allFriendsVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return usersData.count
        return isFiltering() ? filteredData.count : usersData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "allFriendsCell", for: indexPath) as! allFriendsCell

        var user: nameAndUID

        if isFiltering() {
            user = filteredData[indexPath.row]
        } else {
            user = usersData[indexPath.row]
        }

        cell.userNameLabel.text = user.username

        downloadProfileImage(uid: user.uid) { [weak self] image in
            guard let self = self else { return }

            DispatchQueue.main.async {
                cell.profileImage.layer.cornerRadius = 37.5
                cell.profileImage.image = image
            }
        }

        print("The username is: \(user.username), and the UID is: \(user.uid)")

        return cell
//        let cell = tableView.dequeueReusableCell(withIdentifier: "allFriendsCell", for: indexPath) as! allFriendsCell
//        
//        let user = usersData[indexPath.row]
//        cell.userNameLabel.text = user.username
//        
//        downloadProfileImage(uid: user.uid) { [weak self] image in
//            guard let self = self else { return }
//
//            DispatchQueue.main.async {
//                cell.profileImage.layer.cornerRadius = 37.5
//                cell.profileImage.image = image
//            }
//        }
//        
//        print("The usersname is: \(user.username), and the UID is: \(user.uid)")
////        cell.textLabel?.text = "Username: \(user.name), UID: \(user.UID)"
//
//        
//        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let usernames = usersData.map { $0.uid }
        uid = usernames[indexPath.row]
        performSegue(withIdentifier: "allFriendsToFriendsProfile", sender: nil)
    }
    
    func isFiltering() -> Bool {
        return searchBar.isFirstResponder && !searchBar.text!.isEmpty
    }
    
    
}

extension allFriendsVC: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = []

        if searchText.isEmpty {
            filteredData = usersData
        } else {
            filteredData = usersData.filter { $0.username.lowercased().contains(searchText.lowercased()) }
        }

        self.tableView.reloadData()
    }
    

}
