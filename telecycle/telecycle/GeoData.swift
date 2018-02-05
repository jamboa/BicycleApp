//
//  GeoData.swift
//  telecycle
//
//  Created by yoojonghyun on 2017. 12. 10..
//  Copyright © 2017년 yoojonghyun. All rights reserved.
//

import Foundation
import CoreLocation

protocol GeoDataDelegate {
    func tracingLocation(currentLocation: CLLocation)
    func tracingLocationDidFailWithError(error: NSError)
}

class GeoData: NSObject, CLLocationManagerDelegate {
    
    static let sharedInstance: GeoData = GeoData()
    
    var locationManager: CLLocationManager?
    var currentLocation: CLLocation?
    var delegate: GeoDataDelegate?
    private var previousLocation : CLLocation?
    private var distance : Double = 0.0
    
    private override init() {
        super.init()
        
        self.locationManager = CLLocationManager()
        guard let locationManager = self.locationManager else {
            return
        }
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
//            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.activityType = CLActivityType.automotiveNavigation
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = 30 // The minimum distance (measured in meters) a device must move horizontally before an update event is generated.
        locationManager.delegate = self
    }
    
    func startUpdatingLocation() {
        print("Starting Location Updates")
        self.locationManager?.startUpdatingLocation()
        distance = 0.0
    }
    
    func stopUpdatingLocation() {
        print("Stop Location Updates")
        self.locationManager?.stopUpdatingLocation()
        
    }
    
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
         print("puased")
    }
    
    // CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else {
            return
        }
        
        // singleton for get last(current) location
        self.currentLocation = location
        
        // use for real time update location
        updateLocation(currentLocation: location)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("test")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        // do on error
        updateLocationDidFailWithError(error: error as NSError)
    }
    
    // Private function
    private func updateLocation(currentLocation: CLLocation){
        
        print("data updated!!")
        
        guard let delegate = self.delegate else {
            return
        }
        
        delegate.tracingLocation(currentLocation: currentLocation)
    }
    
    private func updateLocationDidFailWithError(error: NSError) {
        
        guard let delegate = self.delegate else {
            return
        }
        
        delegate.tracingLocationDidFailWithError(error:error)
    }
    
    func getSpeed() -> Double{
        guard let location = GeoData.sharedInstance.currentLocation else {
            return 0
        }
        return location.speed >= 0 ? location.speed * 3.6 : 0
    }
    
    func getDistance() -> Double{
        guard let currentLocation = GeoData.sharedInstance.currentLocation else {
            return 0
        }
        if let previousLocatinoUnwrapped = previousLocation {
            distance = distance + currentLocation.distance(from: previousLocatinoUnwrapped)
        }
        previousLocation = GeoData.sharedInstance.currentLocation
        
        return distance
    }
}
