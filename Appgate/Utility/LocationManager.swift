//
//  LocationManager.swift
//  Appgate
//
//  Created by Juan Uribe on 15/05/21.
//

import Foundation
import CoreLocation
import Combine

/// Manager for getting the device location.
final class LocationManager: NSObject {
    
    // MARK: - Properties
    
    private let locationManager = CLLocationManager()
    @Published var lastLocation: CLLocation?
    
    // MARK: - Initializers
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

//MARK: - CLLocationManagerDelegate

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else {
            return
        }
        self.lastLocation = lastLocation
    }
}
