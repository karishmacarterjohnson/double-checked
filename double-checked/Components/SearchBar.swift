//
//  SearchBar.swift
//  double-checked
//
//  Created by Karishma Johnson on 2/3/22.
//

import SwiftUI

struct SearchBar: View {
    @State private var searchText: String = ""
    @State var activities: FetchedResults<Activity>
    
    var body: some View {
        
        NavigationView {
            List {
                ForEach(searchResults(), id: \.self.0) { index, activity, match in
                    NavigationLink(destination: ReadActivityView(activity: activity, activityArray: activities)) {
                        VStack {
                            Text(activity.unwrappedTitle)
                            Text(match).font(.caption)
                        }
                    }
                    
                }
            }
            
            
        }
        .searchable(text: $searchText)
    }
    
    private func searchResults() -> [(Int, Activity, String)] {
        var matches = [(Int, Activity, String)]()
        var index: Int = 0
        for activity in activities {
            if activity.unwrappedTitle.localizedCaseInsensitiveContains(searchText) {
                matches.append((index, activity, activity.unwrappedTitle))
                index += 1
            }
            for i in activity.itemsArray {
                if i.unwrappedTitle.localizedCaseInsensitiveContains(searchText) {
                    matches.append((index, activity, i.unwrappedTitle))
                    index += 1
                }
            }
            for l in activity.linkItemsArray {
                if l.unwrappedTitle.localizedCaseInsensitiveContains(searchText) {
                    matches.append((index, activity, l.unwrappedTitle))
                    index += 1
                }
            }
        }
        
        return matches
    }
}
