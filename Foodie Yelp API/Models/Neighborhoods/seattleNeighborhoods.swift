//
//  seattleNeighborhoods.swift
//  Foodie Yelp API
//
//  Created by JD Villanueva on 11/15/23.
//

import Foundation
import MapKit

struct Seattle{
    static var seattleNeighborhoods = [
        //north neighborhoods
        "Capitol Hill":CLLocationCoordinate2D(latitude: 47.6253, longitude: -122.3222),
        "International District":CLLocationCoordinate2D(latitude: 47.5987, longitude: -122.3240),
        "Columbia City":CLLocationCoordinate2D(latitude: 47.5608, longitude: -122.2870),
        "Ballard":CLLocationCoordinate2D(latitude: 47.6792, longitude: -122.3860),
        "South Lake Union":CLLocationCoordinate2D(latitude: 47.6256, longitude: -122.3344),
        "Fremont":CLLocationCoordinate2D(latitude: 47.6542, longitude: -122.3500),
        "West Seattle":CLLocationCoordinate2D(latitude: 47.5667, longitude: -122.3868),
        "University District":CLLocationCoordinate2D(latitude: 47.6628, longitude: -122.3139),
        "Central District":CLLocationCoordinate2D(latitude: 47.6088, longitude: -122.2964),
        "Georgetown":CLLocationCoordinate2D(latitude: 47.5475, longitude: -122.3215),
        

    
    ] as [String : CLLocationCoordinate2D]
}
