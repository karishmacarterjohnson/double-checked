//
//  ProgressBar.swift
//  double-checked
//
//  Created by Karishma Johnson on 1/27/22.
//

import SwiftUI

struct ProgressBar: View {
    // https://www.simpleswiftguide.com/how-to-build-linear-progress-bar-in-swiftui/
    var value: Float
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle().frame(width: geometry.size.width , height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(Color(UIColor.systemPink))
                withAnimation {
                Rectangle().frame(width: min(CGFloat(self.value)*geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(Color(UIColor.systemOrange))
                }
            }.cornerRadius(45.0)
        }
    }
}
