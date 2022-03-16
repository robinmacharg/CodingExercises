//
//  MapViewController.swift
//  Backbase
//
//  Created by Robin Macharg on 11/07/2020.
//  Copyright © 2020 Robin Macharg. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Properties
    
    var city: City? = nil
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Screen title
        title = city?.name ?? ""
        
        let location = CLLocationCoordinate2D(
            latitude: city?.coord.lat ?? 0.0,
            longitude: city?.coord.lon ?? 0.0)
        
        // Add a pin
        let pin = CityAnnotation(title: title!, coordinate: location)
//        MKPlacemark(coordinate: location)
        mapView.addAnnotation(pin)

        // Center the map on the city
        let region = MKCoordinateRegion(
            center: location,
            span: MKCoordinateSpan(
                latitudeDelta: 0.005,
                longitudeDelta: 0.005))
        
        mapView.region = region
    }
}

/**
 * A map pin
 */
private class CityAnnotation: NSObject, MKAnnotation {
    let title: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
        
        super.init()
    }
}
