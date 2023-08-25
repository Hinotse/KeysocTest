//
//  SearchItemViewModel.swift
//  Keysoc Test
//
//  Created by hino on 25/8/2023.
//

import Foundation

final class LookupItemViewModel: ObservableObject{
    @Published private(set) var item:Item = Item()
    @Published private(set) var resultCount = 0
    @MainActor func lookupItem(id: String){
        print("Load iTune API...")
        var endpoint = URL(string: "\(baseURL)lookup?id=\(id)")!
        print(endpoint)
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
                DispatchQueue.global(qos: .default).async {
                    self.item = result.results?[0] ?? Item()
                }
            }
        }.resume()
        
        print("iTune API Completed")
    }
}
