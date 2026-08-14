//
//  GetTicketsUseCase.swift
//  PaginationInSwiftUI
//
//  Created by ibarts on 14/08/26.
//

import Foundation
// use_cases/GetTicketsUseCase.swift
import Foundation
import Combine

protocol GetTicketsUseCase {
    func execute(page: Int, limit: Int) -> AnyPublisher<[Ticket], Error>
}

class GetTicketsUseCaseImpl: GetTicketsUseCase {
    private let repository: TicketRepository
    
    init(repository: TicketRepository = TicketRepositoryImpl()) {
        self.repository = repository
    }
    
    func execute(page: Int = 1, limit: Int = 10) -> AnyPublisher<[Ticket], Error> {
        return repository.fetchTickets(page: page, limit: limit)
    }
}
