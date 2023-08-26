//
//  Keysoc_TestApp.swift
//  Keysoc Test
//
//  Created by hino on 21/8/2023.
//

import SwiftUI

@main
struct Keysoc_TestApp: App {
    @AppStorage("lang") var lang: String = "en"
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.locale, .init(identifier: lang))
        }
    }
}
