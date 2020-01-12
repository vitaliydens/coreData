//
//  CoreDataStack.swift
//  CoreDataEasy
//
//  Created by Oleksandr on 17.12.2019.
//  Copyright © 2019 Oleksandr. All rights reserved.
//

import CoreData


class CoreDataStack {

    static let shared = CoreDataStack()

    private init() { }

    private(set) lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PuhliyVitaliy_CoreData")
        container.loadPersistentStores(completionHandler: { (persistentStoreDescription, error) in
            if let error = error {
                debugPrint(error)
                return
            }
             debugPrint(persistentStoreDescription)
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        })
        return container
    }()
}
