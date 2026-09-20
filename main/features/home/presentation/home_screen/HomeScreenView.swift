//
//  HomeScreenView.swift
//  PaginationInSwiftUI
//
//  Created by ibarts on 14/08/26.
//

import Foundation
import SwiftUI

struct HomeScreenView : View {
    @StateObject private var homeRouter = Router<HomeNavRouter>()
    var body: some View {
        NavigationStack(path: $homeRouter.navPaths) {
            VStack{
                Text("Hello, Home Screen!")
            }
            .navigationDestination(for: HomeNavRouter.self) { destination in
                destination.destinationView
            }
            .navigationTitle("Home")
        }
     
    }
}
