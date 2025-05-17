//
//  RenameCard.swift
//  Uniwallet
//
//  Created by Adrian Neshad on 2025-05-17.
//

import SwiftUI

struct RenameCard: View {
    @Binding var isPresented: Bool
    @Binding var selectedCard: Card?
    @Binding var newTitle: String
    @AppStorage("appLanguage") var appLanguage: String = "en"
    
    @EnvironmentObject var store: CardStorage

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                Form {
                    Section(header: Text(appLanguage == "en" ? "New Name" : "Nytt namn")) {
                        TextField(appLanguage == "en" ? "Enter new name" : "Ange nytt namn", text: $newTitle)
                    }
                }
                .frame(height: 120)

                HStack {
                    Spacer()
                    Button(action: saveName) {
                        Text(appLanguage == "en" ? "Save" : "Spara")
                            .fontWeight(.bold)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                    }
                    Spacer()
                }

                Spacer()
            }
            .padding()
            .navigationTitle(appLanguage == "en" ? "Rename Card" : "Byt namn")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(appLanguage == "en" ? "Cancel" : "Avbryt") {
                        isPresented = false
                    }
                }
            }
        }
    }

    private func saveName() {
        guard let selected = selectedCard,
              let index = store.cards.firstIndex(of: selected) else { return }
        
        store.cards[index].title = newTitle
        store.saveCards()
        isPresented = false
    }
}
