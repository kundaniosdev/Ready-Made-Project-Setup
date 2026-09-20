//
//  ProductDetailView.swift
//  ReadyMadeProjectSetup
//
//  Created by kundan Dev on 20/09/26.
//

import Foundation
import SwiftUI
struct ProductDetailView:View {
    @StateObject private var productDetailViewModel: ProductDetailViewModel = ProductDetailViewModel()
    
    var body: some View {
        VStack {
            Text("Hello, this is detail View.")
        }
    }
}


// Preview
#Preview {
    ProductDetailView()
}
