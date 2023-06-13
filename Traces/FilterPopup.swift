//
//  FilterPopup.swift
//  Traces
//
//  Created by Bryce on 6/12/23.
//

import SwiftUI

struct FilterPopup: View {
    let action : (String?) -> Void
    
    var body: some View {
        
        
        VStack(alignment: .leading, spacing: 4){
            
            ForEach(0...3, id: \.self){ valueStore in
                
                Button(action: {
                    
                    
                    
                }) {
                    
                    HStack(alignment: .center, spacing: 8) {
                        
                        Image(systemName: "bell")
                            .resizable()
                            .frame(width: 30, height: 30, alignment: .center)
                            .clipShape(Circle())
                        
                        VStack (alignment: .leading){
                            Text("ANDROID" )
                                .font(.body)
                                .foregroundColor(.black)
                                .padding([.leading, .top], 4)
                            
                            Text("#jetpack")
                                .font(.body)
                                .foregroundColor(warmGray)
                                .padding([.leading, .bottom], 2)
                            
                        }
                        
                        
                    }.foregroundColor(.black)
                    
                }.frame(width: .none, height: .none, alignment: .center)
                
                
                Divider().background(.gray)
                
            }
            
        }.padding(.all, 12)
            .background(RoundedRectangle(cornerRadius: 6).foregroundColor(.white).shadow(radius: 2))
        
    }
}

struct FilterPopup_Previews: PreviewProvider {
    static var previews: some View {
        FilterPopup(action: {data in}).padding()
    }
}

//@State var showStoreDropDown: Bool = false
////ui
//HStack(alignment: .center, spacing: 16) {
//
//    //here you UI goes
//
//}.overlay (
//
//    VStack {
//
//        if showTimeframeDropDown {
//
//            Spacer(minLength: 40)
//
//            SampleDropDown(action: { data in
//
//            })
//
//        }
//
//    }, alignment: .topLeading
//
//).onTapGesture {
//
//    showTimeframeDropDown.toggle()
//
//}
//
