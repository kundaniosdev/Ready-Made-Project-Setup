//
//  HomeNavRouter.swift
//  ReadyMadeProjectSetup
//
//  Created by kundan Dev on 20/09/26.
//

import Foundation
import SwiftUI

enum HomeNavRouter: NavigationDestination {
  
    case product_deatail
    
    var title: String {
        switch self {
        case .product_deatail:
            return "Product Details"
        }
    }
    
    
    
    var destinationView: some View {
        switch self {
        case .product_deatail:
            ProductDetailView()
        }
    }
}
