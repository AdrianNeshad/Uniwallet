//
//  CardStorage.swift
//  Uniwallet
//
//  Created by Adrian Neshad on 2025-05-17.
//

import Foundation
import SwiftUI

class CardStorage: ObservableObject {
    @Published var cards: [Card] = []
    @AppStorage("appLanguage") var appLanguage: String = "en"
    
    private let saveURL: URL
    
    init() {
        let filename = "cards.json"
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        self.saveURL = directory.appendingPathComponent(filename)
        
        loadCards()
    }
    
    func addCard(_ card: Card) {
        cards.append(card)
        saveCards()
    }
    
    func removeCard(at offsets: IndexSet) {
        cards.remove(atOffsets: offsets)
        saveCards()
    }
    
    func saveCards() {
        do {
            let data = try JSONEncoder().encode(cards)
            try data.write(to: saveURL, options: [.atomic, .completeFileProtection])
        } catch {
            print(appLanguage == "en" ? "❌ Error saving cards: \(error.localizedDescription)" : "❌ Fel vid sparande av kort: \(error.localizedDescription)")
        }
    }
    
    private func loadCards() {
        do {
            let data = try Data(contentsOf: saveURL)
            let decoded = try JSONDecoder().decode([Card].self, from: data)
            self.cards = decoded
        } catch {
            print(appLanguage == "en" ? "No saved cards found or failed to load" : " Inga sparade kort eller fel vid hämtning")
            self.cards = []
        }
    }
}
