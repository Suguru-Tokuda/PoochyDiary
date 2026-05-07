//
//  PoochyDiaryCoreDataManager.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/1/26.
//

import CoreData

protocol PoochyDiaryCoreDataManaging {
    func getPets() throws -> [Pet]
    func getPoopLogs(petId: UUID) throws -> [PoopLog]
    func getPoopLogImages(poopLogId: UUID) throws -> [String]
    func savePet(pet: Pet) throws
    func savePoopLog(poopLog: PoopLog) throws
    func getAllTags() throws -> [Tag]
    func removeTag(tag: Tag) throws
}

enum PoochyDiaryCoreDataError: Error {
    case entityFetchError(Error)
    case entitySaveError(Error)
    case contextNotFound
}

final class PoochyDiaryCoreDataManager: PoochyDiaryCoreDataManaging {
    let context: NSManagedObjectContext
    
    init(
        context: NSManagedObjectContext = PersistentController
            .shared
            .container
            .newBackgroundContext()
    ) {
        self.context = context
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    func saveContext() throws {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                throw error
            }
        }
    }
    
    func getPets() throws -> [Pet] {
        var pets: [Pet] = []
        try context.performAndWait {
            let request: NSFetchRequest<PetEntity> = PetEntity.fetchRequest()
            
            do {
                let results = try context.fetch(request)
                pets = results.compactMap { Pet($0) }
            } catch {
                throw PoochyDiaryCoreDataError.entityFetchError(error)
            }
        }
        
        return pets
    }
    
    func getPoopLogs(petId: UUID) throws -> [PoopLog] {
        var logs: [PoopLog] = []
        
        try context.performAndWait {
            let request: NSFetchRequest<PoopLogEntity> = PoopLogEntity.fetchRequest()
            request.predicate = NSPredicate(format: "petId == %@", petId as CVarArg)
            request.sortDescriptors = [
                NSSortDescriptor(key: "date", ascending: false)
            ]
            
            do {
                let results = try context.fetch(request)
                logs = results.compactMap { (entity: PoopLogEntity) -> PoopLog? in
                    let existingImages = entity.images as? Set<PoopLogImageEntity> ?? []
                    let existingTags = entity.tags as? Set<TagEntity> ?? []

                    return PoopLog(
                        entity,
                        imageFileNames: Array(existingImages)
                            .sorted(by: { $0.sortOrder < $1.sortOrder })
                            .compactMap { $0.fileName },
                        tags: Array(existingTags)
                            .compactMap { Tag($0) }
                            .sorted { $0.name < $1.name }
                    )
                }
            } catch {
                throw PoochyDiaryCoreDataError.entityFetchError(error)
            }
        }
        
        return logs
    }
    
    func getPoopLogImages(poopLogId: UUID) throws -> [String] {
        var imageFileNames: [String] = []
        
        try context.performAndWait {
            let request: NSFetchRequest<PoopLogImageEntity> = PoopLogImageEntity.fetchRequest()
            request.predicate = NSPredicate(format: "poopLog.id == %@", poopLogId as CVarArg)
            request.sortDescriptors = [
                NSSortDescriptor(key: "sortOrder", ascending: true)
            ]
            
            do {
                let results = try context.fetch(request)
                imageFileNames = results.compactMap { $0.fileName }
            } catch {
                throw PoochyDiaryCoreDataError.entityFetchError(error)
            }
        }
        
        return imageFileNames
    }
    
    func savePet(pet: Pet) throws {
        try context.performAndWait {
            do {
                let request: NSFetchRequest<PetEntity> = PetEntity.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", pet.id as CVarArg)
                request.fetchLimit = 1

                let existing = try context.fetch(request).first

                let entity = existing ?? PetEntity(context: context)
                entity.id = pet.id
                entity.name = pet.name
                entity.dateOfBirth = pet.dateOfBirth
                entity.gender = pet.gender.rawValue
                entity.type = pet.type.rawValue

                try saveContext()
            } catch {
                throw PoochyDiaryCoreDataError.entitySaveError(error)
            }
        }
    }
    
    func savePoopLog(poopLog: PoopLog) throws {
        try context.performAndWait {
            do {
                let request: NSFetchRequest<PoopLogEntity> = PoopLogEntity.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", poopLog.id as CVarArg)
                request.fetchLimit = 1

                let existing = try context.fetch(request).first
            
                let entity = existing ?? PoopLogEntity(context: context)
                
                entity.id = poopLog.id
                entity.petId = poopLog.petId
                entity.bloodAmount = poopLog.bloodAmount.rawValue
                entity.mucusLevel = poopLog.mucusLevel.rawValue
                entity.note = poopLog.note
                entity.date = poopLog.date
                entity.stoolType = poopLog.stoolType.rawValue
                let tagEntities = try poopLog.tags.map {
                    try fetchOrCreateTag(tag: $0)
                }
                entity.tags = NSSet(array: tagEntities)

                if let existingImages = entity.images as? Set<PoopLogImageEntity> {
                    existingImages.forEach { context.delete($0) }
                    entity.images = nil
                }

                for (index, fileName) in poopLog.imageFileNames.enumerated() {
                    let imageEntity = PoopLogImageEntity(context: context)
                    imageEntity.id = UUID()
                    imageEntity.fileName = fileName
                    imageEntity.createdAt = Date()
                    imageEntity.sortOrder = Int16(index)
                    imageEntity.poopLog = entity
                }
            
                try saveContext()
            } catch {
                throw PoochyDiaryCoreDataError.entitySaveError(error)
            }
        }
    }

    func getAllTags() throws -> [Tag] {
        var tags: [Tag] = []

        try context.performAndWait {
            let request: NSFetchRequest<TagEntity> = TagEntity.fetchRequest()
            request.sortDescriptors = [
                NSSortDescriptor(key: "name", ascending: true)
            ]
            
            do {
                let results = try context.fetch(request)
                tags = results.compactMap { Tag($0) }
            } catch {
                throw PoochyDiaryCoreDataError.entityFetchError(error)
            }
        }

        return tags
    }

    func removeTag(tag: Tag) throws {
        try context.performAndWait {
            do {
                let request: NSFetchRequest<TagEntity> = TagEntity.fetchRequest()
                request.predicate = NSPredicate(format: "id = %@", tag.id as CVarArg)
                request.fetchLimit = 1

                let results = try context.fetch(request)
                results.forEach { context.delete($0) }

                try saveContext()
            } catch {
                throw PoochyDiaryCoreDataError.entitySaveError(error)
            }
        }
    }

    private func fetchOrCreateTag(tag: Tag) throws -> TagEntity {
        let normalizedName = tag.name
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()

        let request: NSFetchRequest<TagEntity> = TagEntity.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", normalizedName)
        request.fetchLimit = 1
    
        if let existing = try context.fetch(request).first {
            return existing
        }
    
        let entity = TagEntity(context: context)
        entity.id = tag.id
        entity.name = normalizedName

        return entity
    }
}
