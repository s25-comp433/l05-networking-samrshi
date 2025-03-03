//
//  ContentView.swift
//  iTunesSearch
//
//  Created by Samuel Shi on 2/27/25.
//

import SwiftUI

struct iTunesSearchResponse2: Codable {
    var results: [iTunesSearchResult2]
}

struct iTunesSearchResult2: Codable {
    var trackId: Int
    var trackName: String
    var collectionName: String
}

struct ContentView2: View {
    @State private var results = [iTunesSearchResult2]()
    
    var body: some View {
        List(results, id: \.trackId) { item in
            VStack(alignment: .leading) {
                Text(item.trackName).font(.headline)
                Text(item.collectionName)
            }
        }
        .task {
            await loadData()
        }
    }
    
    func loadData() async {
        guard let url = URL(string: "https://itunes.apple.com/search?term=the+beatles&entity=song") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode(iTunesSearchResponse2.self, from: data) {
                results = decodedResponse.results
            }
        } catch {
            print("Invalid data")
        }
    }
}

#Preview {
    ContentView()
}
