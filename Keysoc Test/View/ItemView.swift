//
//  ItemView.swift
//  Keysoc Test
//
//  Created by hino on 23/8/2023.
//

import SwiftUI

struct ItemView: View {
    @StateObject private var vm = LookupItemViewModel()
    private var itemId: String = ""
    private var unknownImage = "https://www.google.com/url?sa=i&url=https%3A%2F%2Fthenounproject.com%2Fbrowse%2Ficons%2Fterm%2Funknown%2F&psig=AOvVaw3qChMvIhdUAgacZ68t654c&ust=1692776552115000&source=images&cd=vfe&opi=89978449&ved=0CBAQjRxqFwoTCNClj5ri74ADFQAAAAAdAAAAABAE"
    
    init(itemId: String){
        self.itemId = itemId
    }
    
    var body: some View {
//        Text("Lookup ID: \(itemId)")
        ScrollView(.vertical){
            // Track Image
            AsyncImage(url: URL(string:vm.item.artworkUrl100 ?? unknownImage), content:{ image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 300)
                    .cornerRadius(5)
            },placeholder: {
                ProgressView()
            })
            
            VStack(alignment: .leading, spacing: 1){
                // Track Info
                Grid(alignment: .leading, horizontalSpacing: 10, verticalSpacing: 10){
                    GridRow{
                        Text("Track Name:")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .bold()
                            .foregroundColor(.black)
                            .font(.system(size:18))
                        Text("\(vm.item.trackName ?? "None")")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .bold()
                            .foregroundColor(.black)
                            .font(.system(size:18))
                    }
                    GridRow{
                        Text("Kind:")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .bold()
                            .foregroundColor(.black)
                            .font(.system(size:18))
                        Text("\(vm.item.kind ?? "None")")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .bold()
                            .foregroundColor(.black)
                            .font(.system(size:18))
                    }
                    GridRow{
                        Text("Artist Name: ")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .bold()
                            .foregroundColor(.black)
                            .font(.system(size:18))
                        
                        Text("\(vm.item.artistName ?? "None")")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .bold()
                            .foregroundColor(.black)
                            .font(.system(size:18))
                    }
                }.padding()
                
                Text("Description:")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .bold()
                    .foregroundColor(.black)
                    .font(.system(size:18))
                Text(vm.item.longDescription ?? "None")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .bold()
                    .foregroundColor(.black)
                    .font(.system(size:18))
                
                // Button for bookmark
                HStack{
                    Spacer()
                    Button(action: {
                        // Bookmark the track item
                    }){
                        Text("Bookmark")
                            .fontWeight(.bold)
                            .font(.title)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    Spacer()
                }
                .padding()
                
                Spacer()
            }
            .frame(width: .infinity)
        }
        .onAppear(perform: lookupItem)
        .refreshable{
            lookupItem()
        }
        .padding()
    }
}

extension ItemView{
    func lookupItem(){
        vm.lookupItem(id: itemId)
    }
}
