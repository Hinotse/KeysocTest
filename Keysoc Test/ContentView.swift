//
//  ContentView.swift
//  Keysoc Test
//
//  Created by hino on 21/8/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView{
            SearchView().tabItem{
                Image(systemName: "magnifyingglass")
                Text("search")
            }
            BookmarkView().tabItem{
                Image(systemName: "bookmark.fill")
                Text("bookmark")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.locale, .init(identifier: "en"))
    }
}
