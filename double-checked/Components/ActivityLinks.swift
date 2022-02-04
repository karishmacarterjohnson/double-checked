//
//  ActivityLinks.swift
//  double-checked
//
//  Created by Karishma Johnson on 2/2/22.
//

import Foundation
import SwiftUI

struct ActivityLinks: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @StateObject var activity: Activity
    @State var itemLink: String = ""
    @State var showTextField: Bool = false
    
    var body: some View {
        ScrollView(.horizontal) {
            
            HStack {
                if showTextField {
                    TextField("add link", text: $itemLink)
                        .textFieldStyle(.roundedBorder)
                    Button(action: addLinkItem) {
                        Label("", systemImage:"plus")
                    }
                } else {
                    Button(action: {showTextField.toggle()}) {
                    Image(systemName: "plus")
                        .font(.largeTitle)
                    }
                }
                ForEach(activity.linkItemsArray) { linkitem in
                    
                    Link(destination: URL(string: linkitem.unwrappedLink)!) {
                        HStack {
                            VStack {
                                Text(linkitem.unwrappedTitle)
                                Text(linkitem.unwrappedLink)
                            }
                            Image(systemName: "link.circle.fill")
                                .font(.largeTitle)
                        }
                        DeleteLink(activity: activity, link: linkitem)
                    }// .background(Color(red: 214 / 255, green: 41 / 255, blue: 0 / 255))
                }.padding()
            }
        }.frame(height: 100).padding(.horizontal)
    }
    
    
    
    private func addLinkItem() {
        withAnimation {
            if let url = URL(string: itemLink ) {
                let newLinkItem = LinkItem(context: viewContext)
                newLinkItem.link = itemLink
                
                do {
                    let contents = try String(contentsOf: url)
                    let range = NSRange(location: 0, length: contents.utf16.count)

                    let regex = try! NSRegularExpression(pattern: "<title>.*?</title>")
                    let match = regex.matches(in: contents, range: range)
                    let matchArray = match.map {
                        String(contents[Range($0.range, in: contents)!])
                    }
                    newLinkItem.title = String(matchArray[0].dropFirst(7).dropLast(8))
                    
                } catch {
                    newLinkItem.title = itemLink
                }
                
                activity.addToLinkitems(newLinkItem)
                
                PersistenceController.shared.saveContext()
                itemLink = ""
                showTextField.toggle()
            } else {
                // alert bad link
                print("bad url!")
            }
        }
    }
    
    
    
}



