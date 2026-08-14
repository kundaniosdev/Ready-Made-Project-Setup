//
//  TicketListViewModel.swift
//  PaginationInSwiftUI
//
//  Created by ibarts on 14/08/26.
//

import Foundation
// ViewModels/TicketListViewModel.swift
import Foundation
import Combine

class TicketListViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var tickets: [Ticket] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedTicket: Ticket?
    
    // MARK: - Private Properties
    private let getTicketsUseCase: GetTicketsUseCase
    private let updateStatusUseCase: UpdateTicketStatusUseCase
    private var cancellables = Set<AnyCancellable>()
    private var currentPage = 1
    private var hasMorePages = true
    
    // MARK: - Initialization
    init(
        getTicketsUseCase: GetTicketsUseCase = GetTicketsUseCaseImpl(),
        updateStatusUseCase: UpdateTicketStatusUseCase = UpdateTicketStatusUseCaseImpl()
    ) {
        self.getTicketsUseCase = getTicketsUseCase
        self.updateStatusUseCase = updateStatusUseCase
    }
    
    // MARK: - Public Methods
    func loadTickets() {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        
        getTicketsUseCase.execute(page: currentPage, limit: 10)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] tickets in
                if self?.currentPage == 1 {
                    self?.tickets = tickets
                } else {
                    self?.tickets.append(contentsOf: tickets)
                }
                self?.hasMorePages = tickets.count == 10
                if tickets.count < 10 {
                    self?.hasMorePages = false
                }
            }
            .store(in: &cancellables)
    }
    
    func loadMoreTickets() {
        guard !isLoading && hasMorePages else { return }
        currentPage += 1
        loadTickets()
    }
    
    func refreshTickets() {
        currentPage = 1
        hasMorePages = true
        loadTickets()
    }
    
    func updateTicketStatus(ticketId: String, status: TicketStatus) {
        isLoading = true
        
        updateStatusUseCase.execute(ticketId: ticketId, status: status)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] updatedTicket in
                if let index = self?.tickets.firstIndex(where: { $0.id == updatedTicket.id }) {
                    self?.tickets[index] = updatedTicket
                }
            }
            .store(in: &cancellables)
    }
    
    func selectTicket(_ ticket: Ticket) {
        selectedTicket = ticket
    }
    
    func clearError() {
        errorMessage = nil
    }
}

