//
//  EmptyCard.swift
//  Uniwallet
//
//  Created by Adrian Neshad on 2025-05-17.
//

import SwiftUI

struct EmptyCard: View {
    @AppStorage("appLanguage") var appLanguage: String = "en"
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "creditcard")
                .font(.largeTitle)
                .foregroundColor(.gray)
            
            Text(appLanguage == "en"
                 ? "You have not added any cards yet, click the '+' button to add a new card"
                 : "Du har inte lagt till något kort, klicka på '+' knappen för att lägga till ett kort")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding()
    }
}
