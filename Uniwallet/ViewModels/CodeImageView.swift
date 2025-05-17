//
//  CodeImageView.swift
//  Uniwallet
//
//  Created by Adrian Neshad on 2025-05-17.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct CodeImageView: View {
    let data: String
    let format: Card.FormatType

    private let context = CIContext()
    private let qrFilter = CIFilter.qrCodeGenerator()
    private let pdf417Filter = CIFilter.pdf417BarcodeGenerator()
    private let dataMatrixFilter = CIFilter(name: "CIDataMatrixCodeGenerator")
    private let code128Filter = CIFilter.code128BarcodeGenerator()

    var body: some View {
        if let image = generateCodeImage(from: data) {
            Image(uiImage: image)
                .interpolation(.none)
                .resizable()
                .scaledToFit()
                .frame(height: 100)
                .padding(.vertical, 4)
        } else {
            Text("❌")
        }
    }

    private func generateCodeImage(from string: String) -> UIImage? {
        let data = Data(string.utf8)
        let filter: CIFilter?

        switch format {
        case .qr:
            qrFilter.setValue(data, forKey: "inputMessage")
            filter = qrFilter
        case .pdf417:
            pdf417Filter.setValue(data, forKey: "inputMessage")
            filter = pdf417Filter
        case .dataMatrix:
            dataMatrixFilter?.setValue(data, forKey: "inputMessage")
            filter = dataMatrixFilter
        case .code128, .code39, .code93, .ean8, .ean13, .upce, .itf14, .interleaved2of5:
            code128Filter.setValue(data, forKey: "inputMessage")
            filter = code128Filter
        default:
            return nil
        }

        guard var outputImage = filter?.outputImage else { return nil }

        // ✂️ Beskär bort marginal (quiet zone)
        outputImage = outputImage.cropped(to: outputImage.extent.insetBy(dx: 4, dy: 4))

        // 🔍 Skala upp för kvalitet
        let scale = CGAffineTransform(scaleX: 8, y: 8)
        let scaledImage = outputImage.transformed(by: scale)

        guard let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) else {
            return nil
        }

        return UIImage(cgImage: cgImage)
    }
}
