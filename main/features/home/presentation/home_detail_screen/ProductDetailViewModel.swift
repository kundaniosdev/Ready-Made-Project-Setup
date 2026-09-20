//
//  ProductDetailViewModel.swift
//  ReadyMadeProjectSetup
//
//  Created by kundan Dev on 20/09/26.
//

import Foundation
import Combine
class ProductDetailViewModel: ObservableObject {
    
    init(){
        debugPrint("🟢[ARC] ProductDetailViewModel ALLOCATED")
    }
    deinit {
        debugPrint("🔴[ARC] ProductDetailViewModel DEALLOCATED")
    }
    
}
