//
//  newYorkNeighborhoods.swift
//  Foodie Yelp API
//
//  Created by JD Villanueva on 11/29/23.
//

import Foundation
import MapKit

struct NewYork{
    static var newYorkNeighborhoods = [
        //manhattan
        "East Village and Lower East Side":CLLocationCoordinate2D(latitude: 40.728, longitude: -73.986),
        "Greenwich Village and West Village":CLLocationCoordinate2D(latitude: 40.7347, longitude: -74.0048),
        "Manhattan Chinatown":CLLocationCoordinate2D(latitude: 40.7158, longitude: -73.9970),
        "Soho, Noho, and Nolita":CLLocationCoordinate2D(latitude: 40.7230, longitude: -73.9949),
        "Flatiron/Union Square":CLLocationCoordinate2D(latitude: 40.7372, longitude: -73.9908),
        "Nomad/Gramercy":CLLocationCoordinate2D(latitude: 40.742836, longitude: -73.988976),
        "Midtown":CLLocationCoordinate2D(latitude: 40.7549, longitude: -73.9840),
        "Upper East/Upper West": CLLocationCoordinate2D(latitude: 40.7855, longitude: -73.9718),
        "Harlem and East Harlem": CLLocationCoordinate2D(latitude: 40.7957, longitude: -73.9389),
        //quenns
        "Long Island City":CLLocationCoordinate2D(latitude: 40.7447, longitude: -73.9485),
        "Astoria":CLLocationCoordinate2D(latitude: 40.7644, longitude: -73.9235),
        "Jackson Heights":CLLocationCoordinate2D(latitude: 40.7557, longitude: -73.8831),
        "Flushing":CLLocationCoordinate2D(latitude: 40.7647, longitude: -73.8307),
        //brooklyn
        "Greenpoint":CLLocationCoordinate2D(latitude: 40.7305, longitude: -73.9515),
        "Williamsburg":CLLocationCoordinate2D(latitude: 40.7081, longitude: -73.9571),
        "Bushwick":CLLocationCoordinate2D(latitude: 40.6958, longitude: -73.9171),
        "Park Slope/Prospect Heights":CLLocationCoordinate2D(latitude: 40.6774, longitude: -73.9668),
        "Carroll Gardens/Cobble Hill":CLLocationCoordinate2D(latitude: 40.6865, longitude: -73.9962),
        "Crown Heights":CLLocationCoordinate2D(latitude: 40.6694, longitude: -73.9422),
        "Red Hook":CLLocationCoordinate2D(latitude: 41.9951, longitude: -73.8754),
        "Sunset Park":CLLocationCoordinate2D(latitude: 40.6527, longitude: -74.0093),
        "Coney Island":CLLocationCoordinate2D(latitude: 40.5755, longitude: -73.9707),
        "Brighton Beach":CLLocationCoordinate2D(latitude: 40.5781, longitude: -73.9597),
        //Staten Island
        "Port Richmond":CLLocationCoordinate2D(latitude: 40.6339, longitude: -74.1361),
        "Ward Hill and Tompkinsville":CLLocationCoordinate2D(latitude: 40.63333, longitude: -74.0825),
        "Dongan Hills":CLLocationCoordinate2D(latitude: 40.5907, longitude: -74.0885),
        //the bronx
        "Arthur Avenue":CLLocationCoordinate2D(latitude: 40.855, longitude: -73.8874),
        "Mott Haven":CLLocationCoordinate2D(latitude: 40.8091, longitude: -73.9229),
        "Riverdale":CLLocationCoordinate2D(latitude: 40.8996, longitude: -73.9088)
    ] as [String:CLLocationCoordinate2D]
}
