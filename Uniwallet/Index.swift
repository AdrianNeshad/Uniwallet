//
//  Index.swift
//  Uniwallet
//
//  Created by Adrian Neshad on 2025-05-17.
//

import SwiftUI

struct Index: View {
    @StateObject private var store = CardStorage()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.cards) { card in
                    VStack(alignment: .leading) {
                        Text(card.title).font(.headline)
                        Text(card.number).font(.subheadline)
                        Text(card.isQRCode ? "QR-kod" : "Streckkod").font(.caption)
                    }
                }
                .onDelete(perform: store.removeCard)
            }
            .navigationTitle("Mina Kort")
            .toolbar {
                Button(action: {
                    // Här kan du visa ett formulär för att lägga till nytt kort
                    let newCard = Card(title: "Testkort", number: "1234567890", isQRCode: true)
                    store.addCard(newCard)
                }) {
                    Image(systemName: "plus")
                }
            }
        }
    }
}
