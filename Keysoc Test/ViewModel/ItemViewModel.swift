//
//  ItemViewModel.swift
//  Keysoc Test
//
//  Created by hino on 21/8/2023.
//

import Foundation
let baseURL = "https://itunes.apple.com/search?"

final class ItemViewModel: ObservableObject{
    @Published private(set) var hasNextPage = false
    @Published private(set) var itemList:[Item] = []
    @Published private(set) var isLoading = false
    @Published private(set) var resultCount = 0
    @MainActor func getItem(page:Int, searchText: String){
        print("Load iTune API...")
        self.hasNextPage = false // Disable next page until next page is available
        self.isLoading = true   // Show loading screen
        let sem = DispatchSemaphore.init(value: 0)
        var endpoint = URL(string: "\(baseURL)term=\(searchText.replacingOccurrences(of: " ", with: "+"))&offset=\(20*(page-1))&limit=20")!
        var request = URLRequest(url: endpoint)
        request.httpMethod = "GET"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            defer {sem.signal()}
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
                DispatchQueue.main.async {
                    self.itemList = result.results ?? [Item]()
                    self.resultCount = result.resultCount
                }
            }
        }
        task.resume()
//        sem.wait()
        
        
        // Find resultcount on next page
        endpoint = URL(string: "\(baseURL)term=\(searchText.replacingOccurrences(of: " ", with: "+"))&offset=\(20*(page-1))&limit=20")!
        request = URLRequest(url: endpoint)
        request.httpMethod = "GET"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        let task2 = URLSession.shared.dataTask(with: request) {data, response, error in
            if let error = error{
                print("error")
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else{
                print("httpResponse Error (No next page)")
                
                return
            }
            if let data = data,
               let result = try? JSONDecoder().decode(iTune.self, from: data){
                if result.resultCount > 0{
                    DispatchQueue.main.async {
                        self.hasNextPage = true
                    }
                    
                }
            }
        }
        task2.resume()
        sem.wait()
        self.isLoading = false
        print("iTune API Completed")
    }
}
