//
//  losAngelesNeighborhoods.swift
//  Foodie Yelp API
//
//  Created by JD Villanueva on 11/28/23.
//

import Foundation
import MapKit

struct LosAngeles{
    static var losAngelesNeighborhoods = [
        "Boyle Heights/East LA":CLLocationCoordinate2D(latitude: 34.0298, longitude: -118.2117),
        "Chinatown":CLLocationCoordinate2D(latitude: 34.0623, longitude: -118.2383),
        "Highland Park":CLLocationCoordinate2D(latitude: 34.1155, longitude: -118.1843),
        "South LA":CLLocationCoordinate2D(latitude: 33.9891, longitude: -118.2915),
        "Silver Lake":CLLocationCoordinate2D(latitude: 34.0869, longitude: -118.2702),
        "Thai Town/Little Armenia/Los Feliz":CLLocationCoordinate2D(latitude: 34.1018, longitude: -118.3036),
        "Ventura Blvd":CLLocationCoordinate2D(latitude: 34.093240, longitude: -118.295640),
        "Culver City":CLLocationCoordinate2D(latitude: 34.0211, longitude: -118.3965),
        "South Bay":CLLocationCoordinate2D(latitude: 33.8798, longitude: -118.3813),
        "Sawtelle/Westwood Blvd":CLLocationCoordinate2D(latitude: 34.0434, longitude: -118.4543),
        "West Hollywood/Beverly Grove/Fairfax":CLLocationCoordinate2D(latitude: 34.0900, longitude: -118.3617),
        "Santa Monica/Malibu":CLLocationCoordinate2D(latitude: 34.0517, longitude: -118.7548),
        "Koreatown":CLLocationCoordinate2D(latitude: 34.0597, longitude: -118.3009),
        "San Gabriel Valley/Pasadena":CLLocationCoordinate2D(latitude: 34.14778, longitude: -118.14452),
        "Hollywood":CLLocationCoordinate2D(latitude: 34.0928, longitude: -118.3287),
        "Venice":CLLocationCoordinate2D(latitude: 33.9850, longitude: -118.4695),
        "Downtown/Arts District/Little Tokyo":CLLocationCoordinate2D(latitude: 34.0419, longitude: -118.2326)
    ] as [String:CLLocationCoordinate2D]
}
