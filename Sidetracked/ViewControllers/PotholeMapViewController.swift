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
//    let tempData: [Pothole] = [
//        Pothole(latitude: 34.247675, longitude: -118.821160, image: nil, rating: nil),
//        Pothole(latitude: 34.248367, longitude: -118.820308, image: nil, rating: nil),
//        Pothole(latitude: 34.246584, longitude: -118.822014, image: nil, rating: nil),
//        Pothole(latitude: 34.244837, longitude: -118.822036, image: nil, rating: nil),
//        Pothole(latitude: 34.251311, longitude: -118.822025, image: nil, rating: nil)
//    ]
    
    var potholes: [Pothole]? = nil {
        didSet {
            if let potholes = potholes {
                dropPinsFor(potholes: potholes)
            }
        }
    }
    
    var selectedPothole: Pothole? = nil {
        didSet {
            if let selectedPothole = selectedPothole {
                
                DispatchQueue.main.async {
                    // Create the detail view controller and present modaly
                    let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
                    detailViewController.pothole = selectedPothole
                    self.present(detailViewController, animated: true, completion: nil)
                }
            }
        }
    }
    
    let sidetrackedAPIClient = SidetrackedAPIClient()
    let pendingOperations = PendingOperations()
    
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
    
    var mapView: GMSMapView? = nil {
        didSet {
            if let mapView = mapView {
                mapView.delegate = self
            }
        }
    }
    
    
    // MARK: View did load
    override func viewDidLoad() {
        super.viewDidLoad()
            
        // Request the current location
        locationManager.requestLocation()
    }
    

    // Load in the pin data
    
    func loadPinData() {
        sidetrackedAPIClient.getPotholesNear(lattitude: 0, longitude: 0) { result in
            switch result {
            case .success(let data):
                self.potholes = data
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func dropPinsFor(potholes: [Pothole]) {
        DispatchQueue.main.async {
            for pothole in potholes {
                let marker = GMSMarker()
                marker.appearAnimation = .pop
                marker.position = CLLocationCoordinate2D(latitude: pothole.latitude, longitude: pothole.longitude)
                marker.title = "Pothole"
                marker.snippet = String(pothole.id);
                marker.map = self.mapView
            }
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
    
    // get the details
    func getDetailsFor(id: Int) {
        sidetrackedAPIClient.getPotholeDetails(withId: id) { result in
            switch result {
            case .success(let data):
                self.selectedPothole = data
                
            case .failure(let error):
                print(error)
            }
        }
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
        loadPinData()
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

extension PotholeMapViewController: GMSMapViewDelegate {
    
    // Called when a marker is tapped
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print("Marker was tapped! \(marker.title)")
        
        // get the information for that specific pothole
        print("THE ID IS \(Int(marker.snippet!)!)")
        getDetailsFor(id: Int(marker.snippet!)!)

        
//        // Create the detail view controller and present modaly
//        let detailViewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
//        present(detailViewController, animated: true, completion: nil)
        
        return true
    }
}


