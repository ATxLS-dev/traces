//
//  CapsuleToggle.swift
//  Traces
//
//  Created by Bryce on 6/6/23.
//

import SwiftUI

struct CapsuleToggle: View {
    @State private var isOn = false;
    var body: some View {

            HStack {
                Text("Map")
                Text("List")
            }
            .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
            .background(Capsule()
                .fill(.thinMaterial))

        .background(Capsule()
            .fill(.thinMaterial))

//        ZStack {
//            Capsule(style: .continuous)
//                .fill(.thinMaterial)
//            Capsule(style: .circular)
//                .fill(.thinMaterial)
//            Toggle(isOn: $isOn) {}
//        }
    }
}

struct CapsuleToggle_Previews: PreviewProvider {
    static var previews: some View {
        CapsuleToggle()
    }
}
