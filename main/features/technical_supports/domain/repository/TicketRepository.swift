//
//  res.swift
//  PaginationInSwiftUI
//
//  Created by ibarts on 14/08/26.
//

import Foundation
// Repositories/TicketRepository.swift
import Foundation
import Combine

protocol TicketRepository {
    func fetchTickets(page: Int, limit: Int) -> AnyPublisher<[Ticket], Error>
    func fetchTicket(byId id: String) -> AnyPublisher<Ticket, Error>
    func updateTicketStatus(ticketId: String, status: TicketStatus) -> AnyPublisher<Ticket, Error>
}

