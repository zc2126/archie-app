//
//  DeviceLocationService.swift
//  Archie
//
//  Created by Will Rojas on 10/24/22.
//

import Combine
import CoreLocation

class DeviceLocationService: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    func retLoc() -> CLLocationManager {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestLocation()
        print(locationManager.location?.coordinate.latitude)
        print(locationManager.location?.coordinate.longitude)
        return locationManager
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]){
            do{
                if let location = locations.first {
                    let latitude = location.coordinate.latitude
                    let longitude = location.coordinate.longitude
                }
            }
            catch{
                locationManager(manager.location!, didFailWithError: Error.self as! Error)
            }
        }
    
    func locationManager(
        _ manager: CLLocation,
        didFailWithError error: Error) {
            print(error)
        }
}
    
