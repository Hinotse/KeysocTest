//
//  itemModel.swift
//  Keysoc Test
//
//  Created by hino on 21/8/2023.
//

import Foundation

struct iTune: Decodable{
    var resultCount: Int
    var results: [Item]?
}

struct Item: Decodable, Identifiable{
    let id = UUID()
    var kind: String?
    var artistName: String?
    var collectionName: String?
    var trackName: String?
}
