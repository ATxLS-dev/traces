//
//  AnnotationView.swift
//  Traces
//
//  Created by Bryce on 7/5/23.
//
import UIKit
import SwiftUI

class AnnotationView: UIView {
    
    @ObservedObject var themeManager = ThemeManager.shared
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGestureRecognizer()
        draw(frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }
    
    private func setupGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            let hostingController = UIHostingController(rootView: TraceDetailPopup())
            hostingController.modalPresentationStyle = .automatic
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let viewController = windowScene.windows.first?.rootViewController {
                viewController.present(hostingController, animated: true)
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        let center = CGPoint(x: bounds.width/2, y: bounds.height/2)
        let radius = min(rect.width, rect.height) / 2
        
        let outerPath = UIBezierPath()
        outerPath.addArc(withCenter: center, radius: radius, startAngle: .pi * 0.6, endAngle: .pi * 2, clockwise: true)
        outerPath.addLine(to: center)
        outerPath.close()
        
        let innerPath = UIBezierPath()
        innerPath.addArc(withCenter: center, radius: bounds.width / 2.5, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        innerPath.addLine(to: center)
        innerPath.close()
        
        let outerMask = CAShapeLayer()
        outerMask.path = outerPath.cgPath
        
        let outerRing = CALayer()
        outerRing.bounds = bounds
        outerRing.position = CGPoint(x: bounds.width/2, y: bounds.height/2)
        outerRing.cornerRadius = bounds.width / 2
        outerRing.borderWidth = 1.0
        outerRing.borderColor = themeManager.theme.text.cgColor
        outerRing.mask = outerMask
        
        let innerMask = CAShapeLayer()
        let innerRingSize = bounds.width * 0.7
        innerMask.path = innerPath.cgPath
        
        let innerRing = CALayer()
   
        innerRing.bounds = CGRect(x: 0, y: 0, width: innerRingSize, height: innerRingSize)
        innerRing.position = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        innerRing.cornerRadius = innerRingSize / 2
        innerRing.borderColor = themeManager.theme.accent.cgColor
        innerRing.borderWidth = 1.6
        innerRing.mask = innerMask
        
        let outerCircle = CALayer()
        outerCircle.bounds = bounds
        outerCircle.position = CGPoint(x: bounds.width/2, y: bounds.height/2)
        
        outerCircle.addSublayer(innerRing)
        outerCircle.addSublayer(outerRing)
        layer.addSublayer(outerCircle)
        
        backgroundColor = UIColor.clear
    }
}
