//
//  detailsViewModel.swift
//  PaginationInSwiftUI
//
//  Created by ibarts on 14/08/26.
//

import Foundation
import SwiftUI

// ViewModels/TicketDetailViewModel.swift
import Foundation
import Combine

class TicketDetailViewModel: ObservableObject {
    @Published var ticket: Ticket?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let getTicketByIdUseCase: GetTicketByIdUseCase
    private let updateStatusUseCase: UpdateTicketStatusUseCase
    private var cancellables = Set<AnyCancellable>()
    
    init(
        getTicketByIdUseCase: GetTicketByIdUseCase = GetTicketByIdUseCaseImpl(),
        updateStatusUseCase: UpdateTicketStatusUseCase = UpdateTicketStatusUseCaseImpl()
    ) {
        self.getTicketByIdUseCase = getTicketByIdUseCase
        self.updateStatusUseCase = updateStatusUseCase
        print("🟢[ARC] DetailsViewModel  ALLOCATED")
    }
    
 
    
    deinit {
        print("🔴[ARC] DetailsViewModel  DEALLOCATED")
    }
    
    func loadTicket(id: String) {
        isLoading = true
        errorMessage = nil
        
        getTicketByIdUseCase.execute(id: id)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] ticket in
                self?.ticket = ticket
            }
            .store(in: &cancellables)
    }
    
    func updateStatus(_ status: TicketStatus) {
        guard let ticketId = ticket?.id else { return }
        
        isLoading = true
        
        updateStatusUseCase.execute(ticketId: ticketId, status: status)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] updatedTicket in
                self?.ticket = updatedTicket
            }
            .store(in: &cancellables)
    }
}
