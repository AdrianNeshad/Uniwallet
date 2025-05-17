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
        var isQRCode: Bool
        
        init(title: String, number: String, isQRCode: Bool) {
            self.id = UUID()
            self.title = title
            self.number = number
            self.isQRCode = isQRCode
        }
    }
