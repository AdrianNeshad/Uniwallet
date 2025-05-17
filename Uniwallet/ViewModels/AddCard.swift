//
//  AddCard.swift
//  Uniwallet
//
//  Created by Adrian Neshad on 2025-05-17.
//

import SwiftUI

struct AddCard: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var store: CardStorage

    @State private var title: String = ""
    @State private var number: String = ""
    @State private var isQRCode: Bool = true
    @AppStorage("appLanguage") var appLanguage: String = "en"
    @State private var showScanner = false
    
    var body: some View {
        Form {
            Section(header: Text(appLanguage == "en" ? "Card Name" : "Kortnamn")) {
                TextField(appLanguage == "en" ? "e.g. Gym Membership" : "t.ex. Gymkort", text: $title)
            }

            Section(header: Text(appLanguage == "en" ? "Card Number" : "Kortnummer")) {
                TextField(appLanguage == "en" ? "Enter manually" : "Ange manuellt", text: $number)
                
                Button(action: {
                    showScanner = true
                }) {
                    Label(appLanguage == "en" ? "Scan QR-code or Barcode" : "Skanna QR-kod eller streckkod", systemImage: "camera")
                }
            }

            Section(header: Text(appLanguage == "en" ? "Display Format" : "Visningsformat")) {
                Picker(appLanguage == "en" ? "Select format" : "Välj format", selection: $isQRCode) {
                    Text("QR Code").tag(true)
                    Text("Barcode").tag(false)
                }
                .pickerStyle(SegmentedPickerStyle())
            }

            Section {
                Button(action: addCard) {
                    HStack {
                        Spacer()
                        Text(appLanguage == "en" ? "Add Card" : "Lägg till kort")
                            .fontWeight(.bold)
                        Spacer()
                    }
                }
                .disabled(title.isEmpty || number.isEmpty)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack(spacing: 8) {
                    Image(systemName: "creditcard")
                    Text(appLanguage == "en" ? "Add Card" : "Lägg till kort")
                        .font(.headline)
                }
            }
        }
        .sheet(isPresented: $showScanner) {
            ScannerView { scannedValue in
                self.number = scannedValue
                showScanner = false
            }
        }
    }
    
    private func addCard() {
        let newCard = Card(title: title, number: number, isQRCode: isQRCode)
        store.addCard(newCard)
        presentationMode.wrappedValue.dismiss()
    }
}
