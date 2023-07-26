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
    private var imageView: UIImageView?
    
    init(frame: CGRect, trace: Trace? = nil) {
        super.init(frame: frame)
        self.trace = trace
        
        setupImageView(frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupImageView(_ frame: CGRect) {
        let traceImage = UIImage(named: "trace")
        
        guard let image = traceImage else {
            print("Error: Image 'trace' not found.")
            return
        }
        
        imageView = UIImageView(image: image)
        imageView?.contentMode = .scaleAspectFit
        
        if let imageView = imageView {
            addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        }
    }
}
