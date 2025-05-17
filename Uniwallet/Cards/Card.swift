//
//  Card.swift
//  Uniwallet
//
//  Created by Adrian Neshad on 2025-05-17.
//

import Foundation

struct Card: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var number: String
    var formatType: FormatType

    enum FormatType: String, Codable {
        case qr = "QR Code"
        case ean13 = "EAN-13"
        case ean8 = "EAN-8"
        case upce = "UPC-E"
        case code39 = "Code 39"
        case code93 = "Code 93"
        case code128 = "Code 128"
        case pdf417 = "PDF417"
        case aztec = "Aztec"
        case dataMatrix = "Data Matrix"
        case itf14 = "ITF-14"
        case interleaved2of5 = "Interleaved 2 of 5"
        case unknown = "Unknown"
        case codabar = "Codabar"
    }

    init(title: String, number: String) {
        self.id = UUID()
        self.title = title
        self.number = number
        self.formatType = Self.detectFormatType(from: number)
    }

    static func detectFormatType(from code: String) -> FormatType {
        let numericOnly = code.filter { $0.isNumber }

        // QR: Allt som är URL eller innehåller specialtecken
        if code.range(of: #"^https?://"#, options: .regularExpression) != nil {
            return .qr
        }

        if code.count > 30 && code.contains(" ") {
            return .pdf417
        }

        if code.contains("*") && code.count >= 3 {
            return .code39
        }

        // Streckkodslängder
        switch numericOnly.count {
        case 8: return .ean8
        case 12...13: return .ean13
        case 14: return .itf14
        case 6...8: return .upce
        default: break
        }

        // Tänk: personnummer, medlemsnummer, etc
        if code.range(of: #"^[0-9]{6}[- ]?[0-9]{4}$"#, options: .regularExpression) != nil {
            return .code128 // visa som streckkod
        }

        // fallback
        return .code128
    }
}
