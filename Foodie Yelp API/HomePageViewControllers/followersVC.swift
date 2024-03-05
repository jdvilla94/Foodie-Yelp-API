//
//  followersVC.swift
//  Foodie Yelp API
//
//  Created by JD Villanueva on 1/23/24.
//

import UIKit
import FirebaseStorage

class followersVC: UIViewController {
    
    
    @IBOutlet var tableView: UITableView!
    
    var uidArray: [String] = []
    var currentIndex:Int?
    
    
    @IBOutlet var emptyState: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }

        // Do any additional setup after loading the view.
        authService.shared.getFollowersList { uids, error in
            if let error = error {
                // Handle the error
                print("Error getting friend UIDs: \(error.localizedDescription)")
            } else if let uids = uids {
                // Use the uids array as needed
                print("Friend UIDs: \(uids)")
                self.uidArray = uids
                print("the uidarray count is: \(self.uidArray.count)")
                //this is all it needed to reload the table to show the data
                DispatchQueue.main.async {
                      self.tableView.reloadData()
                  }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as? friendsProfileDetailed
        destVC?.friendsUID = uidArray[currentIndex!]
    }
}


extension followersVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if uidArray.count == 0{
            DispatchQueue.main.async {
                self.emptyState.alpha = 1
                self.tableView.reloadData()
            }
            return uidArray.count
        }else{
            DispatchQueue.main.async {
                self.emptyState.alpha = 0
                self.tableView.reloadData()
            }
            return uidArray.count
        }
//        return uidArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "followersCell", for: indexPath) as! followersCell
        
        authService.shared.getFriend(friendUID: uidArray[indexPath.row]) { [weak self] user, error in
            guard let self = self else { return }
//            print("we got to this step")
            if let error = error {
                print("There was an error in getting user \(error)")
                return
            }
            if let user = user {
                // Download the profile image
//                print("THe user is: \(user) succesffuly upload the user")
                downloadProfileImage(uid: user.userUID) { [weak self] image in
                    guard let self = self else { return }
                        
                    DispatchQueue.main.async {
                        // Set the profileImage with the downloaded image
                        cell.userImage.layer.cornerRadius = 37.5
                        cell.userName.text = user.username
                        cell.userImage.image = image
//                        self.tableView.reloadData()
                        }
                    }

            }
            
        }
        return cell
//        cell.userImage.backgroundColor = .blue
//        cell.userName.text = "It works"
//        return cell
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentIndex = indexPath.row
        performSegue(withIdentifier: "followersToFriendProfile", sender: nil)
    }
    
    
}
