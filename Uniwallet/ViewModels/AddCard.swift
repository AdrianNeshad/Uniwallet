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
    @State private var selectedFormat: Card.FormatType? = nil

    private let supportedCodeTypes: [AVMetadataObject.ObjectType] = [
        .qr, .pdf417, .aztec, .dataMatrix,
        .ean13, .ean8, .upce,
        .code39, .code39Mod43, .code93, .code128,
        .interleaved2of5, .itf14
        // Obs: codabar stöds ej av AVFoundation för skanning, men kan användas manuellt
    ]

    private var formatIcon: String {
        let type = selectedFormat ?? Card.detectFormatType(from: number)
        switch type {
        case .qr: return "qrcode"
        case .ean8, .ean13, .upce: return "barcode"
        case .pdf417: return "doc.text.fill"
        case .aztec: return "viewfinder"
        case .dataMatrix: return "square.grid.2x2"
        case .code39, .code93, .code128: return "barcode.viewfinder"
        case .itf14, .interleaved2of5, .codabar: return "barcode"
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
                    .padding(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(
                                !isValidFormat && !number.isEmpty ? Color.red : Color.clear,
                                lineWidth: 1
                            )
                    )

                if !isValidFormat && !number.isEmpty {
                    Text(appLanguage == "en" ? "Invalid format for selected type" : "Ogiltigt format för valt typ")
                        .font(.caption)
                        .foregroundColor(.red)
                }

                Button(action: { showScanner = true }) {
                    Label(appLanguage == "en" ? "Scan QR-Code or Barcode" : "Skanna QR-kod eller streckkod",
                          systemImage: "camera")
                }

                Picker(appLanguage == "en" ? "Format (optional)" : "Format (valfritt)", selection: $selectedFormat) {
                    Text(appLanguage == "en" ? "Automatic" : "Automatisk")
                        .tag(Optional(Card.detectFormatType(from: number)))
                    ForEach(Card.FormatType.allCases.filter { $0 != .unknown }, id: \.self) { format in
                        Text(format.rawValue).tag(Optional(format))
                    }
                }
            }


            if !number.isEmpty {
                Section(header: Text(appLanguage == "en" ? "Format" : "Format")) {
                    HStack {
                        Image(systemName: formatIcon)
                            .foregroundColor(.blue)
                        Text(selectedFormat?.rawValue ?? Card.detectFormatType(from: number).rawValue)
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
        let adjusted = adjustedNumber(for: selectedFormat, original: number)
        let newCard = Card(title: title, number: adjusted, formatType: selectedFormat)
        store.addCard(newCard)
        presentationMode.wrappedValue.dismiss()
    }
    
    private var isValidFormat: Bool {
        guard !number.isEmpty else { return false }

        let code = number.trimmingCharacters(in: .whitespacesAndNewlines)
        let selected = selectedFormat ?? Card.detectFormatType(from: code)

        switch selected {
        case .ean13:
            return code.range(of: #"^\d{13}$"#, options: .regularExpression) != nil
        case .ean8:
            return code.range(of: #"^\d{8}$"#, options: .regularExpression) != nil
        case .upce:
            return code.range(of: #"^\d{6,8}$"#, options: .regularExpression) != nil
        case .code128, .code39, .code93, .itf14, .interleaved2of5:
            return !code.isEmpty // generellt tillåtna
        case .codabar:
            return code.range(of: #"^[A-D][0-9+\-:$/.]+[A-D]$"#, options: .regularExpression) != nil
        case .qr, .pdf417, .aztec, .dataMatrix:
            return !code.isEmpty
        default:
            return false
        }
    }
    private func adjustedNumber(for format: Card.FormatType?, original: String) -> String {
        guard let format = format, format == .codabar else { return original }

        let trimmed = original.trimmingCharacters(in: .whitespacesAndNewlines)

        let startsWithValid = trimmed.first.map { "ABCD".contains($0.uppercased()) } ?? false
        let endsWithValid = trimmed.last.map { "ABCD".contains($0.uppercased()) } ?? false

        var adjusted = trimmed

        if !startsWithValid {
            adjusted = "A" + adjusted
        }

        if !endsWithValid {
            adjusted += "A"
        }

        return adjusted
    }
}

