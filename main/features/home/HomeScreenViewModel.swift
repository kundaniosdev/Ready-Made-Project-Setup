//
//  HomeScreenViewModel.swift
//  PaginationInSwiftUI
//
//  Created by ibarts on 14/08/26.
//

import Foundation
import SwiftUI

class HomeScreenViewModel: ObservableObject {
    
    init() {
        print("🟢[ARC] HomeScreenViewModel  ALLOCATED")
    }
    
    deinit {
        print("🔴[ARC] HomeScreenViewModel  DEALLOCATED")
    }
}
