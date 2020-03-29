//
//  Pothole.swift
//  Sidetracked
//
//  Created by Andrew Graves on 3/28/20.
//  Copyright © 2020 Andrew Graves. All rights reserved.
//

import Foundation
import UIKit

enum ImageState {
    case placeholder
    case downloaded
    case failed
}

class Pothole: Decodable {
    let latitude: Double
    let longitude: Double
    let id: Int
    let imageSrc: URL?
    let rating: Double?
    let description: String?
    
    var image: UIImage? = nil
    var imageState = ImageState.placeholder
    
    init()  {
        self.id = 0
        self.imageSrc = URL(string: "")!
        self.latitude = 0
        self.longitude = 0
        self.rating = 0
        self.description = ""
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case longitude
        case latitude
        case imageSrc = "picture"
        case rating
        case description
        
    }
}
