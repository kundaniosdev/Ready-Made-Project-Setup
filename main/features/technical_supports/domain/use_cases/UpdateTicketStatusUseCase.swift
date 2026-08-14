//
//  UpdateTicketStatusUseCase.swift
//  PaginationInSwiftUI
//
//  Created by ibarts on 14/08/26.
//

import Foundation
// UseCases/UpdateTicketStatusUseCase.swift
import Foundation
import Combine

protocol UpdateTicketStatusUseCase {
    func execute(ticketId: String, status: TicketStatus) -> AnyPublisher<Ticket, Error>
}

class UpdateTicketStatusUseCaseImpl: UpdateTicketStatusUseCase {
    private let repository: TicketRepository
    
    init(repository: TicketRepository = TicketRepositoryImpl()) {
        self.repository = repository
    }
    
    func execute(ticketId: String, status: TicketStatus) -> AnyPublisher<Ticket, Error> {
        return repository.updateTicketStatus(ticketId: ticketId, status: status)
    }
}
