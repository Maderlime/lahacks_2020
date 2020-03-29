////
////  DrivingViewController.swift
////  Sidetracked
////
////  Created by Andrew Graves on 3/28/20.
////  Copyright © 2020 Andrew Graves. All rights reserved.
////
//
//import UIKit
//
//class DrivingViewController: UIViewController {
//    @IBOutlet weak var overlayView: OverlayView!
//    @IBOutlet weak var previewView: PreviewView!
//    
//    // Holds the results at any time
//    private var interResult: InterResult?
//    private var previousInferenceTimeMs: TimeInterval = Date.distantPast.timeIntervalSince1970 * 1000
//    
//    // Controllers that manage functionality
//    private lazy var cameraFeedManager = CameraFeedManager(previewView: previewView)
//    private var modelDataHandler: ModelDataHandler? = ModelDataHandler(modelFileInfo: MobileNetSSD.modelInfo, labelsFileInfo: MobileNetSSD.labelsInfo)
//    
//
//    
//    // MARK: View Handling
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//        cameraFeedManager.checkCameraConfigurationAndStartSession()
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(true)
//        cameraFeedManager.stopSession()
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        cameraFeedManager.delegate = self
//        // Do any additional setup after loading the view.
//    }
//    
//    
//    
//    
//    @IBAction func exitButtonPressed(_ sender: Any) {
//        dismiss(animated: true, completion: nil)
//    }
//}
//
//extension DrivingViewController: CameraFeedManagerDelegate {
//    
//    func didOutput(pixelBuffer: CVPixelBuffer) {
//        //TODO
//    }
//    
//    // MARK: Session handeling Alerts
//    func sessionRunTimeErrorOccured() {
//        // Handles session run time error
//        // TODO
//    }
//    
//    func sessionWasInterrupted(canResumeManually resumeManually: Bool) {
//        // Handle UI when the session is interrupted
//        // TODO
//        
//        if resumeManually {
//            // have a button to resume session
//        } else {
//            // Tell user the camera is unavaliable
//        }
//    }
//    
//    func sessionInterruptionEnded() {
//        // Update UI once session interruption has ended
//    }
//    
//    func presentVideoConfigurationErrorAlert() {
//        let alertController = UIAlertController(title: "Configuration Failed", message: "Configuration of camera has failed", preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//        alertController.addAction(okAction)
//    
//        present(alertController, animated: true, completion: nil)
//    }
//    
//    func presentCameraPermissionsDeniedAlert() {
//        let alertController = UIAlertController(title: "Camera Permissions Denied", message: "Camera permissions have been denied for this app. You can change this by going to Settings", preferredStyle: .alert)
//
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (action) in
//
//          UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
//        }
//
//        alertController.addAction(cancelAction)
//        alertController.addAction(settingsAction)
//
//        present(alertController, animated: true, completion: nil)
//    }
//}
