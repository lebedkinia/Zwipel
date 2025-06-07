//
//  ClipboardEntry.swift
//  Zwipel
//
//  Created by Ivan on 22.05.2025.
//

import CoreData

@objc(ClipboardEntry)
public class ClipboardEntry: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var content: String
    @NSManaged public var timestamp: Date
    @NSManaged public var isEnabled: Bool
    @NSManaged public var sourceApp: String
}
