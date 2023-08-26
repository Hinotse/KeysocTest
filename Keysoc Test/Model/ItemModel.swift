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

struct Item: Identifiable, Codable{
    let id = UUID()
    var kind: String?
    var artistName: String?
    var trackName: String?
    var trackId: Int?
    var artworkUrl100: String?
    var longDescription: String?
    var country: String?
}
