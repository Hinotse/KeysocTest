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
    
    func getItem(page:Int){
        print("Load iTune API...")
        var endpoint = URL(string: "\(baseURL)term=jack+johnson&offset=\(20*(page-1))&limit=20")!
        var request = URLRequest(url: endpoint)
        request.httpMethod = "GET"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        var task = URLSession.shared.dataTask(with: request) {data, response, error in
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
                
                self.itemList = result.results ?? [Item]()
//                self.resultCount = result.resultCount
            }
        }
        task.resume()
        
        // Find resultcount on next page
        endpoint = URL(string: "\(baseURL)term=jack+johnson&offset=\(20*(page))&limit=20")!
        request = URLRequest(url: endpoint)
        request.httpMethod = "GET"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        task = URLSession.shared.dataTask(with: request) {data, response, error in
            if let error = error{
                print("error")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else{
                print("httpResponse Error")
                self.hasNextPage = false
                return
            }
            if let data = data,
               let result = try? JSONDecoder().decode(iTune.self, from: data){
                
//                self.itemList = result.results ?? [Item]()
//                self.resultCount = result.resultCount
                if result.resultCount > 0{
                    self.hasNextPage = true
                }
                else{
                    self.hasNextPage = false
                }
            }
        }
        task.resume()
        print("offset:\(20*(page-1)), hasNextPage:\(hasNextPage)")
        print("iTune API Completed")
    }
}
