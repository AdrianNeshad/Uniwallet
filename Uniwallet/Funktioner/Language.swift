//
//  Language.swift
//  Uniwallet
//
//  Created by Adrian Neshad on 2025-05-17.
//

import SwiftUI

class StringManager {
    static let shared = StringManager()
    @AppStorage("appLanguage") var language: String = "en"
    
    private let en: [String: String] = [
        "X": "X",
    ]
    
    private let sv: [String: String] = [
        "X": "X",
    ]
    
    func get(_ key: String) -> String {
        let table = language == "en" ? en : sv
        return table[key] ?? key
    }
}
