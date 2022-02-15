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
    static var overlayLineColor: Color = Theme.lgrey
    static var emptyButtonColor: Color = Theme.lgrey
    static var filledButtonColor: Color = Theme.greeny
    static var rowBackground: Color = Theme.coffee
    
    // wlw
    
    static var dOrange: Color = Color(red: 212 / 255, green: 44 / 255, blue: 0 / 255)
    static var lOrange: Color = Color(red: 253 / 255, green: 152 / 255, blue: 85 / 255)
    static var lPink: Color = Color(red: 209 / 255, green: 97 / 255, blue: 162 / 255)
    static var dPink: Color = Color(red: 162 / 255, green: 1 / 255, blue: 97 / 255)
    
    // cool earth
    
    // a
    static var greeny: Color = Color(red: 139 / 255, green: 146 / 255, blue:  128 / 255)
    static var peachy: Color = Color(red: 232 / 255, green: 190 / 255, blue:  166 / 255)
    static var coffee: Color = Color(red: 228 / 255, green: 171 / 255, blue:  142 / 255)
    
    // b
    static var mclay: Color = Color(red: 197 / 255, green: 118 / 255, blue: 78 / 255)
    static var dclay: Color = Color(red: 181 / 255, green: 95 / 255, blue: 56 / 255) //b2
    static var lclay: Color = Color(red: 199 / 255, green: 162 / 255, blue: 135 / 255)
    // c
    static var greybrown: Color = Color(red: 205 / 255, green: 177 / 255, blue: 1533 / 255)
    static var wgrey: Color = Color(red: 235 / 255, green: 234 / 255, blue: 240 / 255)
    static var lgrey: Color = Color(red: 225 / 255, green: 215 / 255, blue: 206 / 255)
    
}


// PROGRESS BAR
struct Progress0M: ViewModifier {
    func body(content: Content) -> some View {
        content
            .opacity(  1.0)
            .foregroundColor(Theme.lgrey)
    }
}

struct  Progress1M: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Theme.greeny)
    }
}

// TEXT FIELDS
struct TextFieldM: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(Theme.textfieldPadding)
            .foregroundColor(Theme.greeny) // mclay?
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
            //.padding(Theme.textfieldPadding)
    }
}

struct InputStackM: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Theme.lgrey)
            .cornerRadius(Theme.textfieldCorner)
            .overlay(RoundedRectangle(cornerRadius: Theme.textfieldCorner)
                    .strokeBorder(Theme.overlayLineColor, lineWidth: Theme.overlayLineWidth))
    }
}

// CONTENT VIEW

struct SectionHeaderM: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Theme.peachy)
            .font(.body)
            .textCase(.uppercase)
    }
}

struct ActivityTitleM: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Theme.dclay)
            .font(.body)
        
    }
}

struct ActivityDateM: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Theme.lOrange)
        
    }
}

struct ListRowM: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Theme.dclay)
            .listRowBackground(Theme.coffee)
        
    }
}

struct navBarM: ViewModifier {
    func body(content: Content) -> some View {
        content
            .navigationBarTitle("Activities", displayMode: .inline)
            .background(Theme.coffee)
            .foregroundColor(Theme.lgrey)
            
        
    }
}


// List Rows
struct listRowsM: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Theme.dclay)
    }
}


// activity links

struct deleteLinkM: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Theme.greeny)
    }
}

struct linkChainM: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Theme.lclay)
    }
}


struct linkInfoM: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Theme.dclay)
    }
}

struct plusButtonM: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Theme.greeny)
    }
}
