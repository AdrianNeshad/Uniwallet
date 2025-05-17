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
                .fill(cardGradient(for: card.formatType))
                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)

            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(card.title)
                        .font(.title.bold()) // Större än .title3
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7) // Krymper vid långa namn

                    Spacer()
                }
                VStack(spacing: 6) {
                    CodeImageView(data: card.number, format: card.formatType)
                        .padding(.horizontal, card.formatType == .qr ? 10 : 1)  // QR-koder
                        .padding(.vertical, card.formatType == .qr ? 10 : 1)// QR-koder
                        .background(Color.white)
                        .cornerRadius(10)
                        .frame(maxWidth: .infinity)
                    

                    Text(card.formatType.rawValue + " - " + card.number)
                        .font(.system(.subheadline, design: .monospaced))
                        .foregroundColor(.white.opacity(1))
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

    private func cardGradient(for format: Card.FormatType) -> LinearGradient {
        let colors: [Color]

        switch format {
        case .qr:
            colors = [Color(hex: "#1E3A8A"), Color(hex: "#3B82F6")] // Navy → Sky Blue
        case .code128:
            colors = [Color(hex: "#155E75"), Color(hex: "#38BDF8")] // Deep Teal → Light Blue
        case .ean13, .ean8:
            colors = [Color(hex: "#7C3AED"), Color(hex: "#D8B4FE")] // Violet → Lavender
        case .pdf417:
            colors = [Color(hex: "#92400E"), Color(hex: "#F59E0B")] // Bronze → Amber
        case .aztec:
            colors = [Color(hex: "#7F1D1D"), Color(hex: "#F87171")] // Burgundy → Soft Red
        case .dataMatrix:
            colors = [Color(hex: "#065F46"), Color(hex: "#34D399")] // Emerald → Mint
        default:
            colors = [Color(hex: "#374151"), Color(hex: "#9CA3AF")] // Cool Gray → Light Gray
        }

        return LinearGradient(
            gradient: Gradient(colors: colors),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

}
