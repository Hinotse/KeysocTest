//
//  MeView.swift
//  Keysoc Test
//
//  Created by hino on 21/8/2023.
//

import SwiftUI

struct BookmarkView: View {
    @AppStorage("lang") var lang: String = "en"
    @State private var itemList: [Item] = []
    let userDefaults = UserDefaults.standard
    private var unknownImage = "https://www.google.com/url?sa=i&url=https%3A%2F%2Fthenounproject.com%2Fbrowse%2Ficons%2Fterm%2Funknown%2F&psig=AOvVaw3qChMvIhdUAgacZ68t654c&ust=1692776552115000&source=images&cd=vfe&opi=89978449&ved=0CBAQjRxqFwoTCNClj5ri74ADFQAAAAAdAAAAABAE"
    var body: some View {
        NavigationView(){
            VStack(){
                Text("language")
                    .font(.title)
                    .padding()
                HStack(spacing: 30){
                    // en Button
                    Button {
                        lang = "en"
                    } label: {
                        VStack{
                            Text("lang_eng")
                            Image(systemName: lang == "en" ? "largecircle.fill.circle" : "circle")
                                .renderingMode(.original)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 20, height: 20)
                        }
                    }
                    .frame(width: 100)
                    
                    // zh-HK Button
                    Button {
                        lang = "zh-HK"
                    } label: {
                        VStack{
                            Text("lang_tc")
                            Image(systemName: lang == "zh-HK" ? "largecircle.fill.circle" : "circle")
                                .renderingMode(.original)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 20, height: 20)
                        }
                        
                    }
                    .frame(width: 100)
                    
                    // zh-HK Button
                    Button {
                        lang = "zh-Hans"
                    } label: {
                        VStack{
                            Text("lang_sc")
                            Image(systemName: lang == "zh-Hans" ? "largecircle.fill.circle" : "circle")
                                .renderingMode(.original)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 20, height: 20)
                        }
                    }
                    .frame(width: 100)
                }
                Text("bookmark_list")
                    .font(.title)
                    .padding()
                // Bookmark List
                ScrollView(.vertical){
                    LazyVStack(){
                        ForEach(itemList) { item in
                            
                            Section{
                                NavigationLink(destination: ItemView(itemId: String(item.trackId ?? 0), country: item.country ?? "US")){
                                    HStack{
                                        // Song Image
                                        AsyncImage(url: URL(string:item.artworkUrl100 ?? unknownImage), content:{ image in
                                            image
                                                .scaledToFit()
                                        },placeholder: {
                                            ProgressView()
                                        })
                                        .frame(width: 130)
                                        .padding()
                                        
                                        VStack(alignment: .leading, spacing: 6){
                                            // Song Name
                                            Text(item.trackName ?? "none")
                                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                                                .padding(5)
                                                .lineLimit(2)
                                                .bold()
                                                .foregroundColor(.black)
                                            // Artist Name
                                            Text(item.artistName ?? "none")
                                                .font(.system(size:15))
                                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                                                .padding(5)
                                                .italic()
                                                .lineLimit(2)
                                                .foregroundColor(.gray)
                                        }
                                        .frame(width: 200)
                                    }
                                }
                            }
                            .background(Color.white)
                            .cornerRadius(5)
                            .padding()
                            
                        }
                    }
                }
                .onAppear(perform: getBookmark)
                .refreshable{
                    getBookmark()
                }
                Spacer()
            }
            .padding()
        }
    }
}

struct BookmarkView_Previews: PreviewProvider {
    static var previews: some View {
        BookmarkView()
    }
}

extension BookmarkView{
    func getBookmark(){
        if let savedData = userDefaults.object(forKey: "bookmarkList") as? Data{
            do{
                self.itemList = try JSONDecoder().decode([Item].self, from: savedData)
            }
            catch{
                print("Fail to read savedData")
            }
        }
    }
}
