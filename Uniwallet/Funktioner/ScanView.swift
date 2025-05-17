//
//  ScanView.swift
//  Uniwallet
//
//  Created by Adrian Neshad on 2025-05-17.
//

import SwiftUI
import CodeScanner

struct ScannerView: View {
    let completion: (String) -> Void
    
    var body: some View {
        CodeScannerView(
            codeTypes: [.qr, .ean13, .ean8, .code128], // Lägg till fler typer om behövs
            completion: { result in
                switch result {
                case .success(let scanned):
                    completion(scanned.string)
                case .failure(let error):
                    print("Scanning failed: \(error.localizedDescription)")
                }
            }
        )
        .edgesIgnoringSafeArea(.all)
    }
}
