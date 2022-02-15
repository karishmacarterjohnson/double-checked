//
//  DeleteLinkButton.swift
//  double-checked
//
//  Created by Karishma Johnson on 2/3/22.
//

import SwiftUI

struct DeleteLink: View {
    @Environment(\.managedObjectContext) private var viewContext

    @StateObject var activity: Activity
    var link: LinkItem
    
    var body: some View {
            VStack {
                HStack {
                    Button(action: {
                        deleteLinkItem(linkItem: link)
                    }) {
                        Image(systemName: "xmark.circle")
//                            .padding(1)
                            .modifier(deleteLinkM())
                    }
                }
                Spacer()
            }
        }
    
    private func deleteLinkItem(linkItem: LinkItem) {
        withAnimation {
            for i in activity.linkItemsArray {
                if linkItem.link == i.link {
                    viewContext.delete(i)
                    PersistenceController.shared.saveContext()
                }
            }
        }
    }
}
