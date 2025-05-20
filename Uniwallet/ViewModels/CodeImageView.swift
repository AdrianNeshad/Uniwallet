//
//  CodeImageView.swift
//  Uniwallet
//
//  Created by Adrian Neshad on 2025-05-17.
//

import SwiftUI
import CoreImage.CIFilterBuiltins
import RSBarcodes_Swift
import AVFoundation

struct CodeImageView: View {
    let data: String
    let format: Card.FormatType

    private let context = CIContext()
    private let qrFilter = CIFilter.qrCodeGenerator()
    private let pdf417Filter = CIFilter.pdf417BarcodeGenerator()
    private let aztecFilter = CIFilter(name: "CIAztecCodeGenerator")!
    private let dataMatrixFilter = CIFilter(name: "CIDataMatrixCodeGenerator")
    private let code128Filter = CIFilter.code128BarcodeGenerator()

    var body: some View {
        if let image = generateCodeImage(from: data, format: format) {
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

    private func generateCodeImage(from string: String, format: Card.FormatType) -> UIImage? {
        let data = Data(string.utf8)

        switch format {
        case .qr:
            qrFilter.setValue(data, forKey: "inputMessage")
            return render(filter: qrFilter)

        case .pdf417:
            pdf417Filter.setValue(data, forKey: "inputMessage")
            return render(filter: pdf417Filter)

        case .aztec:
            aztecFilter.setValue(data, forKey: "inputMessage")
            return render(filter: aztecFilter)

        case .dataMatrix:
            dataMatrixFilter?.setValue(data, forKey: "inputMessage")
            return render(filter: dataMatrixFilter)

        // Använd RSBarcodes_Swift för riktiga streckkoder
        case .code128:
            return RSUnifiedCodeGenerator.shared.generateCode(string, machineReadableCodeObjectType: AVMetadataObject.ObjectType.code128.rawValue)
        case .code39:
            return RSUnifiedCodeGenerator.shared.generateCode(string, machineReadableCodeObjectType: AVMetadataObject.ObjectType.code39.rawValue)
        case .code93:
            return RSUnifiedCodeGenerator.shared.generateCode(string, machineReadableCodeObjectType: AVMetadataObject.ObjectType.code93.rawValue)
        case .ean13:
            return RSUnifiedCodeGenerator.shared.generateCode(string, machineReadableCodeObjectType: AVMetadataObject.ObjectType.ean13.rawValue)
        case .ean8:
            return RSUnifiedCodeGenerator.shared.generateCode(string, machineReadableCodeObjectType: AVMetadataObject.ObjectType.ean8.rawValue)
        case .upce:
            return RSUnifiedCodeGenerator.shared.generateCode(string, machineReadableCodeObjectType: AVMetadataObject.ObjectType.upce.rawValue)
        case .itf14:
            return RSUnifiedCodeGenerator.shared.generateCode(string, machineReadableCodeObjectType: AVMetadataObject.ObjectType.itf14.rawValue)
        case .interleaved2of5:
            return RSUnifiedCodeGenerator.shared.generateCode(string, machineReadableCodeObjectType: AVMetadataObject.ObjectType.interleaved2of5.rawValue)
        case .codabar:
            let generator = RSBarCodeCodabarGenerator()
            return generator.generateCode(string)  // special fallback

        default:
            return nil
        }
    }

    private func render(filter: CIFilter?) -> UIImage? {
        guard let outputImage = filter?.outputImage else { return nil }

        let scale = CGAffineTransform(scaleX: 10, y: 10)
        let scaledImage = outputImage.transformed(by: scale)

        guard let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) else {
            return nil
        }

        return UIImage(cgImage: cgImage)
    }
}
