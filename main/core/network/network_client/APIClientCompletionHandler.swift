//
//  APIClientCompletionHandler.swift
//  ReadyMadeProjectSetup
//
//  Created by kundan Dev on 20/09/26.
//

/*
 ┌─────────────────────────────────────────────────────────────┐
 │      APIClientCompletionHandler  —  Callback Network Layer  │
 │                                                             │
 │  ► fetchPost()   →  Hard-coded method  (UNCOMMENTED)        │
 │  ► request<T>()  →  Generic method    (COMMENTED OUT)       │
 │                     Uncomment during session to show        │
 │                     how ONE generic closure handles all     │
 │                     HTTP calls with completion handler      │
 └─────────────────────────────────────────────────────────────┘
 */

import Foundation

// MARK: - Protocol
// To make API service testable — inject this protocol instead of the concrete class
protocol APIClientProtocolWithCompletetionHandler {
    func request<T: Codable>(type: EndPointType, completionHander: @escaping (Result<T, DataError>) -> Void)
}

// MARK: - Concrete Class
final class APIClientCompletionHandler: APIClientProtocolWithCompletetionHandler {

    nonisolated init() {}

    // ─────────────────────────────────────────────────────────
    // MARK: WAY 2 ► Generic request<T> method  [COMMENTED OUT]
    // ─────────────────────────────────────────────────────────
    // Uncomment during session to show ONE generic method
    // replacing all hard-coded fetch functions.
    //
    // func request<T: Codable>(type: EndPointType,
    //                          completionHander: @escaping (Result<T, DataError>) -> Void) {
    //     guard let url = type.url else {
    //         completionHander(.failure(.invalidURL))
    //         return
    //     }
    //
    //     var urlRequest        = URLRequest(url: url)
    //     urlRequest.httpMethod = type.httpMethod?.rawValue ?? "GET"
    //
    //     type.header?.forEach { urlRequest.setValue($1, forHTTPHeaderField: $0) }
    //
    //     URLSession.shared.dataTask(with: urlRequest) { data, response, error in
    //
    //         if let error = error {
    //             completionHander(.failure(.networkError(error)))
    //             return
    //         }
    //         guard let data = data,
    //               let http = response as? HTTPURLResponse else {
    //             completionHander(.failure(.noData))
    //             return
    //         }
    //         guard (200..<300).contains(http.statusCode) else {
    //             completionHander(.failure(.invalidStatusCode(http.statusCode)))
    //             return
    //         }
    //         do {
    //             let decoded = try JSONDecoder().decode(T.self, from: data)
    //             completionHander(.success(decoded))
    //         } catch {
    //             completionHander(.failure(.decodingError(error)))
    //         }
    //     }.resume()
    // }

    // ─────────────────────────────────────────────────────────
    // MARK: WAY 1 ► Hard-coded fetchPost()  [ACTIVE]
    // ─────────────────────────────────────────────────────────
    // Direct, step-by-step method — easy to follow in session.
    // URL: https://jsonplaceholder.typicode.com/posts
    //
    func fetchPost(completion: @escaping (Result<[Post], Error>) -> Void) {

        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!

        URLSession.shared.dataTask(with: url) { data, response, error in

            // Step 1 — Check for network-level error
            if let error = error {
                completion(.failure(error))
                return
            }

            // Step 2 — Unwrap data + validate status code
            guard let data = data,
                  let http = response as? HTTPURLResponse,
                  (200..<300).contains(http.statusCode) else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }

            // Step 3 — Decode JSON → [Post]
            do {
                let posts = try JSONDecoder().decode([Post].self, from: data)
                completion(.success(posts))
            } catch {
                completion(.failure(error))
            }

        }.resume()  // ← always call .resume() or the request never fires!
    }

    // ✅ Protocol conformance stub — keeps the build green while generic impl is commented.
    // During session: delete this stub, uncomment the full implementation above ✂️
    func request<T: Codable>(type: EndPointType, completionHander: @escaping (Result<T, DataError>) -> Void) {
        fatalError("✂️  Uncomment the generic request<T> implementation above during the session")
    }
}
