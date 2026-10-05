//
//  APIManager.swift
//  FrameInvaders
//
//  Created by ibarts on 01/07/26.
//

import Foundation

protocol APIClientProtocol {
    func request<T: Codable>(type: EndPointType) async throws -> T
}

// Concreate classs NetworkClient who confirms APIClientProtocol
final class APIClient: APIClientProtocol {
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
    init(session: URLSession = .shared,
         decoder: JSONDecoder = JSONDecoder(),
         encoder: JSONEncoder = JSONEncoder()) {
        self.session = session
        self.decoder = decoder
        self.encoder = encoder
    }

    func request<T: Codable>(type: EndPointType) async throws -> T {
        print("Requesting \(type.httpMethod?.rawValue ?? "GET") API: \(type.url?.absoluteString ?? "Unknown URL")")
        
        // Build request
        let request = try Request_Builder().buildRequest(from: type)
        
        // Make request with timeout
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        let session = URLSession(configuration: configuration)
        
        do {
            let (data, response) = try await session.data(for: request)
            
            // Log API details (Request URL, headers, body, response status, response body)
            APILogger.log(request: request, response: response, data: data)
            
            // Validate response
            guard let httpResponse = response as? HTTPURLResponse else {
                throw DataError.invalidResponse
            }
            
            // Check status code
            try validateStatusCode(httpResponse.statusCode, data: data)
            
            // Check if data is empty
            guard !data.isEmpty else {
                if T.self == EmptyResponse.self {
                    return EmptyResponse() as! T
                }
                throw DataError.noData
            }
            
            // Decode data
            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                // Try to decode error response
                if let apiError = try? decoder.decode(APIErrorResponse.self, from: data) {
                    if let errorDetail = apiError.error {
                        throw DataError.apiError(code: errorDetail.code, message: errorDetail.message)
                    }
                    if let message = apiError.message {
                        throw DataError.custom(message: message)
                    }
                }
                throw DataError.decodingError(error)
            }
            
        } catch let error as DataError {
            // Re-throw our custom errors
            throw error
        } catch let error as URLError {

            switch error.code {

            case .notConnectedToInternet:
                throw DataError.noInternetConnection

            case .timedOut:
                throw DataError.requestTimeout

            case .networkConnectionLost:
                throw DataError.connectionLost

            case .cannotFindHost,
                 .cannotConnectToHost,
                 .dnsLookupFailed,
                 .resourceUnavailable:
                throw DataError.serverUnavailable

            case .secureConnectionFailed,
                 .serverCertificateHasBadDate,
                 .serverCertificateHasUnknownRoot,
                 .serverCertificateNotYetValid,
                 .serverCertificateUntrusted,
                 .clientCertificateRejected,
                 .clientCertificateRequired,
                 .appTransportSecurityRequiresSecureConnection:
                throw DataError.secureConnectionFailed

            case .cancelled:
                throw DataError.cancelled

            default:
                throw DataError.unknownNetworkError(error)
            }
        }
    }
    
    private func validateStatusCode(_ statusCode: Int, data: Data) throws {
        return try Validate_Status_Code.validateStatusCode(statusCode, data: data)
    }
    
    private func parseErrorMessage(from data: Data) -> String? {
       return   Parse_Error_Messege.parseErrorMessage(from: data)
    }
}






// SRP
struct Request_Builder {
    
    private let encoder: JSONEncoder
    
    init(encoder: JSONEncoder = JSONEncoder()) {
        self.encoder = encoder
    }
    
    func buildRequest(from endpoint: EndPointType) throws -> URLRequest {
        // Validate URL
        guard let url = endpoint.url else {
            throw DataError.invalidURL
        }
        
        // Build request
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.httpMethod?.rawValue ?? "GET"
        
        // Add body if needed
        if let body = endpoint.httpBody {
            do {
                if let mediaReq = body as? MediaUploadRequest {
                    request.httpBody = mediaReq.multipartBody
                } else {
                    request.httpBody = try encoder.encode(body)
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                }
            } catch {
                throw DataError.invalidRequest
            }
        }
        
        // Add headers
        endpoint.header?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        // return request
        return request
    }
}

// SRP
struct Validate_Status_Code {
    static func validateStatusCode(_ statusCode: Int, data: Data) throws {
        switch statusCode {
        case 200...299:
            return // Success
            
        case 400:
            let errorMessage = Parse_Error_Messege.parseErrorMessage(from: data) ?? "Bad request"
            throw DataError.badRequest(statusCode: statusCode, message: errorMessage)
            
        case 401:
            // Trigger logout or token refresh
            throw DataError.unauthorized(statusCode: statusCode)
            
        case 403:
            throw DataError.forbidden(statusCode: statusCode)
            
        case 404:
            throw DataError.notFound(statusCode: statusCode)
            
        case 500...599:
            let errorMessage = Parse_Error_Messege.parseErrorMessage(from: data) ?? "Internal server error"
            throw DataError.serverError(statusCode, message: errorMessage)
            
        default:
            throw DataError.invalidStatusCode(statusCode)
        }
    }
}
// SRP
struct Parse_Error_Messege {
    static func parseErrorMessage(from data: Data) -> String? {
        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return nil
        }
        
        // Try common error formats
        if let message = json["message"] as? String {
            return message
        }
        if let error = json["error"] as? String {
            return error
        }
        if let error = json["error"] as? [String: Any],
           let message = error["message"] as? String {
            return message
        }
        return nil
    }
}

// MARK: - API Logger
struct APILogger {
    static func log(request: URLRequest, response: URLResponse, data: Data) {
        #if DEBUG
        print("➡️ [API Request] \(request.httpMethod ?? ""): \(request.url?.absoluteString ?? "")")
        if let httpResponse = response as? HTTPURLResponse {
            print("⬅️ [API Response] Status: \(httpResponse.statusCode)")
        }
        #endif
    }
}

// MARK: - Media Upload Request
protocol MediaUploadRequest {
    var multipartBody: Data { get }
}

