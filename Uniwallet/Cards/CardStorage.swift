//
//  CardStorage.swift
//  Uniwallet
//
//  Created by Adrian Neshad on 2025-05-17.
//

import Foundation

class CardStorage: ObservableObject {
    @Published var cards: [Card] = []
    
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
    
    private func saveCards() {
        do {
            let data = try JSONEncoder().encode(cards)
            try data.write(to: saveURL, options: [.atomic, .completeFileProtection])
        } catch {
            print("❌ Error saving cards: \(error.localizedDescription)")
        }
    }
    
    private func loadCards() {
        do {
            let data = try Data(contentsOf: saveURL)
            let decoded = try JSONDecoder().decode([Card].self, from: data)
            self.cards = decoded
        } catch {
            print("ℹ️ No saved cards found or failed to load.")
            self.cards = []
        }
    }
}
