//
//  APIErrorResponse.swift
//  FrameInvaders
//
//  Created by ibarts on 08/07/26.
//

import Foundation

// 2. API Response Model for Error Handling
struct APIErrorResponse: Codable {
    let error: ErrorDetail?
    let errors: [String: [String]]?  // For validation errors
    let message: String?
    
    struct ErrorDetail: Codable {
        let code: String
        let message: String
    }
}


// 4. Empty Response for DELETE and other no-content responses
struct EmptyResponse: Codable {}
