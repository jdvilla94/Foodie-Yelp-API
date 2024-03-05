//
//  chicagoNeighborhoods.swift
//  Foodie Yelp API
//
//  Created by JD Villanueva on 11/15/23.
//

import Foundation
import MapKit

struct Chicago{
    static var chicagoNeighborhoods = [
        //north neighborhoods
        "Edgewater":CLLocationCoordinate2D(latitude: 41.9837, longitude: -87.6601),
        "Gold Coast":CLLocationCoordinate2D(latitude: 41.9067, longitude: -87.6253),
        "Lakeview":CLLocationCoordinate2D(latitude: 41.9398, longitude: -87.6589),
        "Lincoln Park":CLLocationCoordinate2D(latitude: 41.9255, longitude: -87.6488),
        "Lincoln Square":CLLocationCoordinate2D(latitude: 41.9687, longitude: -87.6890),
        "Old Town":CLLocationCoordinate2D(latitude: 41.9111, longitude: -87.6410),
        "North Center":CLLocationCoordinate2D(latitude: 41.9542, longitude: -87.6787),
        "River North":CLLocationCoordinate2D(latitude: 41.8924, longitude: -87.6341),
        "Rogers Park":CLLocationCoordinate2D(latitude: 42.0126, longitude: -87.6746),
        "Roscoe Village":CLLocationCoordinate2D(latitude: 41.9432, longitude: -87.6785),
        "Streeterville":CLLocationCoordinate2D(latitude: 41.8927, longitude: -87.6200),
        "Uptown":CLLocationCoordinate2D(latitude: 41.9665, longitude: -87.6533),
        //West side
//       ("Albany Park",CLLocation(latitude: 41.9683, longitude: 87.7280),
        "Avonddale":CLLocationCoordinate2D(latitude: 41.93892, longitude: -87.7113),
        "Bucktown":CLLocationCoordinate2D(latitude: 41.9227, longitude: -87.6803),
        "Chinatown":CLLocationCoordinate2D(latitude: 41.8507, longitude: -87.6340),
        "Forest Glen":CLLocationCoordinate2D(latitude: 41.9962, longitude: -87.7642),
        "Humbodlt Park":CLLocationCoordinate2D(latitude: 41.8991, longitude: -87.7213),
//       ("Irving Park",CLLocation(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>),
//       ("Jefferson Park",CLLocation(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>),
        "Little Italy":CLLocationCoordinate2D(latitude: 41.8695, longitude: -87.6511),
        "Logan Square":CLLocationCoordinate2D(latitude: 41.9231, longitude: 87.7093),
        "Pilsen":CLLocationCoordinate2D(latitude: 41.8523, longitude: -87.6660),
        "The Loop":CLLocationCoordinate2D(latitude: 41.8786, longitude: -87.6251),
        "University Village":CLLocationCoordinate2D(latitude: 41.8695, longitude: -87.6511),
        "West Loop":CLLocationCoordinate2D(latitude: 41.8854, longitude: -87.6627),
        "West Town":CLLocationCoordinate2D(latitude: 41.8936, longitude: -87.6722),
        "Wicker Park":CLLocationCoordinate2D(latitude: 41.9105, longitude: -87.6776),
        //South side
        "Bronzeville":CLLocationCoordinate2D(latitude: 41.8166, longitude: -87.6168),
        "Hyde Park":CLLocationCoordinate2D(latitude: 41.7948, longitude: 87.5917),
        "Little Village":CLLocationCoordinate2D(latitude: 41.8445, longitude: -87.7050),
        "South Loop":CLLocationCoordinate2D(latitude: 41.8674, longitude: -87.6275)
    
    ] as [String : CLLocationCoordinate2D] 
}
