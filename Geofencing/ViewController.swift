//
//  ViewController.swift
//  Geofencing
//
//  Created by M3ts LLC on 1/13/22.
//

import CoreLocation
import UIKit
import MapKit

class ViewController: UIViewController {
    // MARK: - Properties
    private let map: MKMapView = {
        let map = MKMapView()
        return map
    }()
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(map)
        title = "Home"
        LocationManager.shared.getUserLocation { [weak self] location in
            DispatchQueue.main.async {
                guard let strongSelf = self else {return}
                strongSelf.addMapPin(location: location)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        map.frame = view.bounds
    }
    
    // MARK: - Helper Functions
    func addMapPin(location: CLLocation) {
        let pin = MKPointAnnotation()
        pin.coordinate = location.coordinate
        // set camera to zoom in
        map.setRegion(MKCoordinateRegion(center: location.coordinate,
                                         span: MKCoordinateSpan(latitudeDelta: 0.7, longitudeDelta: 0.7)),
                      animated: true)
        map.addAnnotation(pin)
        LocationManager.shared.resolveLocationName(with: location) { [weak self] locationName in
            self?.title = locationName
        }
    }
}

