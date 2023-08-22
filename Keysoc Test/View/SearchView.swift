//
//  SearchView.swift
//  Keysoc Test
//
//  Created by hino on 21/8/2023.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var vm = ItemViewModel()
    @State private var searchText = ""
    var body: some View {
//        NavigationView{
        VStack{
            // Search Bar
            VStack{
                TextField("Search ...", text: $searchText)
                    .padding(7)
                    .padding(.horizontal, 25)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal, 20)
            }
            
            // Build iTune items UI
            List(vm.itemList){ item in
                Text(item.collectionName ?? "None")
            }
            .onAppear(perform: vm.getItem)
            .refreshable {
                vm.getItem()
            }
        }
       
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
