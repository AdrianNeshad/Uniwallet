//
//  CardRow.swift
//  Uniwallet
//
//  Created by Adrian Neshad on 2025-05-17.
//

import SwiftUI

struct CardRow: View {
    let card: Card
    let appLanguage: String
    let onRename: () -> Void
    let onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
            Text(card.title).font(.headline)
            Text(card.number).font(.subheadline)
            Text(card.isQRCode ? "QR-Code" : "Barcode").font(.caption)
        }
        .contextMenu {
            Button(action: onRename) {
                Label(appLanguage == "en" ? "Rename" : "Byt namn", systemImage: "pencil")
            }
            Button(action: {
                // Funktion att lägga till kortet i Apple Wallet
                print("Kommer snart")
            }) {
                Label(appLanguage == "en" ? "Add to Apple Wallet" : "Lägg till i Apple Wallet", systemImage: "creditcard")
            }
            Button(role: .destructive, action: onDelete) {
                Label(appLanguage == "en" ? "Delete Card" : "Ta bort kort", systemImage: "trash")
            }
        }
    }
}
