//
//  CameraFeedManager.swift
//  Sidetracked
//
//  Created by Andrew Graves on 3/28/20.
//  Copyright © 2020 Andrew Graves. All rights reserved.
//

import UIKit
import AVFoundation

// MARK: Camera FeedManagerDelegate Declaration
protocol CameraFeedManagerDelegate: class {

  /**
   This method delivers the pixel buffer of the current frame seen by the device's camera.
   */
  func didOutput(pixelBuffer: CVPixelBuffer)

  /**
   This method initimates that the camera permissions have been denied.
   */
  func presentCameraPermissionsDeniedAlert()

  /**
   This method initimates that there was an error in video configurtion.
   */
  func presentVideoConfigurationErrorAlert()

  /**
   This method initimates that a session runtime error occured.
   */
  func sessionRunTimeErrorOccured()

  /**
   This method initimates that the session was interrupted.
   */
  func sessionWasInterrupted(canResumeManually resumeManually: Bool)

  /**
   This method initimates that the session interruption has ended.
   */
  func sessionInterruptionEnded()

}

// Holds the state of camera init
enum CameraConfiguration {
    case success
    case failed
    case permissionDenied
}

// Manages all class related functions
class CameraFeedManager: NSObject {
    
    // Instance Vars
    private let session: AVCaptureSession = AVCaptureSession()
    private let previewView: PreviewView
    private let sessionQueue = DispatchQueue(label: "sessionQueue")
    private var cameraConfiguration: CameraConfiguration = .failed
    private lazy var videoDataOutput = AVCaptureVideoDataOutput()
    private var isSessionRunning = false
    
    // CameraFeedManagerDelegate
    weak var delegate: CameraFeedManagerDelegate?
    
    // MARK: init
    init(previewView: PreviewView) {
        self.previewView = previewView
        super.init()
        
        // initalise the session
        session.sessionPreset = .high
        self.previewView.session = session
        self.previewView.previewLayer.connection?.videoOrientation = .portrait
        self.previewView.previewLayer.videoGravity = .resizeAspectFill
        self.attemptToConfigureSession()
    }
    
    // MARK: Session start and end methods
    
    // this starts an AVCaptureSession based on wheather the camera configuration was sucessful
    func checkCameraConfigurationAndStartSession() {
        sessionQueue.async {
            switch self.cameraConfiguration {
            case .success:
                self.addObservers()
                self.startSession()
                
            case .failed:
                DispatchQueue.main.async {
                    self.delegate?.presentVideoConfigurationErrorAlert()
                }
            case .permissionDenied:
                DispatchQueue.main.async {
                    self.delegate?.presentCameraPermissionsDeniedAlert()
                }
            }
        }
    }
    
    // This stops a running AVCaptureSession
    func stopSession() {
        self.removeObservers()
        sessionQueue.async {
            if self.session.isRunning {
                self.session.stopRunning()
                self.isSessionRunning = self.session.isRunning
            }
        }
    }
    
    // Resumes an interrupted capture session
    func resumeInterruptedSession(withCompletion completion: @escaping (Bool) -> ()) {
        sessionQueue.async {
            self.startSession()
            
            DispatchQueue.main.async {
                completion(self.isSessionRunning)
            }
        }
    }
    
    // Starts capture session
    private func startSession() {
        self.session.startRunning()
        self.isSessionRunning = self.session.isRunning
    }
    
    // MARK: Session congiguration methods
    
    // requests camera permissions and congigures the session
    private func attemptToConfigureSession() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            self.cameraConfiguration = .success
            
        case .notDetermined:
            self.sessionQueue.suspend()
            self.requestCameraAccess( completion: {(granted) in
                self.sessionQueue.resume()
            })
        case .denied:
            self.cameraConfiguration = .permissionDenied
            
        default:
            break
        }
        
        self.sessionQueue.async {
            self.configureSession()
        }
    }
    
    // Requests camera permissions
    private func requestCameraAccess (completion: @escaping (Bool) -> ()) {
        AVCaptureDevice.requestAccess(for: .video) { (granted) in
            if !granted {
                self.cameraConfiguration = .permissionDenied
            } else {
                self.cameraConfiguration = .success
            }
            completion(granted)
        }
    }
    
    // handles all steps to configure the AVCaptureSession
    private func configureSession() {

      guard cameraConfiguration == .success else {
        return
      }
      session.beginConfiguration()

      // Tries to add an AVCaptureDeviceInput.
      guard addVideoDeviceInput() == true else {
        self.session.commitConfiguration()
        self.cameraConfiguration = .failed
        return
      }

      // Tries to add an AVCaptureVideoDataOutput.
      guard addVideoDataOutput() else {
        self.session.commitConfiguration()
        self.cameraConfiguration = .failed
        return
      }

      session.commitConfiguration()
        self.cameraConfiguration = .success
    }
    
    
    // Tries to use an AVCaptureDEviceInput to the current AVCaptureSession
    private func addVideoDeviceInput() -> Bool {

      // Tries to get the default back camera
      guard let camera  = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
        fatalError("Cannot find camera")
      }

      do {
        let videoDeviceInput = try AVCaptureDeviceInput(device: camera)
        if session.canAddInput(videoDeviceInput) {
          session.addInput(videoDeviceInput)
          return true
        }
        else {
          return false
        }
      }
      catch {
        fatalError("Cannot create video device input")
      }
    }
    
     //This method tries to an AVCaptureVideoDataOutput to the current AVCaptureSession.
    private func addVideoDataOutput() -> Bool {

      let sampleBufferQueue = DispatchQueue(label: "sampleBufferQueue")
      videoDataOutput.setSampleBufferDelegate(self, queue: sampleBufferQueue)
      videoDataOutput.alwaysDiscardsLateVideoFrames = true
      videoDataOutput.videoSettings = [ String(kCVPixelBufferPixelFormatTypeKey) : kCMPixelFormat_32BGRA]

      if session.canAddOutput(videoDataOutput) {
        session.addOutput(videoDataOutput)
        videoDataOutput.connection(with: .video)?.videoOrientation = .portrait
        return true
      }
      return false
    }
    
    // MARK: Notification Observer Handling
    private func addObservers() {
      NotificationCenter.default.addObserver(self, selector: #selector(CameraFeedManager.sessionRuntimeErrorOccured(notification:)), name: NSNotification.Name.AVCaptureSessionRuntimeError, object: session)
      NotificationCenter.default.addObserver(self, selector: #selector(CameraFeedManager.sessionWasInterrupted(notification:)), name: NSNotification.Name.AVCaptureSessionWasInterrupted, object: session)
      NotificationCenter.default.addObserver(self, selector: #selector(CameraFeedManager.sessionInterruptionEnded), name: NSNotification.Name.AVCaptureSessionInterruptionEnded, object: session)
    }

    private func removeObservers() {
      NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVCaptureSessionRuntimeError, object: session)
      NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVCaptureSessionWasInterrupted, object: session)
      NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVCaptureSessionInterruptionEnded, object: session)
    }
    
    // MARK: Notification Observers
    @objc func sessionWasInterrupted(notification: Notification) {

      if let userInfoValue = notification.userInfo?[AVCaptureSessionInterruptionReasonKey] as AnyObject?,
        let reasonIntegerValue = userInfoValue.integerValue,
        let reason = AVCaptureSession.InterruptionReason(rawValue: reasonIntegerValue) {
        print("Capture session was interrupted with reason \(reason)")

        var canResumeManually = false
        if reason == .videoDeviceInUseByAnotherClient {
          canResumeManually = true
        } else if reason == .videoDeviceNotAvailableWithMultipleForegroundApps {
          canResumeManually = false
        }

        self.delegate?.sessionWasInterrupted(canResumeManually: canResumeManually)

      }
    }

    @objc func sessionInterruptionEnded(notification: Notification) {

      self.delegate?.sessionInterruptionEnded()
    }

    @objc func sessionRuntimeErrorOccured(notification: Notification) {
      guard let error = notification.userInfo?[AVCaptureSessionErrorKey] as? AVError else {
        return
      }

      print("Capture session runtime error: \(error)")

      if error.code == .mediaServicesWereReset {
        sessionQueue.async {
          if self.isSessionRunning {
            self.startSession()
          } else {
            DispatchQueue.main.async {
              self.delegate?.sessionRunTimeErrorOccured()
            }
          }
        }
      } else {
        self.delegate?.sessionRunTimeErrorOccured()

      }
    }
}

/**
 AVCaptureVideoDataOutputSampleBufferDelegate
 */
extension CameraFeedManager: AVCaptureVideoDataOutputSampleBufferDelegate {

  /** This method delegates the CVPixelBuffer of the frame seen by the camera currently.
   */
  func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {

    // Converts the CMSampleBuffer to a CVPixelBuffer.
    let pixelBuffer: CVPixelBuffer? = CMSampleBufferGetImageBuffer(sampleBuffer)

    guard let imagePixelBuffer = pixelBuffer else {
      return
    }

    // Delegates the pixel buffer to the ViewController.
    delegate?.didOutput(pixelBuffer: imagePixelBuffer)
  }

}
