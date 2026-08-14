//
//  MockEnvronobjectServices.swift
//  FrameInvaders
//
//  Created by ibarts on 12/05/26.
//


import Foundation

final class MockEnvironmentServices {

    static let shared = MockEnvironmentServices()

    let bluetoothManager = BluetoothManager()
    let userViewModel = UserViewModel()
    let viewRouter = ViewRouter()
    let currentStationVM = CurrentStationVM()
    let networkMonitor = NetworkMonitor()
    let menuRouter: MenuRouter = MenuRouter()
    let cuttingSawsVM = CuttingStationSawsVM()
    let routingStationVM = RoutingStationVM()

    private init() { }
}
