//
//  EndPointType.swift
//  FrameInvaders
//
//  Created by ibarts on 08/07/26.
//

import Foundation


enum HTTPMethods: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol EndPointType {
    var baseURL: String { get }
    var path: String { get }
    var url: URL? { get }
    var httpMethod: HTTPMethods? { get }
    var httpBody: Encodable? { get }
    var header: [String: String]? { get }
    var mockFileName: String { get }
}
