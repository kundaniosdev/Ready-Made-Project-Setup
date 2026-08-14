//
//  TicketResponse_dto.swift
//  PaginationInSwiftUI
//
//  Created by ibarts on 14/08/26.
//

import Foundation
// dtos/Ticket_Response_DTO.swift
import Foundation

struct TicketResponseDTO: Decodable {
    let success: Bool
    let message: String
    let data: TicketDataDTO
}

struct TicketDataDTO: Decodable {
    let docs: [TicketDTO]
    let total: Int
    let page: Int
    let limit: Int
    let totalPages: Int
}

struct TicketDTO: Decodable {
    let id: String
    let ticketId: String
    let platform: String
    let priority: String
    let status: String
    let createdAt: String
    let timeline: [TimelineEventDTO]
}

struct TimelineEventDTO: Decodable {
    let id: String
    let ticket: String
    let eventType: String
    let previousValue: String?
    let newValue: String?
    let performedBy: String?
    let comment: String
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case ticket
        case eventType
        case previousValue
        case newValue
        case performedBy
        case comment
        case createdAt
        case updatedAt
    }
}
