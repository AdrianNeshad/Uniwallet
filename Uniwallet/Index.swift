//
//  Index.swift
//  Uniwallet
//
//  Created by Adrian Neshad on 2025-05-17.
//

import SwiftUI

struct Index: View {
    @StateObject private var store = CardStorage()
    @AppStorage("appLanguage") var appLanguage: String = "en"
    @State private var searchTerm = ""

    var body: some View {
        NavigationView {
            List {
                ForEach(store.cards) { card in
                    VStack(alignment: .leading) {
                        Text(card.title).font(.headline)
                        Text(card.number).font(.subheadline)
                        Text(card.isQRCode ? "QR-Code" : "Barcode").font(.caption)
                    }
                }
                .onDelete(perform: store.removeCard)
            }
            .navigationTitle(appLanguage == "en" ? "My Cards" : "Mina kort")
            .searchable(text: $searchTerm, prompt: appLanguage == "en" ? "Search for cards" : "Sök efter kort")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddCard()) {
                        Image(systemName: "plus.circle")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: Settings()) {
                        Image(systemName: "gearshape")
                    }
                }
            }
        }
    }
}
#Preview {
    Index()
}
