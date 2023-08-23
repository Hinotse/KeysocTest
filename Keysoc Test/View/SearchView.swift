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
    @State private var currentPage = 1
    private var unknownImage = "https://www.google.com/url?sa=i&url=https%3A%2F%2Fthenounproject.com%2Fbrowse%2Ficons%2Fterm%2Funknown%2F&psig=AOvVaw3qChMvIhdUAgacZ68t654c&ust=1692776552115000&source=images&cd=vfe&opi=89978449&ved=0CBAQjRxqFwoTCNClj5ri74ADFQAAAAAdAAAAABAE"
    var body: some View {
        //        NavigationView{
        VStack(){
            // Search Bar
            VStack{
                TextField("Search ...", text: $searchText)
                    .padding(7)
                    .padding(.horizontal, 25)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal, 20)
                    .autocorrectionDisabled(true)
                    .autocapitalization(.none)
                    .onChange(of: searchText) { value in
                        currentPage = 1
                        getItem()
                    }
            }
            // Pagination
            HStack(alignment: .center){
                Button(action: {
                    if currentPage > 1{
                        currentPage -= 1
                    }
                }){
                    Text("Previous")
                        .padding(10)
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .cornerRadius(10)
                        .frame(width: 150)
                }
                VStack{
                    Text("Page")
                        .frame(width: 50)
                    Text("\(currentPage)")
                        .font(.system(size:24))
                        .onChange(of: currentPage) { value in
                            print("Chaging page: \(value)")
                            getItem()
                        }
                }
                
                Button(action: {
                    if vm.hasNextPage{
                        currentPage += 1
                    }
                }){
                    Text("Next")
                        .padding(10)
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .cornerRadius(10)
                        .frame(width: 150)
                }
            }
            .padding()
            
            if vm.isLoading{
                ProgressView()
            }else if searchText.trimmingCharacters(in: .whitespaces) == "" {
                Text("Please type the song, albums, or artists in search bar")
                    .foregroundColor(.gray)
            }else if vm.resultCount == 0{
                Text("No Result")
                    .foregroundColor(.gray)
            }else{
                // Build iTune items UI
                ScrollView(.vertical){
                    LazyVStack(){
                        ForEach(vm.itemList) { item in
                            Section{
                                HStack{
                                    // Song Image
                                    AsyncImage(url: URL(string:item.artworkUrl100 ?? unknownImage), content:{ image in
                                        image
                                            .scaledToFit()
                                    },placeholder: {
                                        ProgressView()
                                    })
                                    .frame(width: 100)
                                    
                                    VStack(alignment: .leading, spacing: 6){
                                        // Song Name
                                        Text(item.trackName ?? "None")
                                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                                            .padding(5)
                                            .lineLimit(2)
                                            .bold()
                                        // Artist Name
                                        Text(item.artistName ?? "None")
                                            .font(.system(size:12))
                                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                                            .padding(5)
                                            .italic()
                                            .lineLimit(2)
                                    }
                                    .frame(width: 200)
                                }
                            }
                            .padding()
                            
                        }
                    }
                }
//                .onAppear(perform: getItem)
                .refreshable{
                    getItem()
                }
            }
            
            Spacer()
        }
        .padding()
        
    }
    
}


extension SearchView{
    func getItem(){
        vm.getItem(page: currentPage, searchText: searchText)
    }
}
