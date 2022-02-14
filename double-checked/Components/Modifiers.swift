//
//  Modifiers.swift
//  double-checked
//
//  Created by Karishma Johnson on 2/14/22.
//

import SwiftUI

struct Theme {
    static var textfieldPadding: CGFloat = 6
    static var textfieldCorner: CGFloat = 10
    static var overlayLineWidth: CGFloat = 2
    static var overlayLineColor: Color = .white
    static var emptyButtonColor: Color = .gray
    static var filledButtonColor: Color = .red
    
}

struct TextFieldM: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(Theme.textfieldPadding)
    }
}

struct ClearButtonM: ViewModifier {
    func body(content: Content) -> some View {
        content
            .buttonStyle(PlainButtonStyle())
            .padding(Theme.textfieldPadding)
    }
}

struct AddButtonM: ViewModifier {
    func body(content: Content) -> some View {
        content
            .buttonStyle(PlainButtonStyle())
            .padding(Theme.textfieldPadding)
    }
}

struct InputStackM: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(.white)
            .cornerRadius(Theme.textfieldCorner)
            .overlay(RoundedRectangle(cornerRadius: Theme.textfieldCorner)
                    .strokeBorder(Theme.overlayLineColor, lineWidth: Theme.overlayLineWidth))
    }
}
