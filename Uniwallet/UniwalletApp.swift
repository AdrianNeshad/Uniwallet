//
//  UniwalletApp.swift
//  Uniwallet
//
//  Created by Adrian Neshad on 2025-05-17.
//

import SwiftUI

@main
struct UniwalletApp: App {
    @StateObject private var store = CardStorage()
    
    var body: some Scene {
        WindowGroup {
            Index()
        }
    }
}
