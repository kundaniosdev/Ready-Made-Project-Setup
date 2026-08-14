//
//  HomeRepositoryImp.swift
//  PaginationInSwiftUI
//
//  Created by ibarts on 14/08/26.
//

import Foundation
// Repositories/TicketRepositoryImpl.swift
import Foundation
import Combine

class TicketRepositoryImpl: TicketRepository {
    private let apiService: TicketAPIService
    
    init(apiService: TicketAPIService = TicketAPIService()) {
        self.apiService = apiService
    }
    
    func fetchTickets(page: Int = 1, limit: Int = 10) -> AnyPublisher<[Ticket], Error> {
        return apiService.fetchTickets(page: page, limit: limit)
            .tryMap { response in
                try response.data.docs.map { try $0.toDomain() }
            }
            .eraseToAnyPublisher()
    }
    
    func fetchTicket(byId id: String) -> AnyPublisher<Ticket, Error> {
        return apiService.fetchTicket(byId: id)
            .tryMap { dto in
                try dto.toDomain()
            }
            .eraseToAnyPublisher()
    }
    
    func updateTicketStatus(ticketId: String, status: TicketStatus) -> AnyPublisher<Ticket, Error> {
        return apiService.updateTicketStatus(ticketId: ticketId, status: status.rawValue)
            .tryMap { dto in
                try dto.toDomain()
            }
            .eraseToAnyPublisher()
    }
}
