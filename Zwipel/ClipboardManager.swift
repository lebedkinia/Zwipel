//
//  ClipboardManager.swift
//  Zwipel
//
//  Created by Ivan on 06.06.2025.
//

import AppKit
import Combine

class ClipboardManager: ObservableObject {

    @Published var history: [ClipboardItem] = []
    @Published var searchText: String = ""

    private var timer: Timer?
    private var lastChangeCount: Int

    var filteredAndSortedHistory: [ClipboardItem] {
        let filtered: [ClipboardItem]
        if searchText.isEmpty {
            filtered = history
        } else {
            filtered = history.filter { $0.content.localizedCaseInsensitiveContains(searchText) }
        }

        return filtered.sorted {
            if $0.isPinned && !$1.isPinned {
                return true
            }
            if $0.isPinned == $1.isPinned {
                return $0.createdAt > $1.createdAt
            }
            return false
        }
    }

    init() {
        self.lastChangeCount = NSPasteboard.general.changeCount
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.checkForChanges()
        }
    }

    private func checkForChanges() {
        if NSPasteboard.general.changeCount != lastChangeCount {
            lastChangeCount = NSPasteboard.general.changeCount

            if let newText = NSPasteboard.general.string(forType: .string) {
                if !history.contains(where: { $0.content == newText }) {
                    let newItem = ClipboardItem(content: newText, createdAt: Date())
                    DispatchQueue.main.async {
                        self.history.insert(newItem, at: 0)
                    }
                }
            }
        }
    }

    func copyToClipboard(item: ClipboardItem) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(item.content, forType: .string)
    }

    func deleteItem(item: ClipboardItem) {
        history.removeAll { $0.id == item.id }
    }

    func togglePin(for item: ClipboardItem) {
        guard let index = history.firstIndex(where: { $0.id == item.id }) else { return }
        history[index].isPinned.toggle()
    }
}
