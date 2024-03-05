//
//  miamiNeighborhoods.swift
//  Foodie Yelp API
//
//  Created by JD Villanueva on 11/29/23.
//

import Foundation
import MapKit

struct Miami{
    static var miamiNeighborhoods = [
        "Miami Beach": CLLocationCoordinate2D(latitude: 25.793449, longitude: -80.139198),
        "Miami Design District": CLLocationCoordinate2D(latitude: 25.8134, longitude: -80.1934),
        "Wynwood": CLLocationCoordinate2D(latitude: 25.8042, longitude: -80.1989),
        "Downtown Miami & Brickell": CLLocationCoordinate2D(latitude: 25.7602, longitude: -80.1959),
        "Coconut Grove": CLLocationCoordinate2D(latitude: 25.7355, longitude: -80.2377),
        "Coral Gables": CLLocationCoordinate2D(latitude: 25.7492, longitude: -80.2635),
        "Little Havana": CLLocationCoordinate2D(latitude: 25.7776, longitude: -80.2377),
    ] as [String:CLLocationCoordinate2D]
}
