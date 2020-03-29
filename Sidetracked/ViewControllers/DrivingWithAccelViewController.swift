//
//  DrivingWithAccelViewController.swift
//  Sidetracked
//
//  Created by Andrew Graves on 3/28/20.
//  Copyright © 2020 Andrew Graves. All rights reserved.
//

import UIKit
import CoreMotion

class DrivingWithAccelViewController: UIViewController {
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    @IBOutlet weak var label6: UILabel!
    
    let motion = CMMotionManager()
    let timeInterval: TimeInterval = 0.1
    let numberFormatter = NumberFormatter()
    let accelQueue = PendingOperations().accelerationDataFetchInProgress
    var sumOfData: Double = 0
    let accelerationThreshold: Double = 1.5
    
    var averageTotal: Double = 0 {
        didSet {
            label5.text = String(averageTotal)
            
            // If the sum of all the data is greater then the average then there is an abnormality
            if sumOfData > averageTotal + accelerationThreshold {
                print("Pothole!")
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // configure number formatter
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        
        // Frequency of updates (5 times a second)
        motion.accelerometerUpdateInterval = timeInterval
        motion.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
            if error != nil {
                // There was an error
                fatalError("\(error)")
            } else {
                
                if let data = data {
                    
                    // the first 3 labels display data for the x, y and z axis of accel
                    self.label1.text = self.numberFormatter.string(from: NSNumber(value: data.acceleration.x))
                    self.label2.text = self.numberFormatter.string(from: NSNumber(value: data.acceleration.y))
                    self.label3.text = self.numberFormatter.string(from: NSNumber(value: data.acceleration.z))
                    
                    // get the sum of the abs of all the planes of movement
                    self.sumOfData = abs(data.acceleration.x) + abs(data.acceleration.y) + abs(data.acceleration.z)
                    self.averageTotal = (self.averageTotal + self.sumOfData) / 2
                    
                }
            }
        }
    }
}
