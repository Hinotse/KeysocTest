//
//  ItemViewModel.swift
//  Keysoc Test
//
//  Created by hino on 21/8/2023.
//

import Foundation
let baseURL = "https://itunes.apple.com/"

final class ItemViewModel: ObservableObject{
    @Published private(set) var hasNextPage = false
    @Published private(set) var itemList:[Item] = []
    @Published private(set) var isLoading = false
    @Published private(set) var resultCount = 0
    @MainActor func getItem(page:Int, searchText: String, country: String, mediaType: String){
        print("Load iTune API...")
        self.hasNextPage = false // Disable next page until next page is available
        self.isLoading = true   // Show loading screen
        var endpoint = URL(string: "\(baseURL)search?term=\(searchText.replacingOccurrences(of: " ", with: "+"))&country=\(country)&media=\(mediaType)&offset=\(20*(page-1))&limit=21")!
        var request = URLRequest(url: endpoint)
        request.httpMethod = "GET"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            if let error = error{
                print("error")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else{
                print("httpResponse Error")
                return
            }
            if let data = data,
               let result = try? JSONDecoder().decode(iTune.self, from: data){
                DispatchQueue.global(qos: .background).async {
                    self.itemList = result.results ?? [Item]()
                    self.resultCount = result.resultCount
                    if self.resultCount > 20{
                        self.itemList.removeLast()  // Hide the 21th item
                        self.hasNextPage = true
                    }
                }
            }
            DispatchQueue.global(qos: .background).async {
                self.isLoading = false
            }
        }.resume()
        
        print("iTune API Completed")
    }
}
