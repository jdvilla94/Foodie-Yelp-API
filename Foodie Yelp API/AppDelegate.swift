//
//  AppDelegate.swift
//  Foodie Yelp API
//
//  Created by JD Villanueva on 11/3/23.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseAuth

import GoogleSignIn

      

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        

//        let userRequest = registerUserRequest(username: "JD", email: "j@gmail.com", password: "password123")
//        authService.shared.registerUser(with: userRequest) { wasRegistered, error in
//            if let error = error {
//                print(error.localizedDescription)
//                return
//            }
//            print("was registered", wasRegistered)
//        }
//        
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        var handled: Bool
        handled = GIDSignIn.sharedInstance.handle(url)
        if handled{
            return true
        }
        return false
    }
    



}

