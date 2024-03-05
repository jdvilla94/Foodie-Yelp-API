//
//  newOrleansNeighborhoods.swift
//  Foodie Yelp API
//
//  Created by JD Villanueva on 11/23/23.
//

import Foundation
import MapKit

struct NewOrleans{
    static var newOrleansNeighborhoods = [
        "Lower Ninth Ward": CLLocationCoordinate2D(latitude: 29.9683, longitude: -90.0140),
        "Gentilly": CLLocationCoordinate2D(latitude: 30.0125, longitude: -90.0603),
        "The West Bank": CLLocationCoordinate2D(latitude: 29.89695, longitude: -90.09819),
        "Lakeview": CLLocationCoordinate2D(latitude: 30.0086, longitude: -90.1074),
        "Bywater": CLLocationCoordinate2D(latitude: 29.9634, longitude: -90.0404),
        "Mid-City": CLLocationCoordinate2D(latitude: 29.9714, longitude: -90.1001),
        "Marigny": CLLocationCoordinate2D(latitude: 29.9639, longitude: -90.0572),
        "CBD/Warehouse District": CLLocationCoordinate2D(latitude: 29.9468, longitude: -90.0754),
        "Uptown/Carrollton": CLLocationCoordinate2D(latitude: 29.9437, longitude: -90.1217),
        "Central City/Garden District": CLLocationCoordinate2D(latitude: 29.5540, longitude: -90.0505),
        "French Quarter": CLLocationCoordinate2D(latitude: 29.9584, longitude: -90.0644)
        
    ] as [String:CLLocationCoordinate2D]
}
