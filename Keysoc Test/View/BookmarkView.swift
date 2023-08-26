//
//  MeView.swift
//  Keysoc Test
//
//  Created by hino on 21/8/2023.
//

import SwiftUI

struct BookmarkView: View {
    @AppStorage("lang") var lang: String = "en"
    var body: some View {
        VStack(){
            Text("language")
                .font(.title)
                .padding()
            HStack(spacing: 30){
                // en Button
                Button {
                    lang = "en"
                } label: {
                    VStack{
                        Text("lang_eng")
                        Image(systemName: lang == "en" ? "largecircle.fill.circle" : "circle")
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 20, height: 20)
                    }
                }
                .frame(width: 100)

                // zh-HK Button
                Button {
                    lang = "zh-HK"
                } label: {
                    VStack{
                        Text("lang_tc")
                        Image(systemName: lang == "zh-HK" ? "largecircle.fill.circle" : "circle")
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 20, height: 20)
                    }
                    
                }
                .frame(width: 100)
                
                // zh-HK Button
                Button {
                    lang = "zh-Hans"
                } label: {
                    VStack{
                        Text("lang_sc")
                        Image(systemName: lang == "zh-Hans" ? "largecircle.fill.circle" : "circle")
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 20, height: 20)
                    }
                }
                .frame(width: 100)
            }
            Text("bookmark_list")
                .font(.title)
                .padding()
            Spacer()
        }
        .padding()
    }
}

struct BookmarkView_Previews: PreviewProvider {
    static var previews: some View {
        BookmarkView()
    }
}
