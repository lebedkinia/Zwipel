//
//  ClipboardItem.swift
//  Zwipel
//
//  Created by Ivan on 06.06.2025.
//

import Foundation

struct ClipboardItem: Identifiable, Equatable {
    let id = UUID()
    let content: String
    let createdAt: Date
    var isPinned: Bool = false
}
