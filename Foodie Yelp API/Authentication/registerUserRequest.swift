//
//  registerUserRequest.swift
//  Foodie Yelp API
//
//  Created by JD Villanueva on 11/4/23.
//

import Foundation

struct registerUserRequest{
    let username: String
    let email: String
    let password: String
    let favFood: String
    let favCity: String
    let profileImage:String
    let favorites:[favoritesSaved]
}
