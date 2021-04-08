//
//  Location_Manager.swift
//  Hoggz
//
//  Created by MACBOOK-SHUBHAM V on 27/12/19.
//  Copyright © 2019 MACBOOK-SHUBHAM V. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation


let objLocationManager = LocationSingleton.sharedObject()

protocol LocationServiceDelegate {
    func tracingLocation(currentLocation: CLLocation)
    func tracingLocationDidFailWithError(error: NSError)
}

class LocationSingleton: NSObject,CLLocationManagerDelegate {
    var locationManager: CLLocationManager?
    var lastLocation: CLLocation?
    var delegate: LocationServiceDelegate?
 
    
    // MARK: - Accessors
    class func sharedObject() -> LocationSingleton {
    return sharedInstance
    }

   static let sharedInstance:LocationSingleton = {
        let instance = LocationSingleton()
        return instance
    }()
    
    func LocationManager(){
   
//                super.init()
                self.locationManager = CLLocationManager()
                guard let locationManagers=self.locationManager else {
                    return
                }
                
                if CLLocationManager.authorizationStatus() == .notDetermined {
                    locationManagers.requestAlwaysAuthorization()
                    locationManagers.requestWhenInUseAuthorization()
                }
                if #available(iOS 9.0, *) {
        //            locationManagers.allowsBackgroundLocationUpdates = true
                } else {
                    // Fallback on earlier versions
                }
                locationManagers.desiredAccuracy = kCLLocationAccuracyBest
                locationManagers.pausesLocationUpdatesAutomatically = false
        
                locationManagers.requestAlwaysAuthorization()
        
        
                locationManagers.distanceFilter = 0.1
                locationManagers.startUpdatingLocation()
                locationManagers.delegate = self
   }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    // Update location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
        print("locationManager update")
    }
    
    @nonobjc func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager?.requestAlwaysAuthorization()
            break
        case .authorizedWhenInUse:
            locationManager?.startUpdatingLocation()
            break
        case .authorizedAlways:
            locationManager?.startUpdatingLocation()
            break
        case .restricted:
            // restricted by e.g. parental controls. User can't enable Location Services
            break
        case .denied:
            // user denied your app access to Location Services, but can grant access from Settings.app
            break
        default:
            break
        }
    }
    // Private function
    private func updateLocation(currentLocation: CLLocation){
        
        guard let delegate = self.delegate else {
            return
        }
        delegate.tracingLocation(currentLocation: currentLocation)
    }
    
    private func updateLocationDidFailWithError(error: NSError) {
        
        guard let delegate = self.delegate else {
            return
        }
        
        delegate.tracingLocationDidFailWithError(error: error)
    }

    func startUpdatingLocation() {
        print("Starting Location Updates")
        self.locationManager?.startUpdatingLocation()
//        self.locationManager?.startMonitoringSignificantLocationChanges()
    }
    func stopUpdatingLocation() {
        print("Stop Location Updates")
        self.locationManager?.stopUpdatingLocation()
    }
    
    func startMonitoringSignificantLocationChanges() {
        self.locationManager?.startMonitoringSignificantLocationChanges()
    }
    
}
