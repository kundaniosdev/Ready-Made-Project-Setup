//
//  DataError.swift
//  FrameInvaders
//
//  Created by ibarts on 08/07/26.
//

import Foundation

// 1. Comprehensive Error Enum
enum DataError: Error, LocalizedError {
    // Network errors
    case networkError(Error)
    case noInternetConnection
    case requestTimeout
    case connectionLost
    case serverUnavailable
    case secureConnectionFailed
    case cancelled
    case unknownNetworkError(URLError)
    
    // URL & Request errors
    case invalidURL
    case invalidRequest
    
    // Response errors
    case invalidResponse
    case invalidStatusCode(Int)
    case noData
    case decodingError(Error)
    
    // Authentication errors
    case unauthorized(statusCode: Int) // Actual code from server (e.g. 401)
    case forbidden(statusCode: Int)    // Actual code from server (e.g. 403)
    case tokenExpired
    
    // Server errors
    case serverError(Int, message: String?)
    case badRequest(statusCode: Int, message: String?) // Actual code from server (e.g. 400)
    case notFound(statusCode: Int)     // Actual code from server (e.g. 404)
    
    // API specific errors
    case apiError(code: String, message: String)
    case custom(message: String)
    
    // LocalizedError conformance for user-friendly messages
    var errorDescription: String? {
        switch self {
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .noInternetConnection:
            return "No internet connection. Please check your network."
        case .requestTimeout:
            return "Request timed out. Please try again."
        case .connectionLost:
            return "The network connection was interrupted. Please try again."

        case .serverUnavailable:
            return "The service is temporarily unavailable. Please try again later."

        case .secureConnectionFailed:
            return "A secure connection to the server could not be established."

        case .cancelled:
            return nil

        case .unknownNetworkError:
            return "Something went wrong. Please try again later."
            
        case .invalidURL:
            return "Invalid URL. Please contact support."
        case .invalidRequest:
            return "Invalid request. Please try again."
        case .invalidResponse:
            return "Invalid response from server."
        case .invalidStatusCode(let code):
            return "Server returned status code: \(code)"
        case .noData:
            return "No data received from server."
        case .decodingError(let error):
            return "Failed to parse data: \(error.localizedDescription)"
        case .unauthorized(let statusCode):
            return "\(statusCode) Unauthorized: Please login to continue."
        case .forbidden(let statusCode):
            return "\(statusCode) Forbidden: You don't have permission to access this resource."
        case .tokenExpired:
            return "Session expired. Please login again."
        case .serverError(let code, let message):
            return "\(code) Server Error: \(message ?? "Please try again later.")"
        case .badRequest(let statusCode, let message):
            return "\(statusCode) Bad Request: \(message ?? "Please check your input.")"
        case .notFound(let statusCode):
            return "\(statusCode) Not Found: The requested resource could not be found."
        case .apiError(let code, let message):
            return "API Error [\(code)]: \(message)"
        case .custom(let message):
            return message
        }
    }
}
