//
//  Tickets.swift
//  PaginationInSwiftUI
//
//  Created by ibarts on 14/08/26.
//

import Foundation
// domain/entities/Ticket.swift
import Foundation

struct Ticket {
    let id: String
    let ticketId: String
    let platform: Platform
    let priority: Priority
    let status: TicketStatus
    let createdAt: Date
    let timeline: [TimelineEvent]
    
    // Domain business logic
    var isOpen: Bool {
        status == .open
    }
    
    var isHighPriority: Bool {
        priority == .high || priority == .critical
    }
    
    func getRecentTimelineEvents(limit: Int = 5) -> [TimelineEvent] {
        Array(timeline.sorted { $0.createdAt > $1.createdAt }.prefix(limit))
    }
    
    var hasMediaUploaded: Bool {
        timeline.contains { $0.eventType == .mediaUploaded }
    }
}

// Domain/Entities/TimelineEvent.swift
import Foundation

struct TimelineEvent {
    let id: String
    let ticketId: String
    let eventType: EventType
    let previousValue: String?
    let newValue: String?
    let performedBy: String?
    let comment: String
    let createdAt: Date
    let updatedAt: Date
    
    var isCreationEvent: Bool {
        eventType == .created
    }
    
    var isMediaUploadEvent: Bool {
        eventType == .mediaUploaded
    }
}

// Domain/Enums/TicketEnums.swift
import Foundation

enum Platform: String {
    case ios = "IOS"
    case android = "ANDROID"
    case web = "WEB"
    case desktop = "DESKTOP"
    case unknown = "UNKNOWN"
}

enum Priority: String {
    case low = "LOW"
    case medium = "MEDIUM"
    case high = "HIGH"
    case critical = "CRITICAL"
}

enum TicketStatus: String {
    case open = "OPEN"
    case inProgress = "IN_PROGRESS"
    case resolved = "RESOLVED"
    case closed = "CLOSED"
    case reopened = "REOPENED"
}

enum EventType: String {
    case created = "CREATED"
    case statusChanged = "STATUS_CHANGED"
    case priorityChanged = "PRIORITY_CHANGED"
    case assigned = "ASSIGNED"
    case commented = "COMMENTED"
    case mediaUploaded = "MEDIA_UPLOADED"
    case resolved = "RESOLVED"
    case closed = "CLOSED"
    case unknown = "UNKNOWN"
}
