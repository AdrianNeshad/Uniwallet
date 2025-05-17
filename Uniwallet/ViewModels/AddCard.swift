//
//  AddCard.swift
//  Uniwallet
//
//  Created by Adrian Neshad on 2025-05-17.
//

import SwiftUI
import CodeScanner
import AVFoundation

struct AddCard: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var store: CardStorage
    
    @State private var title: String = ""
    @State private var number: String = ""
    @AppStorage("appLanguage") var appLanguage: String = "en"
    @State private var showScanner = false
    @State private var scanError: ScanError?
    @State private var showScanError = false
    
    // Alla kodtyper som stöds
    private let supportedCodeTypes: [AVMetadataObject.ObjectType] = [
        // QR och 2D-koder
        .qr,
        .pdf417,
        .aztec,
        .dataMatrix,
        
        // Streckkoder
        .ean13,
        .ean8,
        .upce,
        .code39,
        .code39Mod43,
        .code93,
        .code128,
        .interleaved2of5,
        .itf14
    ]
    
    // Beräknad property för formatikon
    private var formatIcon: String {
        let type = Card.detectFormatType(from: number)
        switch type {
        case .qr: return "qrcode"
        case .ean8, .ean13, .upce: return "barcode"
        case .pdf417: return "doc.text.fill"
        case .aztec: return "viewfinder"
        case .dataMatrix: return "square.grid.2x2"
        case .code39, .code93, .code128: return "barcode.viewfinder"
        case .itf14, .interleaved2of5: return "barcode"
        default: return "questionmark"
        }
    }
    
    var body: some View {
        Form {
            Section(header: Text(appLanguage == "en" ? "Card Name" : "Kortnamn")) {
                TextField(appLanguage == "en" ? "e.g. Gym Membership" : "t.ex. Gymkort", text: $title)
            }
            
            Section(header: Text(appLanguage == "en" ? "Card Number" : "Kortnummer")) {
                TextField(appLanguage == "en" ? "Enter manually" : "Ange manuellt", text: $number)
                    .keyboardType(.numbersAndPunctuation)
                
                Button(action: { showScanner = true }) {
                    Label(appLanguage == "en" ? "Scan QR-Code or Barcode" : "Skanna QR-kod eller streckkod",
                          systemImage: "camera")
                }
            }
            
            if !number.isEmpty {
                Section(header: Text(appLanguage == "en" ? "Detected Format" : "Upptäckt format")) {
                    HStack {
                        Image(systemName: formatIcon)
                            .foregroundColor(.blue)
                        Text("\(Card.detectFormatType(from: number).rawValue)")
                            .font(.subheadline)
                    }
                }
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
            scannerSheet
        }
        .alert(isPresented: $showScanError) {
            Alert(
                title: Text(appLanguage == "en" ? "Scan Error" : "Skanningsfel"),
                message: Text(scanError?.localizedDescription ??
                            (appLanguage == "en" ? "Unknown error" : "Okänt fel")),
                dismissButton: .default(Text("OK")))
        }
    }
    
    private var scannerSheet: some View {
        CodeScannerView(
            codeTypes: supportedCodeTypes,
            scanMode: .once,
            showViewfinder: true,
            completion: handleScanResult
        )
        .edgesIgnoringSafeArea(.all)
    }
    
    private func handleScanResult(result: Result<ScanResult, ScanError>) {
        switch result {
        case .success(let result):
            self.number = result.string
            showScanner = false
        case .failure(let error):
            self.scanError = error
            self.showScanError = true
        }
    }
    
    private func addCard() {
        let newCard = Card(title: title, number: number)
        store.addCard(newCard)
        presentationMode.wrappedValue.dismiss()
    }
}
