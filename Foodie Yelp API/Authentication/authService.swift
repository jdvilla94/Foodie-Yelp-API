//
//  authService.swift
//  Foodie Yelp API
//
//  Created by JD Villanueva on 11/4/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class authService{
    
    public static let shared = authService()
    private init(){}//this is a singleton initlizes when app turns on, access any where
    
    
    
    /// A method to register the user
    /// - Parameters:
    ///   - userRequest: the users information(email, password, username)
    ///   - completion: a completion with two values...
    ///   - bool : wasregistered  - determins if the user was registered and saved in the database correctly
    ///   - error? an optional error if firebase provides one
    public func registerUser(with userRequest: registerUserRequest, completion: @escaping (Bool, Error?) -> Void){//completion handler calls a function, it runs if it passes completion, asycn way of doing things. we need to upload data, and it takes a few seconds. call completion when everything happens
        let username = userRequest.username
        let password = userRequest.password
        let email = userRequest.email
        let food = userRequest.favFood
        let city = userRequest.favCity
        let profileImage = userRequest.profileImage
        let favorites = userRequest.favorites
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            
            if let error = error {
                completion(false,error)
                return
            }
            
            guard let resultUser = result?.user else{
                completion(false, nil)
                return
            }
            
            let db = Firestore.firestore()
            db.collection("users")
                .document(resultUser.uid)
                .setData([
                    "username":username,
                    "password": password,
                    "email": email,
                    "favFood": food,
                    "favCity": city,
                    "profileImage": profileImage
                    
                ]) { error in
                    if let error = error {
                        completion(false,error)
                        return
                    }
                    completion(true,nil)
//                    return
                }
            
            // Add data to the "friends" collection
            db.collection("friends").document(resultUser.uid).setData([
                "ownRequest":[""],
                "friendRequests": [""],
                "allFriends": [""]
            ]) { error in
                if let error = error {
                    completion(false, error)
                    return
                }

                completion(true, nil)
            }
            
        }
    }
    
    public func signIn(with userRequet: loginUserRequest,completion: @escaping (Error?) -> Void){
        Auth.auth().signIn(withEmail: userRequet.email, password: userRequet.password) { result, error in
            if let error = error {
                completion(error)
                return
            } else{
                completion(nil)
            }
        }
    }
    
    public func signOut(completion: @escaping (Error?) -> Void){
        do{
            try Auth.auth().signOut()
            completion(nil)
        }catch let error {
            completion(error)
        }
    }
    
    public func forgotPassword(with email: String, completion: @escaping (Error?) -> Void){
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            completion(error)//were already returning an optional error
        }
    }
    
    public func getUser(completion: @escaping (User?, Error?) -> Void){
        guard let userUID = Auth.auth().currentUser?.uid else{return}
        
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(userUID)
            .getDocument { snapshot, error in
                if let error = error {
                    completion(nil,error)
                    return
                }
                
                if let snapshot = snapshot,
                   let snapshotData = snapshot.data(),
                   let username = snapshotData["username"] as? String,/*returns key value pair*/
                   let email = snapshotData["email"] as? String{
                    let user = User(email: email, username: username, userUID: userUID)
                    
                    completion(user,nil)
                }
            }
    }
    
    public func getFriend(friendUID: String,completion: @escaping (User?, Error?) -> Void){
        
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(friendUID)
            .getDocument { snapshot, error in
                if let error = error {
                    completion(nil,error)
                    return
                }
                
                if let snapshot = snapshot,
                   let snapshotData = snapshot.data(),
                   let username = snapshotData["username"] as? String,/*returns key value pair*/
                   let email = snapshotData["email"] as? String{
                    let user = User(email: email, username: username, userUID: friendUID)
                    
                    completion(user,nil)
   
                }
            }
    }

    
    
    public func getCityandFood(completion: @escaping (favFoodandCity?,Error?) -> Void){
        guard let userUID = Auth.auth().currentUser?.uid else{return}
        
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(userUID)
            .getDocument { snapshot, error in
                if let error = error {
                    completion(nil,error)
                    return
                }
                
                if let snapshot = snapshot,
                   let snapshotData = snapshot.data(),
                   let food = snapshotData["favFood"] as? String,/*returns key value pair*/
                   let city = snapshotData["favCity"] as? String{
                    let items = favFoodandCity(favFood: food, favCity: city)
                    completion(items,nil)
                }
            }
    }
    
//    public func setTopTen(_ topTen: topTenSaved, completion: @escaping (Error?) -> Void) {
//        let db = Firestore.firestore()
//
//        let newTopItemRef = db.collection("top").addDocument(data: [
//            "name": topTen.name,
//            "address": topTen.address,
//            "image": topTen.image,
//            "rating": topTen.rating,
//            "lat": topTen.lat,
//            "long": topTen.long,
//            "count": topTen.count
//        ])
//
//        // Limit the number of items to 10, ordered by count in descending order
//        let query = db.collection("top").order(by: "count", descending: true).limit(to: 10)
//
//        query.getDocuments { (snapshot, error) in
//            if let error = error {
//                completion(error)
//                return
//            }
//
//            // Check if there are more than 10 items
//            if snapshot?.count ?? 0 > 10 {
//                // Remove the item with the lowest count
//                if let lastItem = snapshot?.documents.last {
//                    let lastItemRef = db.collection("top").document(lastItem.documentID)
//                    lastItemRef.delete()
//                }
//            }
//
//            completion(nil)
//        }
//    }



    
//    public func setTopTen(_ topTen: topTenSaved, completion: @escaping (Error?) -> Void) {
//        let db = Firestore.firestore()
//
//        let data: [String: Any] = [
//            "name": topTen.name,
//            "address": topTen.address,
//            "image": topTen.image,
//            "rating": topTen.rating,
//            "lat": topTen.lat,
//            "long": topTen.long,
//            "count":topTen.count
//        ]
//        
//        // Update the "favorites" array in Firestore
//        db.collection("top")
//            .document()
//            .updateData([
//                "favorites": FieldValue.arrayUnion([data])
//            ]) { error in
//                completion(error)
//            }
//        
//
//        
//    }
    
    
    public func setFavoritesSaved(_ favorites: favoritesSaved, completion: @escaping (Error?) -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        
        let data: [String: Any] = [
            "name": favorites.name,
            "address": favorites.address,
            "image": favorites.image,
            "rating": favorites.rating,
            "lat": favorites.lat,
            "long": favorites.long
        ]
        
        // Update the "favorites" array in Firestore
        db.collection("users")
            .document(userUID)
            .updateData([
                "favorites": FieldValue.arrayUnion([data])
            ]) { error in
                completion(error)
            }
        
    }
    
    public func setVisitedSaved(_ visited: visitedSaved, completion: @escaping (Error?) -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        
        let data: [String: Any] = [
            "name": visited.name,
            "address": visited.address,
            "image": visited.image,
            "rating": visited.rating,
            "lat": visited.lat,
            "long": visited.long
        ]
        
        // Update the "favorites" array in Firestore
        db.collection("users")
            .document(userUID)
            .updateData([
                "visited": FieldValue.arrayUnion([data])
            ]) { error in
                completion(error)
            }
        
    }
    
    public func getFavoritesSaved(completion: @escaping ([favoritesSaved]?,Error?) -> Void){
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(userUID)
            .getDocument { snapshot, error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                if let snapshot = snapshot,
                   let snapshotData = snapshot.data(),
                   let favoritesData = snapshotData["favorites"] as? [[String: Any]] {
                    
                    // Parse the favoritesData array into an array
                    let favorites: [favoritesSaved] = favoritesData.compactMap { itemData in
                        guard
                            let name = itemData["name"] as? String,
                            let address = itemData["address"] as? String,
                            let image = itemData["image"] as? String,
                            let rating = itemData["rating"] as? Float,
                            let lat = itemData["lat"] as? Double,
                            let long = itemData["long"] as? Double
                        else {
                            return nil
                        }
                        
                        return favoritesSaved(name: name, address: address, image: image, rating: rating, lat: lat, long: long)
                    }
                    
                    completion(favorites, nil)
                }
            }
        
        
        
        
    }
    
    public func getFriendsFavoritesSaved(friendsUID:String, completion: @escaping ([favoritesSaved]?,Error?) -> Void){
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(friendsUID)
            .getDocument { snapshot, error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                if let snapshot = snapshot,
                   let snapshotData = snapshot.data(),
                   let favoritesData = snapshotData["favorites"] as? [[String: Any]] {
                    
                    // Parse the favoritesData array into an array
                    let favorites: [favoritesSaved] = favoritesData.compactMap { itemData in
                        guard
                            let name = itemData["name"] as? String,
                            let address = itemData["address"] as? String,
                            let image = itemData["image"] as? String,
                            let rating = itemData["rating"] as? Float,
                            let lat = itemData["lat"] as? Double,
                            let long = itemData["long"] as? Double
                        else {
                            return nil
                        }
                        
                        return favoritesSaved(name: name, address: address, image: image, rating: rating, lat: lat, long: long)
                    }
                    
                    completion(favorites, nil)
                }
            }
        
        
        
        
    }
    
    
    public func getVisitedSaved(completion: @escaping ([visitedSaved]?,Error?) -> Void){
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(userUID)
            .getDocument { snapshot, error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                if let snapshot = snapshot,
                   let snapshotData = snapshot.data(),
                   let visitedData = snapshotData["visited"] as? [[String: Any]] {
                    
                    // Parse the favoritesData array into an array
                    let visited: [visitedSaved] = visitedData.compactMap { itemData in
                        guard
                            let name = itemData["name"] as? String,
                            let address = itemData["address"] as? String,
                            let image = itemData["image"] as? String,
                            let rating = itemData["rating"] as? Float,
                            let lat = itemData["lat"] as? Double,
                            let long = itemData["long"] as? Double
                        else {
                            return nil
                        }
                        
                        return visitedSaved(name: name, address: address, image: image, rating: rating, lat: lat, long: long)
                    }
                    
                    completion(visited, nil)
                }
            }
        
        
        
        
    }
    
    public func getFriendsVisitedSaved(friendsUID:String,completion: @escaping ([visitedSaved]?,Error?) -> Void){
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(friendsUID)
            .getDocument { snapshot, error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                if let snapshot = snapshot,
                   let snapshotData = snapshot.data(),
                   let visitedData = snapshotData["visited"] as? [[String: Any]] {
                    
                    // Parse the favoritesData array into an array
                    let visited: [visitedSaved] = visitedData.compactMap { itemData in
                        guard
                            let name = itemData["name"] as? String,
                            let address = itemData["address"] as? String,
                            let image = itemData["image"] as? String,
                            let rating = itemData["rating"] as? Float,
                            let lat = itemData["lat"] as? Double,
                            let long = itemData["long"] as? Double
                        else {
                            return nil
                        }
                        
                        return visitedSaved(name: name, address: address, image: image, rating: rating, lat: lat, long: long)
                    }
                    
                    completion(visited, nil)
                }
            }
        
        
        
        
    }
    
    public func getUsernamesAndUIDs(completion: @escaping ([nameAndUID]?, Error?) -> Void) {
        let db = Firestore.firestore()

        db.collection("users").getDocuments { snapshot, error in
            if let error = error {
                completion(nil, error)
                return
            }

            var usersData: [nameAndUID] = []

            for document in snapshot!.documents {
                let uid = document.documentID

                if let username = document["username"] as? String {
                    let user = nameAndUID(username: username, uid: uid)
                    usersData.append(user)
                }
            }

            completion(usersData, nil)
        }
    }
    
    
    public func followUser(_ uid: String, completion: @escaping (Error?) -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        
        let data: [String: Any] = [
            "uid": uid,
            "name": "temp name",
     
        ]
        
        // Update the "favorites" array in Firestore
        db.collection("friends")
            .document(userUID)
            .updateData([
                "friendRequests": FieldValue.arrayUnion([data])
            ]) { error in
                completion(error)
            }
        
    }
    
    public func unfollowUser(_ uid: String, completion: @escaping (Error?) -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        
        let data: [String: Any] = [
            "uid": uid,
            "name": "temp name",
        ]
        
        // Update the "favorites" array in Firestore
        db.collection("friends")
            .document(userUID)
            .updateData([
                "friendRequests": FieldValue.arrayRemove([data])
            ]) { error in
                completion(error)
            }
    }
    
    public func checkUserExists(_ uid: String, completion: @escaping (Bool, Error?) -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else {
            completion(false, nil)
            return
        }

        let db = Firestore.firestore()

        // Check if the user is already in the database
        db.collection("friends")
            .document(userUID)
            .getDocument { snapshot, error in
                if let error = error {
                    completion(false, error)
                    return
                }
//                print("THis is our snaphshot: \(snapshot?.documentID)")
                if let snapshot = snapshot, snapshot.exists {
                    // The document exists, check if the user is already in the array
                    if let friends = snapshot.data()?["friendRequests"] as? [[String: Any]],
                       !friends.contains(where: { $0["uid"] as! String == uid }) {
                        // User is not in the array
                        completion(false, nil)
                        
                    } else {
                        // User is already in the array
                        completion(true, nil)
                    }
                } else {
                    // The document does not exist
                    completion(false, nil)
                }
            }
    }
    
    public func getFriendRequestsCount(completion: @escaping (Int, Error?) -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else {
            completion(0, nil)
            return
        }

        let db = Firestore.firestore()

        // Check if the user is already in the database
        db.collection("friends")
            .document(userUID)
            .getDocument { snapshot, error in
                if let error = error {
                    completion(0, error)
                    return
                }

                if let snapshot = snapshot, snapshot.exists {
                    // The document exists, get the count of the "frienRequests" array
                    if let friends = snapshot.data()?["friendRequests"] as? [[String: Any]] {
                        let count = friends.count
                        completion(count, nil)
                    } else {
                        // The "frienRequests" array is not present or empty
                        completion(0, nil)
                    }
                } else {
                    // The document does not exist
                    completion(0, nil)
                }
            }
    }
    
    public func getFollowerCount(completion: @escaping (Int, Error?) -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else {
            completion(0, nil)
            return
        }

        let db = Firestore.firestore()

        // Check if the user is already in the database
        db.collection("friends")
            .document(userUID)
            .getDocument { snapshot, error in
                if let error = error {
                    completion(0, error)
                    return
                }

                if let snapshot = snapshot, snapshot.exists {
                    // The document exists, get the count of the "frienRequests" array
                    if let friends = snapshot.data()?["ownRequest"] as? [[String: Any]] {
                        let count = friends.count
                        completion(count, nil)
                    } else {
                        // The "frienRequests" array is not present or empty
                        completion(0, nil)
                    }
                } else {
                    // The document does not exist
                    completion(0, nil)
                }
            }
    }
    
    public func getFriendList(completion: @escaping ([String]?, Error?) -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else {
            completion(nil, nil)
            return
        }

        let db = Firestore.firestore()

        db.collection("friends")
            .document(userUID)
            .getDocument { snapshot, error in
                if let error = error {
                    completion(nil, error)
                    return
                }

                if let snapshot = snapshot, snapshot.exists {
                    // The document exists, get the "friendRequests" array
                    if let friendRequests = snapshot.data()?["friendRequests"] as? [[String: Any]] {
                        // Extract "uid" values from the array
                        let uids = friendRequests.compactMap { $0["uid"] as? String }
                        completion(uids, nil)
                    } else {
                        // The "friendRequests" array is not present or empty
                        completion(nil, nil)
                    }
                } else {
                    // The document does not exist
                    completion(nil, nil)
                }
            }
    }
    

    
    public func getFollowersList(completion: @escaping ([String]?, Error?) -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else {
            completion(nil, nil)
            return
        }

        let db = Firestore.firestore()

        db.collection("friends")
            .document(userUID)
            .getDocument { snapshot, error in
                if let error = error {
                    completion(nil, error)
                    return
                }

                if let snapshot = snapshot, snapshot.exists {
                    // The document exists, get the "friendRequests" array
                    if let friendRequests = snapshot.data()?["ownRequest"] as? [[String: Any]] {
                        // Extract "uid" values from the array
                        let uids = friendRequests.compactMap { $0["uid"] as? String }
                        completion(uids, nil)
                    } else {
                        // The "friendRequests" array is not present or empty
                        completion(nil, nil)
                    }
                } else {
                    // The document does not exist
                    completion(nil, nil)
                }
            }
    }
    
    public func addFollower(_ uid: String, completion: @escaping (Error?) -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        
        let data: [String: Any] = [
            "uid": userUID,
            "name": "temp name",
     
        ]
        
        // Update the "favorites" array in Firestore
        db.collection("friends")
            .document(uid)
            .updateData([
                "ownRequest": FieldValue.arrayUnion([data])
            ]) { error in
                completion(error)
            }
        
    }
    
    public func removeFollower(_ uid: String, completion: @escaping (Error?) -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        
        let data: [String: Any] = [
            "uid": userUID,
            "name": "temp name",
        ]
        
        // Update the "favorites" array in Firestore
        db.collection("friends")
            .document(uid)
            .updateData([
                "ownRequest": FieldValue.arrayRemove([data])
            ]) { error in
                completion(error)
            }
    }
    


    
}

    
    
    


