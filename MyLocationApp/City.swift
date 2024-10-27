//
//  City.swift
//  MyLocationApp
//
//  Created by Mürşide Gökçe on 26.10.2024.
//

import Foundation

class City: Codable {
    var city: String
    var plate: Int?
    var latitude: Double?
    var longitude: Double?
    
    
    init (city: String, plate: Int, latitude: Double, longitude: Double) {
        self.city = city
        self.plate = plate
        self.latitude = latitude
        self.longitude = longitude
    }
    
    
}
