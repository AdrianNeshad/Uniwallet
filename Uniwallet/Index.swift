//
//  Index.swift
//  Uniwallet
//
//  Created by Adrian Neshad on 2025-05-17.
//

import SwiftUI

struct Index: View {
    @EnvironmentObject var store: CardStorage
    @AppStorage("appLanguage") var appLanguage: String = "en"
    @State private var searchTerm = ""
    @State private var isRenaming = false
    @State private var selectedCard: Card?
    @State private var newTitle = ""
    @State private var cardToDelete: Card? = nil
    @State private var showDeleteConfirmation = false

    var body: some View {
        NavigationView {
            List {
                if store.cards.isEmpty {
                    EmptyCard()
                } else {
                    ForEach(filteredCards) { card in
                        CardRow(
                            card: card,
                            appLanguage: appLanguage,
                            onRename: {
                                selectedCard = card
                                newTitle = card.title
                                isRenaming = true
                            },
                            onDelete: {
                                cardToDelete = card
                                showDeleteConfirmation = true
                            }
                        )
                    }
                }
            }
            .navigationTitle(appLanguage == "en" ? "My Cards" : "Mina kort")
            .searchable(text: $searchTerm,
                        prompt: appLanguage == "en" ? "Search for cards" : "Sök efter kort")
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
            .confirmationDialog(
                appLanguage == "en" ? "Are you sure you want to delete this card?" : "Är du säker på att du vill ta bort detta kort?",
                isPresented: $showDeleteConfirmation,
                titleVisibility: .visible
            ) {
                Button(role: .destructive) {
                    if let card = cardToDelete,
                       let index = store.cards.firstIndex(of: card) {
                        store.cards.remove(at: index)
                        store.saveCards()
                    }
                    cardToDelete = nil
                } label: {
                    Text(appLanguage == "en" ? "Delete" : "Ta bort")
                }

                Button(appLanguage == "en" ? "Cancel" : "Avbryt", role: .cancel) {
                    cardToDelete = nil
                }
            }
            .sheet(isPresented: $isRenaming) {
                RenameCard(
                    isPresented: $isRenaming,
                    selectedCard: $selectedCard,
                    newTitle: $newTitle
                )
                .environmentObject(store)
            }
        }
    }

    var filteredCards: [Card] {
        if searchTerm.isEmpty {
            return store.cards
        } else {
            return store.cards.filter {
                $0.title.localizedCaseInsensitiveContains(searchTerm)
            }
        }
    }
}

#Preview {
    Index()
        .environmentObject(CardStorage())
}
