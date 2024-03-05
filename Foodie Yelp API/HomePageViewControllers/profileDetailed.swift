//
//  profileDetailed.swift
//  Foodie Yelp API
//
//  Created by JD Villanueva on 11/30/23.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import Lottie

class profileDetailed: UIViewController {
    
    var username:String?
    var referenceString:String?
    
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var usernameLabel: UILabel!
    
    @IBOutlet var favoritesView: UIView!
    @IBOutlet var visitedView: UIView!
    
    var name:String?
    var address:String?
    var image:String?
    var rating:Float?
    
    var selectionIndicator: UIView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    
    
    @IBOutlet var followersLabel: UILabel!
    @IBOutlet var followingLabel: UILabel!
    
    
    
    //    @IBOutlet var vistiedLabel: UILabel!
//    @IBOutlet var favoriteLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.50)
        

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        updateUI()
        
        authService.shared.getFriendRequestsCount { count, error in
            if let error = error {
                // Handle the error
                print("Error getting friend requests count: \(error.localizedDescription)")
            } else {
                print("Number of friend requests: \(count)")
                DispatchQueue.main.async {
                    self.followingLabel.text = String(count)
                }
            }
        }
        
        authService.shared.getFollowerCount { count, error in
            if let error = error {
                // Handle the error
                print("Error getting friend requests count: \(error.localizedDescription)")
            } else {
                print("Number of friend requests: \(count)")
                DispatchQueue.main.async {
                    self.followersLabel.text = String(count)
                }
            }
        }

        
        authService.shared.getUser { [weak self] user, error in
            guard let self = self else { return }
            if let error = error {
                print("There was an error in getting user \(error)")
                return
            }
            if let user = user {
                if profileImage.image == nil{
                    let animationView = LottieAnimationView(name: "Loading")
                    animationView.frame = profileImage.bounds
                    animationView.contentMode = .scaleAspectFit
                    animationView.loopMode = .playOnce // Set the loop mode as needed
//                    animationView.animationSpeed =
                    animationView.play()

                    // Add the AnimationView as a subview to your UIImageView
                    profileImage.addSubview(animationView)
//                    usernameLabel.addSubview(animationView)

                    // Download the profile image
                    downloadProfileImage(uid: user.userUID) { [weak self] image in
                        guard let self = self else { return }

                        DispatchQueue.main.async {
                            // Remove the animationView from the profileImage
                            animationView.removeFromSuperview()

                            // Set the profileImage with the downloaded image
                            self.profileImage.image = image
                            self.usernameLabel.text = user.username
                        }
                    }
                } else {
                    // If the profile image is already loaded, update the UI directly
                    downloadProfileImage(uid: user.userUID) { [weak self] image in
                        guard let self = self else { return }

                        DispatchQueue.main.async {
                            self.profileImage.image = image
                            self.usernameLabel.text = user.username
                        }
                    }
                }
            }

        }

        
        
        authService.shared.getFavoritesSaved { favorites, error in
            if let error = error {
                print("Error fetching favorites: \(error.localizedDescription)")
                return
            }
            // Use the favorites array
            DispatchQueue.main.async {
//                self.favoriteLabel.text = String(favorites!.count)
            }
        }
        
        authService.shared.getVisitedSaved { visited, error in
            if let error = error{
                print("Error fetching favorites: \(error.localizedDescription)")
                return
            }
            DispatchQueue.main.async {
//                self.vistiedLabel.text = String(visited!.count)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if referenceString == "followers"{
            let desVC = segue.destination as? followersAndFollwingVC
            desVC?.refString = referenceString
        }else{
            let desVC = segue.destination as? followersAndFollwingVC
            desVC?.refString = referenceString
        }
        
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



    
//    func downloadProfileImage(uid: String, completion: @escaping (UIImage?) -> Void) {
//        let storage = Storage.storage()
//        let storageReference = storage.reference()
//
//        // Construct the path or reference to the file using the UID
//        let profileImagePath = "users/\(Auth.auth().currentUser!.uid)"
//        
//        let profileImageReference = storageReference.child(profileImagePath)
//
//        // Download the file to a local URL
//        let localURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(uid)
//
//        profileImageReference.write(toFile: localURL) { (url, error) in
//            if let error = error {
//                // Handle the error
//                print("Error downloading profile image: \(error.localizedDescription)")
//                completion(nil)
//            } else if let localURL = url {
//                // Now you can use localURL to access the downloaded file
//                print("Profile image downloaded to: \(localURL.absoluteString)")
//
//                // Create a UIImage from the local file URL
//                if let profileImage = UIImage(contentsOfFile: localURL.path) {
//                    // Return the downloaded image
//                    completion(profileImage)
//                } else {
//                    // Handle the case where creating UIImage from localURL fails
//                    print("Failed to create UIImage from local URL")
//                    completion(nil)
//                }
//            }
//        }
//    }
    
    func updateUI(){
        
        DispatchQueue.main.async {
            self.followersLabel.isUserInteractionEnabled = true
            let follwingGesture = UITapGestureRecognizer(target: self, action: #selector(self.followersTapped))
            self.followersLabel.addGestureRecognizer(follwingGesture)
            
            self.followingLabel.isUserInteractionEnabled = true
            let followersGesture = UITapGestureRecognizer(target: self, action: #selector(self.followingTapped))
            self.followingLabel.addGestureRecognizer(followersGesture)
            
            // Make the segmented control transparent
            self.segmentedControl.backgroundColor = UIColor.clear

            // Set the background images for normal and selected states to be transparent
            self.segmentedControl.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
            self.segmentedControl.setBackgroundImage(UIImage(), for: .selected, barMetrics: .default)

//            // Set the text attributes for normal and selected states
//            self.segmentedControl.setTitleTextAttributes([
//                NSAttributedString.Key.font: UIFont(name: "Verdana", size: 20) ?? UIFont.systemFont(ofSize: 18),
//                NSAttributedString.Key.foregroundColor: UIColor.lightGray
//            ], for: .normal)

            self.segmentedControl.setTitleTextAttributes([
                NSAttributedString.Key.font: UIFont(name: "Verdana", size: 20) ?? UIFont.systemFont(ofSize: 18),
                NSAttributedString.Key.foregroundColor: UIColor.black
            ], for: .selected)
            
            // Remove the divider image
            self.segmentedControl.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
            
//            // Create and configure the selection indicator view
//            self.selectionIndicator = UIView()
//            self.selectionIndicator.backgroundColor = UIColor.systemRed
//            self.view.addSubview(self.selectionIndicator)
            
            // Check if the selectionIndicator already exists in the view hierarchy
             if self.selectionIndicator == nil {
                 // Create and configure the selection indicator view
                 self.selectionIndicator = UIView()
                 self.selectionIndicator.backgroundColor = UIColor.systemRed
                 self.view.addSubview(self.selectionIndicator)
                 //             Initially position the indicator under the first segment
                 self.updateSelectionIndicatorPosition(forSegment: 0)
                 self.segmentedControl.setImage(UIImage(systemName: "heart.fill"), forSegmentAt: 0)
             }
            
////             Initially position the indicator under the first segment
//            self.updateSelectionIndicatorPosition(forSegment: 0)
        }

        profileImage.layer.cornerRadius = profileImage.bounds.width / 2.0
        profileImage.clipsToBounds = true
        

        
    }
    @objc func followersTapped(){
//        print("we tapped that")
        referenceString = "followers"
        performSegue(withIdentifier: "profileToFF", sender: nil)
    }
    
    @objc func followingTapped(){
//        print("we tapped that")
        referenceString = "following"
        performSegue(withIdentifier: "profileToFF", sender: nil)
    }
    
    @IBAction func segmentTab(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            favoritesView.alpha = 1
            visitedView.alpha = 0
            segmentedControl.setImage(UIImage(systemName: "heart.fill"), forSegmentAt: 0)
            segmentedControl.setImage(UIImage(systemName: "location"), forSegmentAt: 1)
            updateSelectionIndicatorPosition(forSegment: sender.selectedSegmentIndex)
            
        } else if sender.selectedSegmentIndex == 1{
            favoritesView.alpha = 0
            visitedView.alpha = 1
            segmentedControl.setImage(UIImage(systemName: "heart"), forSegmentAt: 0)
            segmentedControl.setImage(UIImage(systemName: "location.fill"), forSegmentAt: 1)
            updateSelectionIndicatorPosition(forSegment: sender.selectedSegmentIndex)
        }
    }
    
    func updateSelectionIndicatorPosition(forSegment segment: Int) {
        // Calculate the width of each segment
        let segmentWidth = segmentedControl.frame.width / CGFloat(segmentedControl.numberOfSegments)

        // Calculate the desired width of the indicator (3/4 of the segment width)
        let indicatorWidth = segmentWidth * 0.75

        // Calculate the padding needed to center the indicator within the segment
        let padding = (segmentWidth - indicatorWidth) / 2

        // Calculate the position of the selection indicator
        let xPosition = segmentedControl.frame.origin.x + CGFloat(segment) * segmentWidth + padding

        // Set the frame of the selection indicator
        selectionIndicator.frame = CGRect(x: xPosition, y: segmentedControl.frame.maxY - 2, width: indicatorWidth, height: 2)
    }
    
//    func updateSelectionIndicatorPosition(forSegment segment: Int) {
//        // Calculate the width of each segment
//        let segmentWidth = segmentedControl.frame.width / CGFloat(segmentedControl.numberOfSegments)
//
//        // Calculate the position of the selection indicator
//        let xPosition = segmentedControl.frame.origin.x + CGFloat(segment) * segmentWidth
//
//        // Set the frame of the selection indicator
//        selectionIndicator.frame = CGRect(x: xPosition, y: segmentedControl.frame.maxY - 2, width: segmentWidth, height: 2)
//    }

    
    
}



//add a shadow to the view
//        updatedView.layer.shadowColor = UIColor.black.cgColor
//        updatedView.layer.shadowOpacity = 0.5
//        updatedView.layer.shadowOffset = CGSize(width: 0, height: 2)
//        updatedView.layer.shadowRadius = 4
//        updatedView.layer.masksToBounds = false
//        updatedView.layer.cornerRadius = 15
//        updatedView.layer.borderColor = UIColor.lightGray.cgColor

//add a tap gesture to the labels
//        usernameLabel.text = username
        //add tap gesture to favorites label
//        favoriteLabel.isUserInteractionEnabled = true
//        vistiedLabel.isUserInteractionEnabled = true
//        let favoritesGesture = UITapGestureRecognizer(target: self, action: #selector(favoritesTapped))
//        let visitedGesture = UITapGestureRecognizer(target: self, action: #selector(visitedTapped))
//        favoriteLabel.addGestureRecognizer(favoritesGesture)
//        vistiedLabel.addGestureRecognizer(visitedGesture)
