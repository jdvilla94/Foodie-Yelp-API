//
//  fetchBusinessInfo.swift
//  Foodie Yelp API
//
//  Created by JD Villanueva on 11/8/23.
//

import UIKit

class fetchBusinessInfo {
    
    public static let shared = fetchBusinessInfo()
    private init(){}//this is a singleton initlizes when app turns on, access any where
    
    public func getBuisnessData(
        location: String,
//        latitude:Double,
//        longitude:Double,
        category: String,
        limit: Int,
        sortBy: String,
        locale: String,
        completionHandler: @escaping ([Business]?,Error?) -> Void){
            //get yelp api key
            let apiKey = "PUT IN YOUR ON API KEY"

    
            
            //create url so we cant fetch the data from yelp api
//            let baseUrl = "https://api.yelp.com/v3/businesses/search?location=San%20Francisco&term=Thai&attributes=reservation"
            let baseUrl = "https://api.yelp.com/v3/businesses/search?location=\(location)&categories=\(category)&sort_by=rating&limit=\(limit)"
//            "https://api.yelp.com/v3/businesses/search?location=austin&categories=sushi&sort_by=rating&limit=20"



            let url = URL(string: baseUrl)
            //create request
            var request = URLRequest(url: url!)
            request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
            request.httpMethod = "GET"
            // Create a URLSession data task
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                
//                if let httpResponse = response as? HTTPURLResponse {
//                    print("INVALID RESPONE: \(httpResponse.statusCode)")
//                    return
//                }
                guard let httpResponse = response as? HTTPURLResponse,(200...299).contains(httpResponse.statusCode) else {
                    print("INVALID RESPONE:")
                    return
                }
                
                if let data = data {
                    do {
                        //parse json data
                        if let json = try JSONSerialization.jsonObject(with: data,options: []) as? [String: Any]{
                            //handle json data as needed
//                            print("THe JSON VALUE IS THIS: \(json)")
                            //access each business
                            if let businesses = json["businesses"] as? [[String:Any]] {
//                                var businessList: [String] = []
                                var businessList: [Business] = []
                                var element = Business()
                                for business in businesses {
                                    if let name = business["name"] as? String{
                                        element.name = name
                                        element.id = business["id"] as? String
                                        element.rating = business["rating"] as? Float
                                        element.price = business["price"] as? String
                                        element.isClosed = business["is_closed"] as? Bool
                                        element.distance = business["distance"] as? Double
                                        element.image = business["image_url"] as? String
                                        element.rating = business["rating"] as? Float
                                        let location = business["location"] as? [String: Any]
                                        let displayAddress = location!["display_address"] as? [String]
                                        element.address = displayAddress?.joined(separator: ", ")


                                        // let address = business["location"] as? [String]
//                                        element.address = address?.joined(separator: "\n")
//
//                                        businessList.append(business)
                                        businessList.append(element)
                                    }
//                                    print("HERE ARE THE BUSINESSES: \(businessList) ")
                                    
                                }
                                completionHandler(businessList,nil)
                                
                            }
                           
                            return
                        }else{
                            print("Failled to parse json")
                        }
                    } catch{
                        print("error pasing JSON: \(error)")
                    }

                }    }.resume()
            
            }
    
    func loadImageFromUrl(urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            completion(nil)
            return
        }

        // Create a URLSession task to download the image data
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                print("Error downloading image: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }

            // Convert the downloaded data to a UIImage
            if let image = UIImage(data: data) {
                completion(image)
            } else {
                print("Error creating image from data.")
                completion(nil)
            }
        }.resume()
    }

    public func getClosetFoodRestaurants(latitude: Double, longitude: Double, limit: Int = 20, completion: @escaping ([Business]?, Error?) -> Void) {
        // Yelp API endpoint for business search
        let yelpAPIEndpoint = "https://api.yelp.com/v3/businesses/search"
        let apiKey = "3eXMz678nr5crLK87XXZhFLsmzx1aL88K6THfgSbc2vm1pNbw8GjbNmn5OAZ0V5TYDhM1-RuL6qF7_EwqTuVMxvDw0j2EX0lJDHhCxxuZG6_-2hNr_Hx2QryVLTDZXYx"
        

        
        // Construct the request URL
        var urlComponents = URLComponents(string: yelpAPIEndpoint)
        urlComponents?.queryItems = [
            URLQueryItem(name: "latitude", value: String(latitude)),
            URLQueryItem(name: "longitude", value: String(longitude)),
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "categories", value: "food"),  // Specify the "food" category
        ]

        guard let url = urlComponents?.url else {
            completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        // Make the API request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }

            // Parse the JSON response
            if let data = data {
                do {
                    // Parse json data
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        // Handle json data as needed
                        if let businesses = json["businesses"] as? [[String: Any]] {
                            var businessList: [Business] = []

                            for business in businesses {
                                var element = Business()

                                if let name = business["name"] as? String {
                                    element.name = name
                                    element.id = business["id"] as? String
                                    element.rating = business["rating"] as? Float
                                    element.price = business["price"] as? String
                                    element.isClosed = business["is_closed"] as? Bool
                                    element.distance = business["distance"] as? Double
                                    element.image = business["image_url"] as? String

                                    let location = business["location"] as? [String: Any]
                                    let displayAddress = location?["display_address"] as? [String]
                                    element.address = displayAddress?.joined(separator: ", ")

                                    businessList.append(element)
                                }
                            }

                            completion(businessList, nil)
                            return
                        } else {
                            print("Failed to parse JSON")
                        }
                    }
                } catch {
                    print("Error parsing JSON: \(error)")
                }
            }
        }

        task.resume()
    }









}
