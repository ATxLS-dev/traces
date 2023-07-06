//
//  IceCreamView.swift
//  Traces
//
//  Created by Bryce on 7/5/23.
//

import UIKit

class IceCreamView: UIView {
    var text: String = "" {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(ovalIn: rect)
        
        // Set the stroke color and width
        UIColor.black.setStroke()
        path.lineWidth = 2.0
        
        // Set the fill color to clear
        UIColor.clear.setFill()
        
        // Fill and stroke the path
        path.fill()
        path.stroke()
    }
}
