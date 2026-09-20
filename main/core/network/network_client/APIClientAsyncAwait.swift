//
//  APIClientAsyncAwait.swift
//  ReadyMadeProjectSetup
//
//  Created by kundan Dev on 20/09/26.
//

/*
 ┌─────────────────────────────────────────────────────────────┐
 │         APIClient  —  async / await  Network Layer          │
 │                                                             │
 │  ► fetchPosts()  →  Hard-coded method  (UNCOMMENTED)        │
 │  ► request<T>()  →  Generic method    (COMMENTED OUT)       │
 │                     Uncomment during session to show        │
 │                     how ONE method handles all HTTP calls   │
 └─────────────────────────────────────────────────────────────┘
 */

import Foundation

// MARK: - Protocol
protocol APIClientProtocol {
    func request<T: Codable>(type: EndPointType) async throws -> T
}

// MARK: - Concrete Class
final class APIClient: APIClientProtocol {

    nonisolated init() {}

    // ─────────────────────────────────────────────────────────
    // MARK: WAY 2 ► Generic request<T> method  [COMMENTED OUT]
    // ─────────────────────────────────────────────────────────
    // Uncomment this during the session to show how a single
    // generic method can handle GET, POST, PUT, DELETE for
    // ANY Codable model — no need to write a new function per API.
    //
    // func request<T: Codable>(type: EndPointType) async throws -> T {
    //     // Step 1 — Build URLRequest from endpoint
    //     let urlRequest = try Request_Builder().buildRequest(from: type)
    //
    //     // Step 2 — Fire the request (suspend here, free the thread)
    //     let (data, response) = try await URLSession.shared.data(for: urlRequest)
    //
    //     // Step 3 — Validate HTTP status code
    //     guard let http = response as? HTTPURLResponse else {
    //         throw DataError.invalidResponse
    //     }
    //     try validateStatusCode(http.statusCode, data: data)
    //
    //     // Step 4 — Decode JSON into our Codable model  T
    //     do {
    //         return try JSONDecoder().decode(T.self, from: data)
    //     } catch {
    //         throw DataError.decodingError(error)
    //     }
    // }

    // ✅ Protocol conformance stub — keeps the build green while generic impl is commented.
    // During session: delete this stub, uncomment the full implementation above ✂️
    func request<T: Codable>(type: EndPointType) async throws -> T {
        fatalError("✂️  Uncomment the generic request<T> implementation above during the session")
    }


    // ─────────────────────────────────────────────────────────
    // MARK: WAY 1 ► Hard-coded fetchPosts()  [ACTIVE]
    // ─────────────────────────────────────────────────────────
    // Direct, easy-to-read method. Great for teaching.
    // URL: https://jsonplaceholder.typicode.com/posts
    //
    func fetchPosts() async throws -> [Post] {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!

        // Fire request — thread suspends here, resumes when response arrives
        let (data, response) = try await URLSession.shared.data(from: url)

        // Validate status code
        guard let http = response as? HTTPURLResponse else {
            throw DataError.invalidStatusCode(0)
        }
        try validateStatusCode(http.statusCode, data: data)

        // Decode JSON → [Post]
        return try JSONDecoder().decode([Post].self, from: data)
    }

    // ─────────────────────────────────────────────────────────
    // MARK: - Helpers (SRP)
    // ─────────────────────────────────────────────────────────
    private func validateStatusCode(_ statusCode: Int, data: Data) throws {
        try Validate_Status_Code.validateStatusCode(statusCode, data: data)
    }

    private func parseErrorMessage(from data: Data) -> String? {
        Parse_Error_Messege.parseErrorMessage(from: data)
    }
}

// MARK: - Request Builder (SRP)
struct Request_Builder {

    private let encoder: JSONEncoder

    init(encoder: JSONEncoder = JSONEncoder()) {
        self.encoder = encoder
    }

    func buildRequest(from endpoint: EndPointType) throws -> URLRequest {
        guard let url = endpoint.url else { throw DataError.invalidURL }

        var request        = URLRequest(url: url)
        request.httpMethod = endpoint.httpMethod?.rawValue ?? "GET"

        if let body = endpoint.httpBody {
            request.httpBody = try encoder.encode(body)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        endpoint.header?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        return request
    }
}

// MARK: - Status Code Validator (SRP)
struct Validate_Status_Code {
    static func validateStatusCode(_ statusCode: Int, data: Data) throws {
        switch statusCode {
        case 200...299: return
        case 400:
            let msg = Parse_Error_Messege.parseErrorMessage(from: data) ?? "Bad request"
            throw DataError.badRequest(statusCode: statusCode, message: msg)
        case 401:
            throw DataError.unauthorized(statusCode: statusCode)
        case 403:
            throw DataError.forbidden(statusCode: statusCode)
        case 404:
            throw DataError.notFound(statusCode: statusCode)
        case 500...599:
            let msg = Parse_Error_Messege.parseErrorMessage(from: data) ?? "Server error"
            throw DataError.serverError(statusCode, message: msg)
        default:
            throw DataError.invalidStatusCode(statusCode)
        }
    }
}

// MARK: - Error Message Parser (SRP)
struct Parse_Error_Messege {
    static func parseErrorMessage(from data: Data) -> String? {
        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return nil }
        if let msg = json["message"] as? String { return msg }
        if let err = json["error"]   as? String { return err }
        if let err = json["error"]   as? [String: Any], let msg = err["message"] as? String { return msg }
        return nil
    }
}
