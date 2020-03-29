//
//  DrivingViewController.swift
//  Sidetracked
//
//  Created by Andrew Graves on 3/28/20.
//  Copyright © 2020 Andrew Graves. All rights reserved.
//

import UIKit
import CoreLocation

class DrivingViewController: UIViewController {
    @IBOutlet weak var overlayView: OverlayView!
    @IBOutlet weak var previewView: PreviewView!
    
    // Holds the results at any time
    private var interResult: InterResult?
    private var previousInferenceTimeMs: TimeInterval = Date.distantPast.timeIntervalSince1970 * 1000
    
    // Controllers that manage functionality
    private lazy var cameraFeedManager = CameraFeedManager(previewView: previewView)
    private var modelDataHandler: ModelDataHandler? = ModelDataHandler(modelFileInfo: MobileNetSSD.modelInfo, labelsFileInfo: MobileNetSSD.labelsInfo)
    let sidetrackedAPIClient = SidetrackedAPIClient()
    // Location manager manages everything location
     lazy var locationManager: LocationManager = {
         return LocationManager(locationDelegate: self, permissionsDelegate: nil)
     }()
    // CONSTANTS
    private let displayFont = UIFont.systemFont(ofSize: 14.0, weight: .medium)
    private let edgeOffset: CGFloat = 2.0
    private let labelOffset: CGFloat = 10.0
    private let animationDuration = 0.5
    private let collapseTransitionThreshold: CGFloat = -30.0
    private let expandThransitionThreshold: CGFloat = 30.0
    private let delayBetweenInferencesMs: Double = 200

    
    // MARK: View Handling
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        cameraFeedManager.checkCameraConfigurationAndStartSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        cameraFeedManager.stopSession()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard modelDataHandler != nil else {
            fatalError("Failed to load model")
        }
        cameraFeedManager.delegate = self
        overlayView.clearsContextBeforeDrawing = true
        
//        addPanGesture()
    }
    
    @IBAction func exitButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func reportPotholeButtonPressed(_ sender: Any) {
        
        // GET LOCATION
        locationManager.requestLocation()
    }
}

extension DrivingViewController: CameraFeedManagerDelegate {
    
    func didOutput(pixelBuffer: CVPixelBuffer) {
        runModel(onPixelBuffer: pixelBuffer)

    }
    
    // MARK: Session handeling Alerts
    func sessionRunTimeErrorOccured() {
        // Handles session run time error
        // TODO
    }
    
    func sessionWasInterrupted(canResumeManually resumeManually: Bool) {
        // Handle UI when the session is interrupted
        // TODO
        
        if resumeManually {
            // have a button to resume session
        } else {
            // Tell user the camera is unavaliable
        }
    }
    
    func sessionInterruptionEnded() {
        // Update UI once session interruption has ended
    }
    
    func presentVideoConfigurationErrorAlert() {
        let alertController = UIAlertController(title: "Configuration Failed", message: "Configuration of camera has failed", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okAction)
    
        present(alertController, animated: true, completion: nil)
    }
    
    func presentCameraPermissionsDeniedAlert() {
        let alertController = UIAlertController(title: "Camera Permissions Denied", message: "Camera permissions have been denied for this app. You can change this by going to Settings", preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (action) in

          UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        }

        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)

        present(alertController, animated: true, completion: nil)
    }
    
    /** This method runs the live camera pixelBuffer through tensorFlow to get the result.
     */
    @objc  func runModel(onPixelBuffer pixelBuffer: CVPixelBuffer) {

      // Run the live camera pixelBuffer through tensorFlow to get the result

      let currentTimeMs = Date().timeIntervalSince1970 * 1000

      guard  (currentTimeMs - previousInferenceTimeMs) >= delayBetweenInferencesMs else {
        return
      }

      previousInferenceTimeMs = currentTimeMs
      interResult = self.modelDataHandler?.runModel(onFrame: pixelBuffer)

      guard let displayResult = interResult else {
        return
      }

      let width = CVPixelBufferGetWidth(pixelBuffer)
      let height = CVPixelBufferGetHeight(pixelBuffer)

      DispatchQueue.main.async {

        // Display results by handing off to the InferenceViewController
//        self.inferenceViewController?.resolution = CGSize(width: width, height: height)

//        var inferenceTime: Double = 0
//        if let resultInferenceTime = self.interResult?.inferenceTime {
//          inferenceTime = resultInferenceTime
//        }
//        self.inferenceViewController?.inferenceTime = inferenceTime
//        self.inferenceViewController?.tableView.reloadData()

        // Draws the bounding boxes and displays class names and confidence scores.
        self.drawAfterPerformingCalculations(onInferences: displayResult.inferences, withImageSize: CGSize(width: CGFloat(width), height: CGFloat(height)))
      }
    }
    
    /**
     This method takes the results, translates the bounding box rects to the current view, draws the bounding boxes, classNames and confidence scores of inferences.
     */
    func drawAfterPerformingCalculations(onInferences inferences: [Inference], withImageSize imageSize:CGSize) {

      self.overlayView.objectOverlays = []
      self.overlayView.setNeedsDisplay()

      guard !inferences.isEmpty else {
        return
      }

      var objectOverlays: [ObjectOverlay] = []

      for inference in inferences {

        // Translates bounding box rect to current view.
        var convertedRect = inference.rect.applying(CGAffineTransform(scaleX: self.overlayView.bounds.size.width / imageSize.width, y: self.overlayView.bounds.size.height / imageSize.height))

        if convertedRect.origin.x < 0 {
          convertedRect.origin.x = self.edgeOffset
        }

        if convertedRect.origin.y < 0 {
          convertedRect.origin.y = self.edgeOffset
        }

        if convertedRect.maxY > self.overlayView.bounds.maxY {
          convertedRect.size.height = self.overlayView.bounds.maxY - convertedRect.origin.y - self.edgeOffset
        }

        if convertedRect.maxX > self.overlayView.bounds.maxX {
          convertedRect.size.width = self.overlayView.bounds.maxX - convertedRect.origin.x - self.edgeOffset
        }

        let confidenceValue = Int(inference.confidence * 100.0)
        let string = "\(inference.className)  (\(confidenceValue)%)"

        let size = string.size(usingFont: self.displayFont)

        let objectOverlay = ObjectOverlay(name: string, borderRect: convertedRect, nameStringSize: size, color: inference.displayColor, font: self.displayFont)

        objectOverlays.append(objectOverlay)
      }

      // Hands off drawing to the OverlayView
      self.draw(objectOverlays: objectOverlays)

    }
    
    func draw(objectOverlays: [ObjectOverlay]) {

      self.overlayView.objectOverlays = objectOverlays
      self.overlayView.setNeedsDisplay()
    }
    
}


extension DrivingViewController: LocationManagerDelegate {
    func obtainedPlacemark(_ placemark: CLPlacemark, location: CLLocation) {
        if let location = placemark.location {
            sidetrackedAPIClient.reportPotholeAt(lattitude: location.coordinate.latitude, longitude: location.coordinate.longitude) { result in
                switch result {
                case .success:
                    print("Added sucessfully!")
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func failedWithError(_ error: LocationError) {
        print(error)
    }
}
