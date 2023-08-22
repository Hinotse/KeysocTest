//
//  ItemViewModel.swift
//  Keysoc Test
//
//  Created by hino on 21/8/2023.
//

import Foundation
let baseURL = "https://itunes.apple.com/search?"

final class ItemViewModel: ObservableObject{
    @Published private(set) var resultCount = 0
    @Published private(set) var itemList:[Item] = []
    
    let endpoint = URL(string:"\(baseURL)term=jack+johnson&offset=20&limit=20")!
    func getItem(){
        print("Load iTune API...")
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
                
                self.itemList = result.results ?? [Item]()
                self.resultCount = result.resultCount
                
                print("result: \(self.itemList.count)")
            }
        }
        task.resume()
        print("iTune API Completed")
    }
}
