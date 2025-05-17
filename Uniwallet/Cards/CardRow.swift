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
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(cardColor(for: card.formatType))
                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)

            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(card.title)
                        .font(.title3.bold())
                        .foregroundColor(.white)
                    Spacer()
                }

                Text(card.formatType.rawValue)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))

                VStack(spacing: 6) {
                    CodeImageView(data: card.number, format: card.formatType)
                        .padding(.horizontal, 2)
                        .padding(.vertical, 1)
                        .background(Color.white)
                        .cornerRadius(10)
                        .frame(maxWidth: .infinity)

                    Text(card.number)
                        .font(.system(.subheadline, design: .monospaced))
                        .foregroundColor(.white.opacity(0.95))
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .padding()
        }
        .aspectRatio(1.585, contentMode: .fit)
        .padding(.vertical, 6)
        .contextMenu {
            Button(action: onRename) {
                Label(appLanguage == "en" ? "Rename" : "Byt namn", systemImage: "pencil")
            }
            Button(action: {
                print("Lägg till i Wallet – Kommer snart")
            }) {
                Label(appLanguage == "en" ? "Add to Apple Wallet" : "Lägg till i Apple Wallet", systemImage: "creditcard")
            }
            Button(role: .destructive, action: onDelete) {
                Label(appLanguage == "en" ? "Delete Card" : "Ta bort kort", systemImage: "trash")
            }
        }
    }

    private func cardColor(for format: Card.FormatType) -> Color {
        switch format {
        case .qr: return Color.blue
        case .code128: return Color.green
        case .ean13, .ean8: return Color.purple
        case .pdf417: return Color.orange
        case .aztec: return Color.red
        case .dataMatrix: return Color.teal
        default: return Color.gray
        }
    }
}
