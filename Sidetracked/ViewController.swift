//
//  ViewController.swift
//  Sidetracked
//
//  Created by Andrew Graves on 3/28/20.
//  Copyright © 2020 Andrew Graves. All rights reserved.
//

import UIKit
import YogaKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let contentView = UIView()
        contentView.backgroundColor = .red
        
        contentView.configureLayout { (layout) in
            layout.isEnabled = true
            
            layout.flexDirection = .row
            layout.width = 320
            layout.height = 80
            layout.marginTop = 40
            layout.marginLeft = 10
        }
        
        view.addSubview(contentView)
        
        contentView.yoga.applyLayout(preservingOrigin: true)
    }
}

