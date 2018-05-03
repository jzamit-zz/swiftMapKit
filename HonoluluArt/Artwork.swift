//
//  Artwork.swift
//  HonoluluArt
//
//  Created by Jorge Zamit on 5/2/18.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import Foundation
import MapKit

class Artwork: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    var imageName: String? {
        if discipline == "Sculpture" { return "Statue" }
        return "drone"
    }
    
    // markerTintColor for disciplines: Sculpture, Plaque, Mural, Monument, other
    var markerTintColor: UIColor  {
        switch discipline {
        case "Monument":
            return .red
        case "Mural":
            return .cyan
        case "Plaque":
            return .blue
        case "Sculpture":
            return .purple
        default:
            return .green
        }
    }
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        super.init()
    }
    
    //failable initialaizer to instantiate Artwork obj from JSON
    init?(json: [Any]) {
        // 1
        print(json[16])
        self.title = json[16] as? String ?? "No Title"
        self.locationName = json[11] as! String
        self.discipline = json[15] as! String
        // 2
        if let latitude = Double(json[18] as! String),
            let longitude = Double(json[19] as! String) {
            self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        } else {
            self.coordinate = CLLocationCoordinate2D()
        }
    }
    
    var subtitle: String? {
        return locationName
    }
    
}
