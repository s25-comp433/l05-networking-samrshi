//
//  ContentView.swift
//  BasketballGames
//
//  Created by Samuel Shi on 2/27/25.
//

import SwiftUI

struct Score: Codable {
    let unc: Int
    let opponent: Int
}

struct BasketballGame: Codable {
    let id: Int
    let team: String
    let date: String
    let opponent: String
    let isHomeGame: Bool
    let score: Score
}

struct ContentView: View {
    @State private var games: [BasketballGame] = []
    
    var body: some View {
        NavigationStack {
            List(games, id: \.id) { game in
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(game.team) vs. \(game.opponent)")
                        
                        Text("\(game.date)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("\(game.score.unc) - \(game.score.opponent)")
                        
                        Text("\(game.isHomeGame ? "Home" : "Away")")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("UNC Basketball")
            .task {
                await loadData()
            }
        }
    }
    
    func loadData() async {
        guard let url = URL(string: "http://localhost:8080/uncbasketball") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode([BasketballGame].self, from: data) {
                games = decodedResponse
            }
        } catch {
            print("Invalid data")
        }
    }
}

#Preview {
    ContentView()
}
