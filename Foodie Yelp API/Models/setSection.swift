//
//  setSection.swift
//  Foodie Yelp API
//
//  Created by JD Villanueva on 11/29/23.
//

import Foundation

protocol sectionType: CustomStringConvertible {
    var containsSwitch: Bool {get}
}

enum setSections: Int, CaseIterable, CustomStringConvertible {
    
    case Profile
    case Account
    
    var description: String {
        switch self {
        case .Profile: return "Profile"
        case .Account: return "Account"
        }
    }
    
    
    
    
}


enum profileGroup: Int, CaseIterable, sectionType{
    case profile
//    case logOut
    
    var description: String {
        switch self {
        case .profile: return "Profile"
//        case .logOut: return "Log Out"
        }
    }
    
    var containsSwitch: Bool{
        return false
    }
}

enum accountGroup: Int, CaseIterable, sectionType{
    
    case logout
    case changeEmail
    case changePassword
//    case reportCrashes
    
    
    var description: String {
        switch self {
        case .changeEmail: return "Change Email"
        case .changePassword: return "Change Password"
//        case .reportCrashes: return "Report Crashes"
        case .logout: return "Logout"
        }
    }
    var containsSwitch: Bool{
        return false
//        switch self {
//        case .notifications: return true
//        case .email: return true
//        case .reportCrashes: return false
//     }
    
}
}
