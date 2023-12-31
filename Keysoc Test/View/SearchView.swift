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
    @State private var country = "US"
    private let countryList = ["AD", "AE", "AF", "AG", "AI", "AL", "AM", "AO", "AQ", "AR", "AS", "AT", "AU", "AW", "AX", "AZ", "BA", "BB", "BD", "BE", "BF", "BG", "BH", "BI", "BJ", "BL", "BM", "BN", "BO", "BQ", "BR", "BS", "BT", "BV", "BW", "BY", "BZ", "CA", "CC", "CD", "CF", "CG", "CH", "CI", "CK", "CL", "CM", "CN", "CO", "CR", "CU", "CV", "CW", "CX", "CY", "CZ", "DE", "DJ", "DK", "DM", "DO", "DZ", "EC", "EE", "EG", "EH", "ER", "ES", "ET", "FI", "FJ", "FK", "FM", "FO", "FR", "GA", "GB", "GD", "GE", "GF", "GG", "GH", "GI", "GL", "GM", "GN", "GP", "GQ", "GR", "GS", "GT", "GU", "GW", "GY", "HK", "HM", "HN", "HR", "HT", "HU", "ID", "IE", "IL", "IM", "IN", "IO", "IQ", "IR", "IS", "IT", "JE", "JM", "JO", "JP", "KE", "KG", "KH", "KI", "KM", "KN", "KP", "KR", "KW", "KY", "KZ", "LA", "LB", "LC", "LI", "LK", "LR", "LS", "LT", "LU", "LV", "LY", "MA", "MC", "MD", "ME", "MF", "MG", "MH", "MK", "ML", "MM", "MN", "MO", "MP", "MQ", "MR", "MS", "MT", "MU", "MV", "MW", "MX", "MY", "MZ", "NA", "NC", "NE", "NF", "NG", "NI", "NL", "NO", "NP", "NR", "NU", "NZ", "OM", "PA", "PE", "PF", "PG", "PH", "PK", "PL", "PM", "PN", "PR", "PS", "PT", "PW", "PY", "QA", "RE", "RO", "RS", "RU", "RW", "SA", "SB", "SC", "SD", "SE", "SG", "SH", "SI", "SJ", "SK", "SL", "SM", "SN", "SO", "SR", "SS", "ST", "SV", "SX", "SY", "SZ", "TC", "TD", "TF", "TG", "TH", "TJ", "TK", "TL", "TM", "TN", "TO", "TR", "TT", "TV", "TW", "TZ", "UA", "UG", "UM", "US", "UY", "UZ", "VA", "VC", "VE", "VG", "VI", "VN", "VU", "WF", "WS", "YE", "YT", "ZA", "ZM", "ZW"]
    @State private var mediaType = "all"
    private let mediaTypeList = ["all", "movie", "podcast", "music", "musicVideo", "audiobook", "shortFilm", "tvShow", "software", "ebook"]
    private var unknownImage = "https://www.google.com/url?sa=i&url=https%3A%2F%2Fthenounproject.com%2Fbrowse%2Ficons%2Fterm%2Funknown%2F&psig=AOvVaw3qChMvIhdUAgacZ68t654c&ust=1692776552115000&source=images&cd=vfe&opi=89978449&ved=0CBAQjRxqFwoTCNClj5ri74ADFQAAAAAdAAAAABAE"
    var body: some View {
        NavigationView{
            VStack(){
                // Search Bar
                VStack{
                    TextField("searchPlaceholder", text: $searchText)
                        .padding(7)
                        .padding(.horizontal, 25)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal, 20)
                        .autocorrectionDisabled(true)
                        .autocapitalization(.none)
                        .onChange(of: searchText) { value in
                            currentPage = 1
                            searchItem()
                        }
                }
                Grid{
                    GridRow{
                        Text("country")
                        // Country Picker
                        Picker("Country", selection: $country){
                            ForEach(countryList, id: \.self){
                                Text($0)
                            }
                        }
                        .onChange(of: country){ _ in
//                            print(country)
                            getItem()
                        }
                        Text("mediaType")
                        // Media Type Picker
                        Picker("Media", selection: $mediaType){
                            ForEach(mediaTypeList, id: \.self){
                                Text($0)
                            }
                        }
                        .onChange(of: mediaType){ _ in
//                            print(mediaType)
                            getItem()
                        }
                        .gridCellColumns(2)
                    }
                }
                // Pagination
                HStack(alignment: .center){
                    Button(action: {
                        if currentPage > 1{
                            currentPage -= 1
                        }
                    }){
                        Text("previousPage")
                            .padding(10)
                            .background(Color.blue)
                            .foregroundColor(Color.white)
                            .cornerRadius(10)
                            .frame(width: 150)
                    }
                    VStack{
                        Text("page")
                            .frame(width: 50)
                        Text("\(currentPage)")
                            .font(.system(size:24))
                            .onChange(of: currentPage) { value in
                                getItem()
                            }
                    }
                    
                    Button(action: {
                        if vm.hasNextPage{
                            currentPage += 1
                        }
                    }){
                        Text("nextPage")
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
                    Text("searchMsg")
                        .foregroundColor(.gray)
                }else if vm.resultCount == 0{
                    Text("noResult")
                        .foregroundColor(.gray)
                }else{
                    // Build iTune items UI
                    ScrollView(.vertical){
                        LazyVStack(){
                            ForEach(vm.itemList) { item in
                                
                                Section{
                                    NavigationLink(destination: ItemView(itemId: String(item.trackId ?? 0), country: country)){
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
    
}


extension SearchView{
    func searchItem(){
        let currentSearch = searchText
        DispatchQueue.main.asyncAfter(deadline: .now()+1){
            if currentSearch == searchText{
                vm.getItem(page: currentPage, searchText: searchText, country: country, mediaType: mediaType)
            }
        }
    }
    
    func getItem(){
        vm.getItem(page: currentPage, searchText: searchText, country: country, mediaType: mediaType)
    }
}
