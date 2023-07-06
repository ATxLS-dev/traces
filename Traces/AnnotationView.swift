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
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    private func setupView() {
        backgroundColor = UIColor.clear
        layer.cornerRadius = bounds.width / 2
        layer.borderColor = themeManager.theme.text.cgColor
        layer.borderWidth = 2.0
    }
}
