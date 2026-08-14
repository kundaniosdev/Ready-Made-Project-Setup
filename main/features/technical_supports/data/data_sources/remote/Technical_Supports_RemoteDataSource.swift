//
//  HomeRemoteDataSource.swift
//  PaginationInSwiftUI
//
//  Created by ibarts on 14/08/26.
//

import Foundation
// remote/Technical_Supports_RemoteDataSource.swift
import Foundation
import Combine

class TicketAPIService {
    private let baseURL = "https://api.example.com"
    private let session = URLSession.shared
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    func fetchTickets(page: Int, limit: Int) -> AnyPublisher<TicketResponseDTO, Error> {
        guard let url = URL(string: "\(baseURL)/tickets?page=\(page)&limit=\(limit)") else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: TicketResponseDTO.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    func fetchTicket(byId id: String) -> AnyPublisher<TicketDTO, Error> {
        guard let url = URL(string: "\(baseURL)/tickets/\(id)") else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: TicketDTO.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    func updateTicketStatus(ticketId: String, status: String) -> AnyPublisher<TicketDTO, Error> {
        guard let url = URL(string: "\(baseURL)/tickets/\(ticketId)/status") else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["status": status]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        return session.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: TicketDTO.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
}
