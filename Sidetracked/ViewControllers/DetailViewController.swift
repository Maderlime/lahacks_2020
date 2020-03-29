//
//  DetailViewController.swift
//  Sidetracked
//
//  Created by Andrew Graves on 3/28/20.
//  Copyright © 2020 Andrew Graves. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var rating1: UIButton!
    @IBOutlet weak var rating2: UIButton!
    @IBOutlet weak var rating3: UIButton!
    @IBOutlet weak var rating4: UIButton!
    @IBOutlet weak var rating5: UIButton!
    
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var returnButton: UIButton!
    
    var pothole: Pothole? = nil {
        didSet {
            if let pothole = pothole {
                titleLabel.text = "\(pothole.latitude) + \(pothole.longitude)"
                
                if let rating = pothole.rating {
                    setRating(rating)

                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func rating1Pressed(_ sender: Any) {
        setRating(1)
    }
    
    @IBAction func rating2Pressed(_ sender: Any) {
        setRating(2)
    }
    
    @IBAction func rating3Pressed(_ sender: Any) {
        setRating(3)
    }
    
    @IBAction func rating4Pressed(_ sender: Any) {
        setRating(4)
    }
    
    @IBAction func rating5Pressed(_ sender: Any) {
        setRating(5)
    }
    
    @IBAction func returnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func setupDetailViewController(with pothole: Pothole) {
        self.pothole = pothole
    }
    
    func setRating(_ rating: Double) {
        if rating >= 4.5 {
            rating5.setImage(#imageLiteral(resourceName: "1"), for: .normal)
            rating4.setImage(#imageLiteral(resourceName: "1"), for: .normal)
            rating3.setImage(#imageLiteral(resourceName: "1"), for: .normal)
            rating2.setImage(#imageLiteral(resourceName: "1"), for: .normal)
            rating1.setImage(#imageLiteral(resourceName: "1"), for: .normal)
            
        } else if rating >= 4 {
            rating5.setImage(#imageLiteral(resourceName: "0"), for: .normal)
            rating4.setImage(#imageLiteral(resourceName: "1"), for: .normal)
            rating3.setImage(#imageLiteral(resourceName: "1"), for: .normal)
            rating2.setImage(#imageLiteral(resourceName: "1"), for: .normal)
            rating1.setImage(#imageLiteral(resourceName: "1"), for: .normal)
            
        } else if rating >= 3.5 {
            rating5.setImage(#imageLiteral(resourceName: "0"), for: .normal)
            rating4.setImage(#imageLiteral(resourceName: "1"), for: .normal)
            rating3.setImage(#imageLiteral(resourceName: "1"), for: .normal)
            rating2.setImage(#imageLiteral(resourceName: "1"), for: .normal)
            rating1.setImage(#imageLiteral(resourceName: "1"), for: .normal)
            
        } else if rating >= 3 {
            rating5.setImage(#imageLiteral(resourceName: "0"), for: .normal)
            rating4.setImage(#imageLiteral(resourceName: "0"), for: .normal)
            rating3.setImage(#imageLiteral(resourceName: "1"), for: .normal)
            rating2.setImage(#imageLiteral(resourceName: "1"), for: .normal)
            rating1.setImage(#imageLiteral(resourceName: "1"), for: .normal)
            
        } else if rating >= 2.5 {
            rating5.setImage(#imageLiteral(resourceName: "0"), for: .normal)
            rating4.setImage(#imageLiteral(resourceName: "0"), for: .normal)
            rating3.setImage(#imageLiteral(resourceName: "0.5"), for: .normal)
            rating2.setImage(#imageLiteral(resourceName: "1"), for: .normal)
            rating1.setImage(#imageLiteral(resourceName: "1"), for: .normal)
            
        } else if rating >= 2 {
            rating5.setImage(#imageLiteral(resourceName: "0"), for: .normal)
            rating4.setImage(#imageLiteral(resourceName: "0"), for: .normal)
            rating3.setImage(#imageLiteral(resourceName: "0"), for: .normal)
            rating2.setImage(#imageLiteral(resourceName: "1"), for: .normal)
            rating1.setImage(#imageLiteral(resourceName: "1"), for: .normal)
            
        } else if rating >= 1.5 {
            rating5.setImage(#imageLiteral(resourceName: "0"), for: .normal)
            rating4.setImage(#imageLiteral(resourceName: "0"), for: .normal)
            rating3.setImage(#imageLiteral(resourceName: "0"), for: .normal)
            rating2.setImage(#imageLiteral(resourceName: "0.5"), for: .normal)
            rating1.setImage(#imageLiteral(resourceName: "1"), for: .normal)
            
        } else if rating >= 1 {
            rating5.setImage(#imageLiteral(resourceName: "0"), for: .normal)
            rating4.setImage(#imageLiteral(resourceName: "0"), for: .normal)
            rating3.setImage(#imageLiteral(resourceName: "0"), for: .normal)
            rating2.setImage(#imageLiteral(resourceName: "0"), for: .normal)
            rating1.setImage(#imageLiteral(resourceName: "1"), for: .normal)
            
        } else if rating >= 0.5 {
            rating5.setImage(#imageLiteral(resourceName: "0"), for: .normal)
            rating4.setImage(#imageLiteral(resourceName: "0"), for: .normal)
            rating3.setImage(#imageLiteral(resourceName: "0"), for: .normal)
            rating2.setImage(#imageLiteral(resourceName: "0"), for: .normal)
            rating1.setImage(#imageLiteral(resourceName: "0.5"), for: .normal)
            
        } else {
            rating5.setImage(#imageLiteral(resourceName: "0"), for: .normal)
            rating4.setImage(#imageLiteral(resourceName: "0"), for: .normal)
            rating3.setImage(#imageLiteral(resourceName: "0"), for: .normal)
            rating2.setImage(#imageLiteral(resourceName: "0"), for: .normal)
            rating1.setImage(#imageLiteral(resourceName: "0"), for: .normal)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
