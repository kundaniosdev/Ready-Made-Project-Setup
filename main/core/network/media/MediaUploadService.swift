//
//  MediaUploadService.swift
//  FrameInvaders
//
//  Created by IBArtsDev on 13/07/26.
//
//  Single Responsibility: Handles ONLY binary file uploads to pre-signed S3 URLs.
//  This service is intentionally decoupled from any feature (Bug Reporting, Profile, etc.)
//  so that any part of the app can reuse it for S3 media uploads.
//
//  Reason to change: ONLY if S3 upload strategy changes (e.g., multipart, chunked uploads).
//  Do NOT add feature-specific logic here.
//

import Foundation
import UIKit

// MARK: - Media Item
/// Represents a single uploadable media file with its binary data and MIME type.
/// Create one MediaItem per file (image or video) before calling MediaUploadService.
struct MediaItem {
    let data: Data
    let mimeType: String    // e.g. "image/jpeg" or "video/mp4"

    // MARK: - Convenience Initialisers

    /// Create a MediaItem from a UIImage (JPEG compressed)
    static func from(image: UIImage, compressionQuality: CGFloat = 0.85) -> MediaItem? {
        guard let data = image.jpegData(compressionQuality: compressionQuality) else { return nil }
        return MediaItem(data: data, mimeType: "image/jpeg")
    }

    /// Create a MediaItem from a local video file URL
    static func from(videoURL: URL) -> MediaItem? {
        guard let data = try? Data(contentsOf: videoURL) else { return nil }
        return MediaItem(data: data, mimeType: "video/mp4")
    }
}

// MARK: - Protocol (Loose Coupling / Testability)
/// Any class that conforms to this protocol can upload media files.
/// This allows easy mocking in unit tests without hitting the real S3.
protocol MediaUploadServiceProtocol {
    func upload(items: [MediaItem], to urls: [String]) async throws
}

// MARK: - MediaUploadService
/// Concrete implementation.
/// Uploads binary media files one-by-one to pre-signed S3 URLs via HTTP PUT.
///
/// Usage:
/// ```swift
/// let service = MediaUploadService()
/// try await service.upload(items: mediaItems, to: response.uploadUrls)
/// ```
final class MediaUploadService: MediaUploadServiceProtocol {

    // MARK: - Dependencies
    private let session: URLSession
    private let timeoutInterval: TimeInterval

    init(
        session: URLSession = .shared,
        timeoutInterval: TimeInterval = 60   // 60 seconds per file upload
    ) {
        self.session = session
        self.timeoutInterval = timeoutInterval
    }

    // MARK: - Public Upload Method
    /// Uploads an array of MediaItems to their corresponding pre-signed S3 URLs.
    /// Items and URLs are matched by index:
    ///   items[0] → urls[0], items[1] → urls[1], etc.
    ///
    /// - Parameters:
    ///   - items: Array of MediaItem (image or video binary data)
    ///   - urls:  Array of pre-signed S3 URLs received from the backend POST /tickets response
    /// - Throws: `MediaUploadError` if any upload fails
    func upload(items: [MediaItem], to urls: [String]) async throws {
        guard items.count <= urls.count else {
            throw MediaUploadError.urlCountMismatch(
                itemCount: items.count,
                urlCount: urls.count
            )
        }

        // Upload each file one-by-one (serial — avoids saturating network bandwidth)
        for (index, item) in items.enumerated() {
            let urlString = urls[index]
            try await uploadSingleFile(item: item, to: urlString, index: index)
        }
    }

    // MARK: - Private Upload Helper
    /// Sends a single HTTP PUT request with binary body to an S3 pre-signed URL.
    private func uploadSingleFile(item: MediaItem, to urlString: String, index: Int) async throws {
        guard let url = URL(string: urlString) else {
            throw MediaUploadError.invalidURL(urlString)
        }

        var request = URLRequest(url: url, timeoutInterval: timeoutInterval)
        request.httpMethod = HTTPMethods.put.rawValue
        request.setValue(item.mimeType, forHTTPHeaderField: "Content-Type")

        do {
            let (_, response) = try await session.upload(for: request, from: item.data)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw MediaUploadError.invalidResponse(index: index)
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                throw MediaUploadError.uploadFailed(
                    index: index,
                    statusCode: httpResponse.statusCode
                )
            }

            #if DEBUG
            print("[MediaUploadService] ✅ File \(index + 1) uploaded (\(item.mimeType))")
            #endif

        } catch let error as MediaUploadError {
            throw error   // re-throw our typed errors
        } catch {
            throw MediaUploadError.networkError(index: index, underlying: error)
        }
    }
}

// MARK: - MediaUploadError
/// Typed errors specific to media upload operations.
/// Each case gives the caller enough context to display a meaningful message.
enum MediaUploadError: LocalizedError {
    case urlCountMismatch(itemCount: Int, urlCount: Int)
    case invalidURL(String)
    case invalidResponse(index: Int)
    case uploadFailed(index: Int, statusCode: Int)
    case networkError(index: Int, underlying: Error)

    var errorDescription: String? {
        switch self {
        case .urlCountMismatch(let items, let urls):
            return "Cannot upload \(items) files — only \(urls) S3 URLs were provided."
        case .invalidURL(let url):
            return "Invalid S3 URL: \(url)"
        case .invalidResponse(let index):
            return "Invalid server response for file \(index + 1)."
        case .uploadFailed(let index, let code):
            return "File \(index + 1) upload failed with HTTP \(code)."
        case .networkError(let index, let error):
            return "Network error uploading file \(index + 1): \(error.localizedDescription)"
        }
    }
}
