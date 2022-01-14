//
//  LocationManager.swift
//  Geofencing
//
//  Created by M3ts LLC on 1/13/22.
//

import UIKit
import CoreLocation
import UserNotifications

class LocationManager : NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    let manager = CLLocationManager()
    var completion: ((CLLocation) -> Void)?
    
    public func getUserLocation(completion: @escaping ((CLLocation) -> Void)) {
        self.completion = completion
        // manager.requestWhenInUseAuthorization()
        manager.requestAlwaysAuthorization()
        manager.delegate = self
        manager.startUpdatingLocation()
        manager.distanceFilter = 100
        let geoFenceRegion:CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2DMake(35.27213836, -97.48290558), radius: 100, identifier: "M3T") // This is the  coordinate for M3Ts office, ==> need to change to any location for geoFenceRegion...
        manager.startMonitoring(for: geoFenceRegion)
        //  scheduleLocationNotifications(region: geoFenceRegion) // ==> This line of code have not work yet!
    }
    
    public func resolveLocationName(with location: CLLocation, completion: @escaping ((String?) -> Void)) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, preferredLocale: .current) { placemarks, error in
            guard let place = placemarks?.first, error == nil else {
                completion(nil)
                return
            }
            print("\(Date()) -- Place : \(place) -- \("\(#line) --- OF \(#function) --- IN \(#file)")")
            var name = ""
            if let locality = place.locality {
                name += locality
            }
            if let adminRegion = place.administrativeArea {
                name += ", \(adminRegion)"
            }
            print("\(Date()) -- Place's Name : \(name) -- \("\(#line) --- OF \(#function) --- IN \(#file)")")
            completion(name)
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {return}
        print("Location : \(location)")
        completion?(location)
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("\(Date()) -- Entered: \(region.identifier) ==> Do something -- \("\(#line) --- OF \(#function) --- IN \(#file)")")
        // Do Something...
        postLocalNotifications(eventTitle: "Entered: \(region.identifier)")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("\(Date()) -- Exited: \(region.identifier) ==> Do something -- \("\(#line) --- OF \(#function) --- IN \(#file)")")
        // Do Something...
        postLocalNotifications(eventTitle: "Exited: \(region.identifier)")
    }
}

// MARK: - Notification ==> Register Notification on AppDelegate
extension LocationManager {
    func postLocalNotifications(eventTitle: String){
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = eventTitle
        content.body = "You've entered a new region"
        content.sound = .default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let notificationRequest:UNNotificationRequest = UNNotificationRequest(identifier: "Region", content: content, trigger: trigger)
        center.add(notificationRequest, withCompletionHandler: { (error) in
            if let error = error {
                print("\(Date()) -- Unable to add notification request: \(error.localizedDescription) -- \("\(#line) --- OF \(#function) --- IN \(#file)")")
            } else{
                print("\(Date()) -- Successfully Add notification request -- \("\(#line) --- OF \(#function) --- IN \(#file)")")
            }
        })
    }
    
    // MARK: - scheduleLocationNotifications ==> Need to be test and work on this...
    func scheduleLocationNotifications(region: CLCircularRegion) {
        let content = UNMutableNotificationContent()
        content.title = "Location Entered / Exited !"
        content.body = "You are enter the \(region.identifier). "
        content.sound = .default
        let trigger = UNLocationNotificationTrigger(region: region, repeats: false)
        let request = UNNotificationRequest(identifier: "\(region.identifier)", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Unable to add notification request: \(error.localizedDescription)")
            }
        }
    }
}
