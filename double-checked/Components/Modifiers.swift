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
    static var emptyButtonColor: Color = Theme.lPink
    static var filledButtonColor: Color = .red
    static var dOrange: Color = Color(red: 212 / 255, green: 44 / 255, blue: 0 / 255)
    static var lOrange: Color = Color(red: 253 / 255, green: 152 / 255, blue: 85 / 255)
    static var lPink: Color = Color(red: 209 / 255, green: 97 / 255, blue: 162 / 255)
    static var dPink: Color = Color(red: 162 / 255, green: 1 / 255, blue: 97 / 255)
    
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

struct SectionHeaderM: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Theme.lOrange)
            .font(.body)
            .textCase(.uppercase)
    }
}

struct ActivityTitleM: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Theme.dPink)
            .font(.body)
        
    }
}

struct ActivityDateM: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Theme.lOrange)
        
    }
}
