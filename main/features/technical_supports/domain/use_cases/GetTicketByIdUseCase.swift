//
//  GetTicketByIdUseCase.swift
//  PaginationInSwiftUI
//
//  Created by ibarts on 14/08/26.
//

import Foundation

// UseCases/GetTicketByIdUseCase.swift
import Foundation
import Combine

protocol GetTicketByIdUseCase {
    func execute(id: String) -> AnyPublisher<Ticket, Error>
}

class GetTicketByIdUseCaseImpl: GetTicketByIdUseCase {
    private let repository: TicketRepository
    
    init(repository: TicketRepository = TicketRepositoryImpl()) {
        self.repository = repository
    }
    
    func execute(id: String) -> AnyPublisher<Ticket, Error> {
        return repository.fetchTicket(byId: id)
    }
}


