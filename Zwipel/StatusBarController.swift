//
//  StatusBarController.swift
//  Zwipel2
//
//  Created by Ivan on 21.05.2025.
//


import SwiftUI
import AppKit

class StatusBarController: NSObject {
    var statusBar: NSStatusItem
    var popover: NSPopover
    var eventMonitor: Any?
    
    init(_ popover: NSPopover) {
        self.popover = popover
        statusBar = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        super.init()
        
        if let statusBarButton = statusBar.button {
            statusBarButton.image = NSImage(systemSymbolName: "list.clipboard", accessibilityDescription: nil)
            statusBarButton.action = #selector(togglePopover(sender:))
            statusBarButton.target = self
        }
    }
    
    @objc func togglePopover(sender: AnyObject) {
        if popover.isShown {
            closePopover(sender)
        } else {
            showPopover(sender)
        }
    }
    
    func showPopover(_ sender: AnyObject) {
        guard let statusBarButton = statusBar.button else { return }
        
        popover.show(relativeTo: statusBarButton.bounds, of: statusBarButton, preferredEdge: .maxY)
        
        eventMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
            if let strongSelf = self, strongSelf.popover.isShown {
                strongSelf.closePopover(sender)
            }
        }
    }
    
    func closePopover(_ sender: AnyObject) {
        popover.performClose(sender)
        
        if let monitor = eventMonitor {
            NSEvent.removeMonitor(monitor)
            eventMonitor = nil
        }
    }
}
