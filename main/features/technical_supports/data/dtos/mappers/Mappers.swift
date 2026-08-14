//
//  Mappers.swift
//  PaginationInSwiftUI
//
//  Created by ibarts on 14/08/26.
//

import Foundation
// Mappers/TicketMapper.swift
import Foundation

enum MappingError: Error {
    case invalidPlatform
    case invalidPriority
    case invalidStatus
    case invalidEventType
    case invalidDate
}

protocol Mappable {
    associatedtype DomainType
    func toDomain() throws -> DomainType
}

extension TicketDTO: Mappable {
    func toDomain() throws -> Ticket {
        guard let platform = Platform(rawValue: self.platform) ?? .unknown else {
            throw MappingError.invalidPlatform
        }
        guard let priority = Priority(rawValue: self.priority) else {
            throw MappingError.invalidPriority
        }
        guard let status = TicketStatus(rawValue: self.status) else {
            throw MappingError.invalidStatus
        }
        guard let createdAt = ISO8601DateFormatter().date(from: self.createdAt) else {
            throw MappingError.invalidDate
        }
        
        let timelineEvents = try self.timeline.map { try $0.toDomain() }
        
        return Ticket(
            id: self.id,
            ticketId: self.ticketId,
            platform: platform,
            priority: priority,
            status: status,
            createdAt: createdAt,
            timeline: timelineEvents
        )
    }
}

extension TimelineEventDTO: Mappable {
    func toDomain() throws -> TimelineEvent {
        guard let eventType = EventType(rawValue: self.eventType) ?? .unknown else {
            throw MappingError.invalidEventType
        }
        guard let createdAt = ISO8601DateFormatter().date(from: self.createdAt) else {
            throw MappingError.invalidDate
        }
        guard let updatedAt = ISO8601DateFormatter().date(from: self.updatedAt) else {
            throw MappingError.invalidDate
        }
        
        return TimelineEvent(
            id: self.id,
            ticketId: self.ticket,
            eventType: eventType,
            previousValue: self.previousValue,
            newValue: self.newValue,
            performedBy: self.performedBy,
            comment: self.comment,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
