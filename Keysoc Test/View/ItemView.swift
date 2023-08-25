//
//  ItemView.swift
//  Keysoc Test
//
//  Created by hino on 23/8/2023.
//

import SwiftUI

struct ItemView: View {
    private var itemId: String = ""
    init(itemId: String){
        self.itemId = itemId
    }
    
    var body: some View {
        Text("Lookup ID: \(itemId)")
    }
}
