//
//  austinNeighborhoods.swift
//  Foodie Yelp API
//
//  Created by JD Villanueva on 11/23/23.
//

import Foundation
import MapKit


struct Austin{
    static var austinNeighborhoods = [
        "Manor Rd": CLLocationCoordinate2D(latitude: 30.296387, longitude: -97.689955),
        "Rainey": CLLocationCoordinate2D(latitude: 30.25993, longitude: -97.7386),
        "North Lamar": CLLocationCoordinate2D(latitude: 30.3701, longitude: -97.6884),
        "South Congress": CLLocationCoordinate2D(latitude: 30.2050, longitude: -97.7748),
        "Mueller": CLLocationCoordinate2D(latitude: 30.2987, longitude: -97.7004),
        "South First": CLLocationCoordinate2D(latitude: 30.266666, longitude: -97.733330),
        "Allandale/Crestview": CLLocationCoordinate2D(latitude:  30.351414, longitude: -97.725376),
        "South Lamar": CLLocationCoordinate2D(latitude: 30.2372, longitude: -97.7838),
        "East Austin": CLLocationCoordinate2D(latitude: 30.2655, longitude: -97.7091),
        "Downtown": CLLocationCoordinate2D(latitude: 30.2729, longitude: -97.7444),
        
    ] as [String:CLLocationCoordinate2D]
}
