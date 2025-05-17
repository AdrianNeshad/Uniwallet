//
//  AppFooter.swift
//  Uniwallet
//
//  Created by Adrian Neshad on 2025-05-17.
//

import SwiftUI

struct AppFooter: View {
    var body: some View {
        Section {
            EmptyView()
        } footer: {
            VStack(spacing: 4) {
                Text("© 2025 Wallet Stacker App")
                Text("Github.com/AdrianNeshad")
                Text("Linkedin.com/in/adrian-neshad")
                Text(appVersion)
            }
            .font(.caption)
            .foregroundColor(.gray)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.top, -100)
        }
    }
    private var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "?"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "?"
        return "Version \(version) (\(build))"
    }
}
