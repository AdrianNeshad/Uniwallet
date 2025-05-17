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
    }

    init(title: String, number: String) {
        self.id = UUID()
        self.title = title
        self.number = number
        self.formatType = Self.detectFormatType(from: number)
    }

    static func detectFormatType(from code: String) -> FormatType {
        // QR-kod som URL
        if code.range(of: #"^https?://"#, options: .regularExpression) != nil {
            return .qr
        }

        let numericOnly = code.filter { $0.isNumber }

        switch numericOnly.count {
        case 8: return .ean8
        case 12...13: return .ean13
        case 6...8: return .upce
        case 14: return .itf14
        default: break
        }

        if code.starts(with: "*") && code.count >= 3 && code.last == "*" {
            return .code39
        }

        if code.range(of: #"^[A-Za-z0-9\-]+$"#, options: .regularExpression) != nil {
            if code.count > 20 && code.contains(" ") {
                return .pdf417
            }
            return .code128
        }

        return .unknown
    }
}
