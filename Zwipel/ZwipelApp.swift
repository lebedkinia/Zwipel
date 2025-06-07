//
//  Zwipel2App.swift
//  Zwipel2
//
//  Created by Ivan on 21.05.2025.
//

import SwiftUI

@main
struct ZwipelApp: App {
    @StateObject private var clipboardManager = ClipboardManager()

    var body: some Scene {
        MenuBarExtra("Zwipel", systemImage: "doc.on.clipboard") {
            ContentView()
                .environmentObject(clipboardManager)
                .frame(width: 350, height: 400)
        }
        .menuBarExtraStyle(.window)
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var popover = NSPopover()
    var statusBarController: StatusBarController?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        let contentView = ContentView()
        
        popover.contentSize = NSSize(width: 200, height: 385)
        popover.contentViewController = NSHostingController(rootView: contentView)
        
        statusBarController = StatusBarController(popover)
    }
}

class AppState: ObservableObject {
}
