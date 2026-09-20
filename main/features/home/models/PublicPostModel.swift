//
//  PublicPostModel.swift
//  ReadyMadeProjectSetup
//
//  Created by kundan Dev on 20/09/26.
//

import Foundation

struct Post: Codable, Hashable {
    let userId: Int?
    let id: Int?
    let title: String?
    let body: String?
}
