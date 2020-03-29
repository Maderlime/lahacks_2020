//
//  OverlayView.swift
//  Sidetracked
//
//  Created by Andrew Graves on 3/28/20.
//  Copyright © 2020 Andrew Graves. All rights reserved.
//

import UIKit

// Display parameters for objects that are detected (USING FOR TESTING)
struct ObjectOverlay {
  let name: String
  let borderRect: CGRect
  let nameStringSize: CGSize
  let color: UIColor
  let font: UIFont
}

class OverlayView: UIView {
    var objectOverlays: [ObjectOverlay] = []
    private let cornerRadius: CGFloat = 10.0
    private let stringBgAlpha: CGFloat
      = 0.7
    private let lineWidth: CGFloat = 3
    private let stringFontColor = UIColor.white
    private let stringHorizontalSpacing: CGFloat = 13.0
    private let stringVerticalSpacing: CGFloat = 7.0
    
    override func draw(_ rect: CGRect) {
        
        // Drawing code
        for objectOverlay in objectOverlays {
            drawBorders(of: objectOverlay)
            drawBackground(of: objectOverlay)
            drawName(of: objectOverlay)
        }
    }
    
    // This method draws the borders around detected objects
    func drawBorders(of objectOverlay: ObjectOverlay) {
        let path = UIBezierPath(rect: objectOverlay.borderRect)
        path.lineWidth = lineWidth
        objectOverlay.color.setStroke()
        
        path.stroke()
    }
    
    // This method draws the background of the string
    func drawBackground(of objectOverlay: ObjectOverlay) {

      let stringBgRect = CGRect(x: objectOverlay.borderRect.origin.x, y: objectOverlay.borderRect.origin.y , width: 2 * stringHorizontalSpacing + objectOverlay.nameStringSize.width, height: 2 * stringVerticalSpacing + objectOverlay.nameStringSize.height
      )

      let stringBgPath = UIBezierPath(rect: stringBgRect)
      objectOverlay.color.withAlphaComponent(stringBgAlpha).setFill()
      stringBgPath.fill()
    }
    
    
    
    // Draws the name of the object
    func drawName(of objectOverlay: ObjectOverlay) {

      // Draws the string.
      let stringRect = CGRect(x: objectOverlay.borderRect.origin.x + stringHorizontalSpacing, y: objectOverlay.borderRect.origin.y + stringVerticalSpacing, width: objectOverlay.nameStringSize.width, height: objectOverlay.nameStringSize.height)

      let attributedString = NSAttributedString(string: objectOverlay.name, attributes: [NSAttributedString.Key.foregroundColor : stringFontColor, NSAttributedString.Key.font : objectOverlay.font])
      attributedString.draw(in: stringRect)
    }
}
