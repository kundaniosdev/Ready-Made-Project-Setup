//
//  Theme.swift
//  ReadyMadeProjectSetup
//
//  Created by ibarts on 14/08/26.
//

import SwiftUI

// MARK: - App Theme
enum AppTheme {
    // MARK: - Colors
    enum Colors {
        static let primary = Color.blue
        static let secondary = Color.gray
        static let tabPill = Color(red: 254 / 255.0, green: 236 / 255.0, blue: 220 / 255.0)
        static let tabActiveIcon = Color(red: 0.12, green: 0.12, blue: 0.14)
        static let tabInactiveIcon = Color(red: 0.45, green: 0.45, blue: 0.48)
        static let tabDivider = Color(red: 0.90, green: 0.90, blue: 0.92)
    }
    
    // MARK: - Dimensions
    enum Dimensions {
        static let cornerRadius: CGFloat = 12.0
        static let cardPadding: CGFloat = 16.0
        static let tabPillWidth: CGFloat = 52.0
        static let tabPillHeight: CGFloat = 28.0
    }
}
