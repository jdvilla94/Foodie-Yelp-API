//
//  loginOrSignUpVC.swift
//  Foodie Yelp API
//
//  Created by JD Villanueva on 11/3/23.
//

import UIKit
import GoogleSignIn
import Firebase
import FirebaseAuth
import GoogleSignInSwift




class loginOrSignUpVC: UIViewController {

    @IBOutlet var continueWithGoogleButton: UIButton!
    @IBOutlet var continueWithFacebookButton: UIButton!
    @IBOutlet var loginButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.50)
        
        continueWithGoogleButton.layer.borderWidth = 1
        continueWithGoogleButton.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        continueWithGoogleButton.layer.cornerRadius = 15
        
        continueWithFacebookButton.layer.borderWidth = 1
        continueWithFacebookButton.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        continueWithFacebookButton.layer.cornerRadius = 15
        
        loginButton.layer.cornerRadius = 15
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("The current user auth is: \(Auth.auth().currentUser)")
    }
    
    
    @IBAction func googleSignInTapped(_ sender: Any) {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { authentication, error in
            if let error = error {
                print("There was an error signing the user in -> \(error)")
                return
            }
            guard let user = authentication?.user,
                  let idToken = user.idToken?.tokenString else {return}
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            
            let registerUserRequest = registerUserRequest(username: user.profile?.name ?? "no name",
                                                          email: user.profile?.email ?? "no email",
                                                          password: "nopassword",
                                                          favFood: "",
                                                          favCity: "",
                                                          profileImage: "",
                                                          favorites: []
                                                        )
//            print("THE REGISTERED USER IS -> \(registerUserRequest)")
//            print("YOUR GOOGLE EMAIL IS: \(user.profile?.email ?? "no email")")
//            print("YOUR GOOGLE NAME IS: \(user.profile?.name ?? "no name")")
            
            let db = Firestore.firestore()
            let usersCollection = db.collection("users") // Replace with the name of your collection

               // Query to find a document where the "email" field matches the given email
            usersCollection.whereField("email", isEqualTo: user.profile?.email).getDocuments { (querySnapshot, error) in
                   if let error = error {
                       print("Error fetching documents: \(error)")
                       return
                   } else if querySnapshot?.documents.isEmpty == false {
                       // Email exists in Firestore
                       Auth.auth().signIn(with: credential) { authresult, error in
                       

                           if error != nil {
                               print(error ?? "0")
                           }

                           if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate{
                                   sceneDelegate.checkAuthentication()
                           }
                               
                           }
                       print("email exists in")
                 
                       return
                   } else {
                       // Email doesn't exist in Firestore
                       print("email doesnt exist in firestore")
                       authService.shared.registerUser(with: registerUserRequest) { [weak self] wasRegistered, error in
                           guard let self = self else {return}//stops retain cycles
                           
                           if let error = error {
                               print("couldnt log you into firestore-> \(error)")
                               return
                           }
                           
                           if wasRegistered{
                               print("SUCCESSFULLY ADDED USER TO FIREBASE")
                               Auth.auth().signIn(with: credential) { authresult, error in
                               

                                   if error != nil {
                                       print(error ?? "0")
                                   }

                                   if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate{
                                           sceneDelegate.checkAuthentication()
                                   }
                                       
                                   }
                               
                           }else{
                               print("THE ERROR WAS\(String(describing: error))")
                           }
                           
                           
                           }
                       return
                   }
               }
//
//            authService.shared.registerUser(with: registerUserRequest) { [weak self] wasRegistered, error in
//                guard let self = self else {return}//stops retain cycles
//                
//                if let error = error {
//                    print("couldnt log you into firestore-> \(error)")
//                    return
//                }
//                
//                if wasRegistered{
//                    print("SUCCESSFULLY ADDED USER TO FIREBASE")
//                    Auth.auth().signIn(with: credential) { authresult, error in
//                    
//
//                        if error != nil {
//                            print(error ?? "0")
//                        }
//
//                        if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate{
//                                sceneDelegate.checkAuthentication()
//                        }
//                            
//                        }
//                    
//                }else{
//                    print("THE ERROR WAS\(String(describing: error))")
//                }
//                
//                
//                }
            


            }
            



        }
            
            
        
    }
    
    

