//
//  ItemView.swift
//  Keysoc Test
//
//  Created by hino on 23/8/2023.
//

import SwiftUI

struct ItemView: View {
    @StateObject private var vm = LookupItemViewModel()
    let userDefaults = UserDefaults.standard
    @State var bookmarkList: [Item] = []
    private var itemId: String = ""
    private var country: String = ""
    private var unknownImage = "https://www.google.com/url?sa=i&url=https%3A%2F%2Fthenounproject.com%2Fbrowse%2Ficons%2Fterm%2Funknown%2F&psig=AOvVaw3qChMvIhdUAgacZ68t654c&ust=1692776552115000&source=images&cd=vfe&opi=89978449&ved=0CBAQjRxqFwoTCNClj5ri74ADFQAAAAAdAAAAABAE"
    
    init(itemId: String, country: String){
        self.itemId = itemId
        self.country = country
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
            .padding()
            
            VStack(alignment: .leading, spacing: 1){
                // Track Info
                Grid(alignment: .leading, horizontalSpacing: 10, verticalSpacing: 10){
                    GridRow{
                        Text("trackName")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .bold()
                            .foregroundColor(.black)
                            .font(.system(size:18))
                        Text("\(vm.item.trackName ?? "none")")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .bold()
                            .foregroundColor(.black)
                            .font(.system(size:18))
                    }
                    GridRow{
                        Text("kind")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .bold()
                            .foregroundColor(.black)
                            .font(.system(size:18))
                        Text("\(vm.item.kind ?? "none")")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .bold()
                            .foregroundColor(.black)
                            .font(.system(size:18))
                    }
                    GridRow{
                        Text("artistName")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .bold()
                            .foregroundColor(.black)
                            .font(.system(size:18))
                        
                        Text("\(vm.item.artistName ?? "none")")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .bold()
                            .foregroundColor(.black)
                            .font(.system(size:18))
                    }
                }.padding()
                
                Text("description")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .bold()
                    .foregroundColor(.black)
                    .font(.system(size:18))
                Text(vm.item.longDescription ?? "none")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .bold()
                    .foregroundColor(.black)
                    .font(.system(size:18))
                
                // Button for bookmark
                HStack{
                    Spacer()
                    if bookmarkList.contains{$0.trackId == vm.item.trackId}{
                        // Already bookmarked
                        Button(action: {
                            // Bookmark the track item
                            if let index = bookmarkList.firstIndex{$0.trackId == vm.item.trackId}{
                                bookmarkList.remove(at: index)
                            }
                            
                            do{
                                let encodedData = try JSONEncoder().encode(bookmarkList)
                                userDefaults.set(encodedData, forKey: "bookmarkList")
                            }
                            catch{
                                print("Can't encode bookmark list")
                            }
                            print("Remove bookmark")
                        }){
                            Text("removeFavorites")
                                .fontWeight(.bold)
                                .font(.title)
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    else{
                        // No bookmarked
                        Button(action: {
                            // Bookmark the track item
                            
                            
                            bookmarkList.append(vm.item)
                            do{
                                let encodedData = try JSONEncoder().encode(bookmarkList)
                                userDefaults.set(encodedData, forKey: "bookmarkList")
                            }
                            catch{
                                print("Can't encode bookmark list")
                            }
                            print("Add bookmark")
                        }){
                            Text("addFavorites")
                                .fontWeight(.bold)
                                .font(.title)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    Spacer()
                }
                .padding()
                
                Spacer()
            }
            .padding()
        }
        .onAppear(perform: lookupItem)
        .refreshable{
            lookupItem()
        }
        .background(Color.white)
        .cornerRadius(5)
        .padding()
    }
}

extension ItemView{
    func lookupItem(){
        print("itemID: \(itemId), country: \(country)")
        // Lookup Item
        vm.lookupItem(id: itemId, country: String(country.prefix(2)))
        
        // Load bookmark list
        if let savedData = userDefaults.object(forKey: "bookmarkList") as? Data{
            do{
                bookmarkList = try JSONDecoder().decode([Item].self, from: savedData)
            }
            catch{
                print("Fail to read savedData")
            }
        }
    }
}
