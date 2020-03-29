//
//  PotholeMapViewController.swift
//  Sidetracked
//
//  Created by Andrew Graves on 3/28/20.
//  Copyright © 2020 Andrew Graves. All rights reserved.
//

import UIKit
import GoogleMaps
import MapKit
import MobileCoreServices

class PotholeMapViewController: UIViewController {
    
    // TEMP DATA FOR TESTING PINS
    let tempData: [Pothole] = [
        Pothole(latitude: 34.247675, longitude: -118.821160, image: nil, rating: nil),
        Pothole(latitude: 34.248367, longitude: -118.820308, image: nil, rating: nil),
        Pothole(latitude: 34.246584, longitude: -118.822014, image: nil, rating: nil),
        Pothole(latitude: 34.244837, longitude: -118.822036, image: nil, rating: nil),
        Pothole(latitude: 34.251311, longitude: -118.822025, image: nil, rating: nil)
    ]
    
    // Location manager manages everything location
    lazy var locationManager: LocationManager = {
        return LocationManager(locationDelegate: self, permissionsDelegate: nil)
    }()
    
    
    // MARK: Instance variables
    var clLocation: CLLocation? = nil {
        didSet {
            if let clLocation = clLocation {
                print("Location was set")
                goToLocation(clLocation)
            }
        }
    }
    
    var placemark: CLPlacemark? = nil {
        didSet {
            if let placemark = placemark {
                clLocation = placemark.location
            }
        }
    }
    
    var mapView: GMSMapView? = nil
    
    
    // MARK: View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Request the current location
        locationManager.requestLocation()
    }
    

    // Function that requests the current location
    
    func dropPinsFor(potholes: [Pothole]) {
        for pothole in potholes {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: pothole.latitude, longitude: pothole.longitude)
            marker.title = "Pothole"
            marker.snippet = "It do be here"
            marker.map = mapView
        }
    }
    
    func goToLocation(_ location: CLLocation) {
        
        // NEW GOOGLE MAPS
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 15)
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        self.mapView = mapView
        self.view.addSubview(mapView)
        self.view.sendSubviewToBack(mapView)
    }
    
    
    
    // MARK: Helper Classes
    
    // Create an alert with a given title and description
    func createAlert(withTitle title: String, andDescription description: String){
        let alertController = UIAlertController(title: title, message: description, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "dismiss", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}


// MARK: Extensions

extension PotholeMapViewController: LocationManagerDelegate {
    func obtainedPlacemark(_ placemark: CLPlacemark, location: CLLocation) {
        self.placemark = placemark
        dropPinsFor(potholes: tempData)
    }
    
    func failedWithError(_ error: LocationError) {
        func failedWithError(_ error: LocationError) {
            switch error {
            case .disallowedByUser:
                createAlert(withTitle: "Location Access Needed", andDescription: "Please allow access to the location data to use this feature")

            case .unableToFindLocation:
                createAlert(withTitle: "Unable to Find Location", andDescription: "Somthing went wrong with the retrevial of your location...")
                
            case .unknownError:
                createAlert(withTitle: "Unknown Error", andDescription: "There was an unknown error...")
            }
        }
    }
}


