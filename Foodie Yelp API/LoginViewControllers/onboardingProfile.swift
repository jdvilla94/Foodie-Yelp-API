//
//  onboardingProfile.swift
//  Foodie Yelp API
//
//  Created by JD Villanueva on 11/5/23.
//

import UIKit
import FirebaseStorage
import FirebaseAuth

class onboardingProfile: UIViewController {
    
    
    @IBOutlet var usernameTF: UITextField!
    @IBOutlet var emailTF: UITextField!
    @IBOutlet var passwordTF: UITextField!
    @IBOutlet var submitButton: UIButton!
    @IBOutlet var profileImage: UIImageView!
    
    
    var city: String?
    var food: String?
    var imageUrl: String?
    var image: UIImage?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        
//        self.navigationItem.backBarButtonItem?.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.50)
//        print("THE UID OF THE USER IS: \(user)")
        profileImage.layer.cornerRadius = 60
        profileImage.clipsToBounds = true
        profileImage.layer.borderWidth = 2.0
        profileImage.layer.borderColor = UIColor.white.cgColor
        
        submitButton.layer.cornerRadius = 15
        print("THE CITY IS: \(city!)")
        print("THE FOOD IS: \(food!)")
        profileTapped()
    }
    

    
    
    
    @IBAction func submitTapped(_ sender: UIButton) {
        
        guard let imageUrl = imageUrl else {
            print("Error: imageUrl is nil")
            return
        }
        
        let registerUserRequest = registerUserRequest(username: self.usernameTF.text ?? "",
                                                      email: self.emailTF.text ?? "",
                                                      password: self.passwordTF.text ?? "",
                                                      favFood: food!,
                                                      favCity: city!,
                                                      profileImage: imageUrl,
                                                      favorites: []
                                                        )
        
        //check username
        if !validator.isValidUsername(for: registerUserRequest.username){
            AlertCenter.showInvalidUsernameAlert(on: self)
            print("invalid user")
            return
        }
        
        //check email
        if !validator.isValidEmail(for: registerUserRequest.email){
            AlertCenter.showInvalidEmailAlert(on: self)
            print("invalid email")
            return
        }
        
        //check password
        if !validator.isPasswordValid(for: registerUserRequest.password){
            AlertCenter.showInvalidPasswordAlert(on: self)
            print("invalid passsword")
            return
        }
        
        DispatchQueue.main.async {
            // User is already authenticated, proceed with registration and image upload
            authService.shared.registerUser(with: registerUserRequest) { [weak self] wasRegistered, error in
                guard let self = self else {return}//stops retain cycles
                    
                if let error = error {
                    AlertCenter.showRegistrationErrorAlert(on: self, with: error)
                    print("couldnt log you into firestore")
                    return
                }
                if wasRegistered {
                    // User successfully registered, handle authentication
                    Auth.auth().signIn(withEmail: registerUserRequest.email, password: registerUserRequest.password) { _, signInError in
                        if let signInError = signInError {
                            // Handle sign-in error
                            print("Error signing in after registration: \(signInError.localizedDescription)")
                        } else {
                            // User is authenticated, proceed with image upload
                            self.uploadProfileImage()
                        }
                    }
                } else {
                    // Handle registration error
                    print("Error registering user: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }

    }
    
    func uploadProfileImage() {
        guard let uid = Auth.auth().currentUser?.uid, let image = self.image else {
            print("Error: User not authenticated or image is nil")
            return
        }
        
        if let imageData = image.jpegData(compressionQuality: 0.5) {
            let storageRef = Storage.storage().reference().child("users/\(uid)")

            // Upload the image data to Firebase Storage
            let uploadTask = storageRef.putData(imageData, metadata: nil) { (metadata, error) in
                if let error = error {
                    // Handle error during upload
                    print("Error during upload: \(error.localizedDescription)")
                    return
                }

                // Image uploaded successfully, now you can retrieve the download URL
                storageRef.downloadURL { (url, error) in
                    if let error = error {
                        // Handle error during download URL retrieval
                        print("Error getting download URL: \(error.localizedDescription)")
                    } else if let downloadURL = url {
                        // Save the download URL to your database or perform any necessary action
                        self.imageUrl = downloadURL.absoluteString
                        print("Download URL: \(downloadURL)")

                        // Optionally, you can perform any UI updates or other actions after successful upload
                    }
                }
            }

            // Observe the upload progress
            uploadTask.observe(.progress) { snapshot in
                // You can update UI based on the upload progress if needed
                let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
                print("Upload progress: \(percentComplete)%")
            }

            // Observe the upload completion
            uploadTask.observe(.success) { snapshot in
                print("Upload completed successfully!")
            }
        } else {
            print("Error: Failed to convert image to data")
        }
    }




//    func uploadProfileImage() {
//        guard let uid = Auth.auth().currentUser?.uid, let image = self.image else { return }
//
//        if let imageData = image.jpegData(compressionQuality: 0.5) {
//            let storageRef = Storage.storage().reference().child("users/\(uid)")
//            DispatchQueue.main.async {
//            // Upload the image data to Firebase Storage
//            storageRef.putData(imageData, metadata: nil) { (metadata, error) in
//                guard let metadata = metadata else {
//                    // Handle error
//                    print("Error uploading profile image: \(error?.localizedDescription ?? "Unknown error")")
//                    return
//                }
//                
//                    
//                    
//                    // Image uploaded successfully, now you can retrieve the download URL
//                    storageRef.downloadURL { (url, error) in
//                        if let error = error {
//                            // Handle error
//                            print("Error getting download URL: \(error.localizedDescription)")
//                        }else if let downloadURL = url {
//                            // Save the download URL to your database or perform any necessary action
//                            self.imageUrl = downloadURL.absoluteString
//                            print("Download URL: \(downloadURL)")
//                        }
//                    }
//                }
//            }
//        }
//    }
}




extension onboardingProfile: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func profileTapped(){
        profileImage.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileImage.addGestureRecognizer(tapGesture)
    }
    
    @objc func profileImageTapped(){
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.sourceType = .photoLibrary
        imagePickerVC.delegate = self
        present(imagePickerVC, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        image = info[.originalImage] as? UIImage
        self.profileImage.image = self.image
        if let imageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL {
            // Handle the imageURL as needed
            imageUrl = imageURL.absoluteString
            print("Image URL: \(imageURL)")
        }else {
            print("Error: imageUrl is nil")
        }
    
        
        
//        if let image = info[.originalImage] as? UIImage {
//            self.profileImage.image = image
//            
//            if let imageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL {
//                // Handle the imageURL as needed
//                imageUrl = imageURL.absoluteString
//                guard let uid = Auth.auth().currentUser?.uid else{return}
//                // Assuming `image` is the UIImage you want to upload
//                if let imageData = image.jpegData(compressionQuality: 0.5) {
////                    let storage = Storage.storage()
////                    let storageReference = storage.reference()
//                    
//                    // Create a reference to the profile image using the user's UID
//                    let storageRef = Storage.storage().reference().child("users/\(uid)")
//                    
//                    // Upload the image data to Firebase Storage
//                    let uploadTask = storageRef.putData(imageData, metadata: nil) { (metadata, error) in
//                        guard let metadata = metadata else {
//                            // Handle error
//                            print("Error uploading profile image: \(error?.localizedDescription ?? "Unknown error")")
//                            return
//                        }
//                        print("The uid here is: \(uid)")
//                        // Image uploaded successfully, now you can retrieve the download URL
//                        storageRef.downloadURL { (url, error) in
//                            if let error = error {
//                                // Handle error
//                                print("Error getting download URL: \(error.localizedDescription)")
//                            } else if let downloadURL = url {
//                                // Save the download URL to your database or perform any necessary action
//                                print("Download URL: \(downloadURL)")
//                            }
//                        }
//                    }
//                }
//                
//                print("Image URL: \(imageURL)")
//            }
//            
//        }

    }

}
