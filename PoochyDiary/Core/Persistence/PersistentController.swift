//
//  PersistentController.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/1/26.
//

import CoreData

struct PersistentController {
    static let shared = PersistentController()

    static var preview: PersistentController = {
        let result = PersistentController(inMemory: true)
        let viewContext = result.container.viewContext
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "PoochyDiaryCoreData")

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
