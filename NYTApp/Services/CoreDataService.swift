//
//  CoreDataService.swift
//  NYTApp
//
//  Created by Denis Kobylkov on 19.05.2023.
//

import Foundation
import CoreData

enum CoreDataError: Error {
    case unknown
}

final class CoreDataService {
    
    static let shared = CoreDataService()
    let modelName: String
    let objectModel: NSManagedObjectModel
    let persistentStoreCoordinator: NSPersistentStoreCoordinator
    
    // 4. Context
     lazy var context: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistentStoreCoordinator
        return context
    }()
    
    init() {
        
        // 1. NSManagedObjectModel
        guard let url = Bundle.main.url(forResource: "NYTApp", withExtension: "momd") else {
            fatalError("There is no xcdatamodeld file.")
        }
        
        let path = url.pathExtension // NYTApp.momd
        guard let name = try? url.lastPathComponent.replace(path, replacement: "") else {
            fatalError()
        }
        self.modelName = name
        
        guard let model = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Can't create NSManagedObjectModel")
        }
        self.objectModel = model
        
        // 2. NSPersistentStoreCoordinator
        self.persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.objectModel)
        
        // 3. NSPersistantStore
        let storeName = name + "sqlite"
        let documentsDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let persistantStoreUrl = documentsDirectoryUrl?.appendingPathExtension(storeName)
        print("✅", persistantStoreUrl)
        
        guard let persistantStoreUrl = persistantStoreUrl else {
            return
        }
        
        let options = [NSMigratePersistentStoresAutomaticallyOption: true]
        do {
            try self.persistentStoreCoordinator.addPersistentStore(
                type: .sqlite,
                at: persistantStoreUrl,
                options: options
            )
        } catch {
            fatalError("Can't create NSPersistantStore")
        }
    }
    //MARK: Create a Cell
    func createCard(_ new: New) -> Result<Void, CoreDataError> {
        let StoredCells = StoredCells(context: self.context)
        

        StoredCells.title = new.title
        if new.media?.isEmpty == false {
            StoredCells.image = new.media![0].mediaMetadata![1].url
        } else {
            StoredCells.image = ""
        }
        StoredCells.byline = new.byline
        StoredCells.nytdsection = new.nytdsection
        StoredCells.publishedDate = new.publishedDate
        StoredCells.section = new.section
        
        
        guard self.context.hasChanges else {
            return .failure(.unknown)
        }
        
        do {
            try self.context.save()
            return .success(())
        } catch {
            return .failure(.unknown)
        }
    }
    //MARK: Deleting cells
    func deleteCell(_ cell: StoredCells) -> Result<Void, CoreDataError>{
        
        context.delete(cell)
        
        
        guard self.context.hasChanges else {
            return .failure(.unknown)
        }
        
        do {
            try self.context.save()
            return .success(())
        } catch {
            return .failure(.unknown)
        }

    }
    
    //MARK: GET A CELL
    func fetchCell(predicate: NSPredicate? = nil) -> Result<[StoredCells], CoreDataError> {
        let fetchRequest = StoredCells.fetchRequest()
        fetchRequest.predicate = predicate
        
        do {
            let StoredCells = try self.context.fetch(fetchRequest)
            return .success(StoredCells)
        } catch {
            return .failure(.unknown)
        }
    }

}
