//
//  bostonNeighborhoods.swift
//  Foodie Yelp API
//
//  Created by JD Villanueva on 11/25/23.
//

import Foundation
import MapKit

struct Boston{
    static var bostonNeighborhoods = [
        "Allston":CLLocationCoordinate2D(latitude: 42.3555, longitude: -71.1328),
        "Chinatown":CLLocationCoordinate2D(latitude: 42.3492, longitude: -71.0621),
        "Dorchester":CLLocationCoordinate2D(latitude: 42.2995, longitude: -71.0649),
        "East Boston":CLLocationCoordinate2D(latitude: 42.3800, longitude: -71.0254),
        "Lowell Highlands":CLLocationCoordinate2D(latitude: 42.640999, longitude: -71.316711),
        "North Brookline":CLLocationCoordinate2D(latitude: 42.3469, longitude: -71.1241),
        "North End":CLLocationCoordinate2D(latitude: 42.3652, longitude: -71.0555),
        "North Quincy":CLLocationCoordinate2D(latitude: 42.2812, longitude: -71.0245),
        "Roxbury":CLLocationCoordinate2D(latitude: 42.3126, longitude: -71.0899),
        "Seaport District/Waterfront":CLLocationCoordinate2D(latitude: 42.3463, longitude: -71.0421)
    ] as [String: CLLocationCoordinate2D]
}
