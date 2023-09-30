//
//  SheetController.swift
//  Traces
//
//  Created by Bryce on 9/25/23.
//

import Foundation
import SwiftUI

class SheetController: ObservableObject {
    
    static let shared = SheetController()

    @Published var newTrace: Bool = false
    @Published var showDetail: Bool = false
    @Published var detail: Trace?
    
    func presentNewTraceSheet() {
        self.newTrace = true
    }
    
    func presentDetailSheet(_ trace: Trace) {
        print("Present Detail Sheet Pressed")
        self.showDetail = true
        self.detail = trace
    }
}
