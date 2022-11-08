//
//  DeviceLocationService.swift
//  Archie
//
//  Created by Will Rojas on 10/24/22.
import Combine
import CoreLocation
import Foundation

//2nd Attempt 11/7

//Observable Object should track updates in location

class DeviceLocationService: NSObject, CLLocationManagerDelegate, ObservableObject{
    
    
    //should pass coordinates through the publisher and send errors
    var coordinatesPublisher = PassthroughSubject<CLLocationCoordinate2D, Error>()
    
    
    var deniedLocationAccessPublisher = PassthroughSubject<Void, Never>()
    
    
     override init(){
        
        super.init()
        
    }
    
    static let shared = DeviceLocationService()
    
    lazy var locationManager: CLLocationManager = {
        
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        return manager
        
    }()
    
    //Supposed to request user location
    
    func requestLocationUpdates(){
        
        switch locationManager.authorizationStatus{
            
        case .notDetermined:
            
            locationManager.requestWhenInUseAuthorization()
        
        case .authorizedWhenInUse, .authorizedAlways:
            
            locationManager.startUpdatingLocation()
            
        default:
            deniedLocationAccessPublisher.send()
            
        }
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus{
            
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
            
        default:
            manager.stopUpdatingLocation()
            deniedLocationAccessPublisher.send()
            
            
        }
    }
    
    
    
    
    //get location and send coordinates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        
        guard let location = locations.last else {return}
        
        coordinatesPublisher.send(location.coordinate)
        
        
    }
    
    
    
    // Error handling
    
    func locationManager(_ manager: CLLocationManager, didFailwithError error: Error) {
        
        coordinatesPublisher.send(completion: .failure(error))
        
    }
    
    
    
    
}
