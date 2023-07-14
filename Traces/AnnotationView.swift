//
//  AnnotationView.swift
//  Traces
//
//  Created by Bryce on 7/5/23.
//
import UIKit
import SwiftUI


class AnnotationView: UIView, Identifiable {
    
    var id: UUID?
    
    @ObservedObject var themeManager = ThemeManager.shared
    var trace: Trace?

    init(frame: CGRect, trace: Trace? = nil) {
        super.init(frame: frame)
        self.trace = trace
//        setupGestureRecognizer()
        draw(frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
//    private func setupGestureRecognizer() {
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
//        addGestureRecognizer(tapGesture)
//        isUserInteractionEnabled = true
//    }
//
//    @objc private func handleTapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
//        self.id = trace?.id
//        if gestureRecognizer.state == .ended {
//            guard let trace = trace else { return }
//            print(trace.locationName)
//            let traceDetailPopup = TraceDetailPopup(trace: trace)
//            traceDetailPopup.showAndStack()
//        }
//    }
    
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

//
//class AnnotationView: UIView, Identifiable {
//
//    var id: UUID?
//
//    @ObservedObject var themeManager = ThemeManager.shared
//    var trace: Trace?
//
//    static var counter: Int = 0
//
//    init(frame: CGRect, trace: Trace? = nil) {
//        super.init(frame: frame)
//        self.trace = trace
//        setupGestureRecognizer()
//        draw(frame)
//        AnnotationView.counter += 1
////        print("AnnotationView instances created: \(AnnotationView.counter)")
//    }
//
//    required init?(coder aDecoder: NSCoder) {
////        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
//
//    }
//
//    private func setupGestureRecognizer() {
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
//        addGestureRecognizer(tapGesture)
//        isUserInteractionEnabled = true
//    }
//
//    @objc private func handleTapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
//        self.id = trace?.id
//        print(self.id)
//        if gestureRecognizer.state == .ended {
//            guard let trace = trace else { return }
//            print(trace.locationName)
//            let traceDetailPopup = TraceDetailPopup(trace: trace)
//            traceDetailPopup.showAndStack()
//        }
//    }
//
//    override func draw(_ rect: CGRect) {
//
//        let center = CGPoint(x: bounds.width/2, y: bounds.height/2)
//        let radius = min(rect.width, rect.height) / 2
//
//        let outerPath = UIBezierPath()
//        outerPath.addArc(withCenter: center, radius: radius, startAngle: .pi * 0.6, endAngle: .pi * 2, clockwise: true)
//        outerPath.addLine(to: center)
//        outerPath.close()
//
//        let innerPath = UIBezierPath()
//        innerPath.addArc(withCenter: center, radius: bounds.width / 2.5, startAngle: 0, endAngle: .pi * 2, clockwise: true)
//        innerPath.addLine(to: center)
//        innerPath.close()
//
//        let outerMask = CAShapeLayer()
//        outerMask.path = outerPath.cgPath
//
//        let outerRing = CALayer()
//        outerRing.bounds = bounds
//        outerRing.position = CGPoint(x: bounds.width/2, y: bounds.height/2)
//        outerRing.cornerRadius = bounds.width / 2
//        outerRing.borderWidth = 1.0
//        outerRing.borderColor = themeManager.theme.text.cgColor
//        outerRing.mask = outerMask
//
//        let innerMask = CAShapeLayer()
//        let innerRingSize = bounds.width * 0.7
//        innerMask.path = innerPath.cgPath
//
//        let innerRing = CALayer()
//
//        innerRing.bounds = CGRect(x: 0, y: 0, width: innerRingSize, height: innerRingSize)
//        innerRing.position = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
//        innerRing.cornerRadius = innerRingSize / 2
//        innerRing.borderColor = themeManager.theme.accent.cgColor
//        innerRing.borderWidth = 1.6
//        innerRing.mask = innerMask
//
//        let outerCircle = CALayer()
//        outerCircle.bounds = bounds
//        outerCircle.position = CGPoint(x: bounds.width/2, y: bounds.height/2)
//
//        outerCircle.addSublayer(innerRing)
//        outerCircle.addSublayer(outerRing)
//        layer.addSublayer(outerCircle)
//
//        backgroundColor = UIColor.clear
//    }
//}
