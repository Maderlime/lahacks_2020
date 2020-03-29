//
//  PotholeDetails.swift
//  Sidetracked
//
//  Created by Andrew Graves on 3/29/20.
//  Copyright © 2020 Andrew Graves. All rights reserved.
//

import Foundation
import UIKit

class PotholeDetails: Decodable {
    let id: Int
    let imageSrc: URL?
    let rating: Double?
    let description: String?
    
    var image: UIImage? = nil
    var imageState = ImageState.placeholder
    
    init()  {
        self.id = 0
        self.imageSrc = nil
        self.rating = 0
        self.description = ""
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case imageSrc = "picture"
        case rating
        case description
        
    }
}
