import AppKit
import Foundation
import Vision

enum OCRFailure: Error {
    case usage
    case imageLoadFailed(String)
    case cgImageUnavailable(String)
}

func recognizedText(for path: String) throws -> [String] {
    let url = URL(fileURLWithPath: path)
    guard let image = NSImage(contentsOf: url) else {
        throw OCRFailure.imageLoadFailed(path)
    }

    var rect = NSRect(origin: .zero, size: image.size)
    guard let cgImage = image.cgImage(forProposedRect: &rect, context: nil, hints: nil) else {
        throw OCRFailure.cgImageUnavailable(path)
    }

    let request = VNRecognizeTextRequest()
    request.recognitionLevel = .accurate
    request.usesLanguageCorrection = false

    let handler = VNImageRequestHandler(cgImage: cgImage)
    try handler.perform([request])

    return (request.results ?? []).compactMap { observation in
        observation.topCandidates(1).first?.string
    }
}

do {
    guard CommandLine.arguments.count == 2 else {
        throw OCRFailure.usage
    }

    for line in try recognizedText(for: CommandLine.arguments[1]) {
        print(line)
    }
} catch OCRFailure.usage {
    fputs("usage: sim_ocr <image-path>\n", stderr)
    exit(1)
} catch OCRFailure.imageLoadFailed(let path) {
    fputs("failed to load image: \(path)\n", stderr)
    exit(1)
} catch OCRFailure.cgImageUnavailable(let path) {
    fputs("failed to create CGImage for: \(path)\n", stderr)
    exit(1)
} catch {
    fputs("ocr failed: \(error)\n", stderr)
    exit(1)
}
