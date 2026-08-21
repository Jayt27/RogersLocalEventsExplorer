//
//  RogersLocalEventsExplorerApp.swift
//  RogersLocalEventsExplorer
//
//  Created by Jay Thakkar on 20/08/26.
//

import SwiftUI

@main
struct LocalEventsExplorerApp: App {

    // BGTaskScheduler.register(...) must run before didFinishLaunchingWithOptions from AppDelegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            EventsListView()
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .background {
                BackgroundRefreshManager.shared.scheduleAppRefresh()
            }
        }
    }
}
