//
//  PotholeMapViewController.swift
//  Sidetracked
//
//  Created by Andrew Graves on 3/28/20.
//  Copyright © 2020 Andrew Graves. All rights reserved.
//

import UIKit
import MapKit
import MobileCoreServices

class PotholeMapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    var clLocation: CLLocation? = nil {
        didSet {
            if let clLocation = clLocation {
                print("Location was set")
                goToLocation(clLocation)
            }
        }
    }
    
    var placemark: CLPlacemark? = nil
    
    // MARK: Helper Classes
    lazy var locationManager: LocationManager = {
        return LocationManager(locationDelegate: self, permissionsDelegate: nil)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        
        // Setup
        setupMap()
        getCurrentLocation()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: Location + Map Functions
    
    func setupMap() {
        mapView.showsUserLocation = true
    }
    
    func getCurrentLocation() {
        locationManager.requestLocation()
    }
    
    func goToLocation(_ location: CLLocation) {
        // create cemter and region
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        // set map region and overlays
        mapView.setRegion(region, animated: true)
        
        // TODO Remove reload the pins either if its passed a certain time or a zone is left
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
    
    func obtainedPlacemark(_ placemark: CLPlacemark, location: CLLocation) {
        clLocation = location
        self.placemark = placemark
    }
}


