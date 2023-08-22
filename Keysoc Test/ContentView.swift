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
                Text("Search")
            }
            HomeView().tabItem{
                Image(systemName: "house.fill")
                Text("Home")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
