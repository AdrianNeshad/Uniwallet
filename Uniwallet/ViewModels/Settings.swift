//
//  Settings.swift
//  Uniwallet
//
//  Created by Adrian Neshad on 2025-05-17.
//

import SwiftUI
import StoreKit

struct Settings: View {
    @AppStorage("appLanguage") private var appLanguage = "en"
    
    var body: some View {
        Form {
            Section() {
                Picker("Språk / Language", selection: $appLanguage) {
                    Text("English").tag("en")
                    Text("Svenska").tag("sv")
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            AppFooter()
        }
        .navigationTitle(appLanguage == "en" ? "Settings" : "Inställningar")   
    }
}
