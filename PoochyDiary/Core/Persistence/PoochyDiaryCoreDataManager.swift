//
//  PoochyDiaryCoreDataManager.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/1/26.
//

import CoreData

protocol PoochyDiaryCoreDataManaging {
    func getPets() async throws -> [Pet]
    func removePet(pet: Pet) async throws
    func getDiaries(petId: UUID) async throws -> [Diary]
    func getDiaryImages(diaryId: UUID) async throws -> [String]
    func savePet(pet: Pet) throws
    func saveDiary(diary: Diary) async throws
    func removeDiary(diary: Diary) async throws
    func removeDiaries(petId: UUID) async throws
    func getAllTags() throws -> [Tag]
    func removeTag(tag: Tag) throws
}

enum PoochyDiaryCoreDataError: Error {
    case entityFetchError(Error)
    case entitySaveError(Error)
    case contextNotFound
}

final class PoochyDiaryCoreDataManager: PoochyDiaryCoreDataManaging {
    private let persistentController: PersistentController
    private var context: NSManagedObjectContext {
        persistentController.container.viewContext
    }

    init(
        persistentController: PersistentController = .shared
    ) {
        self.persistentController = persistentController
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

    func getPets() async throws -> [Pet] {
        let context = context
        return try await context.perform {
            let request: NSFetchRequest<PetEntity> = PetEntity.fetchRequest()

            do {
                let results = try context.fetch(request)
                return results.compactMap { Pet($0) }
            } catch {
                throw PoochyDiaryCoreDataError.entityFetchError(error)
            }
        }
    }

    func removePet(pet: Pet) async throws {
        try await context.perform { [weak self] in
            guard let self else { return }

            do {
                // Wipe out all the diaries before removing the pet.
                try removeDiaries(petId: pet.id, context: context)

                let request: NSFetchRequest<PetEntity> = PetEntity.fetchRequest()
                request.predicate = NSPredicate(format: "id = %@", pet.id as CVarArg)
                request.fetchLimit = 1

                if let petEntity = try context.fetch(request).first {
                    context.delete(petEntity)
                }

                try saveContext()
            }
        }
    }

    func getDiaries(petId: UUID) async throws -> [Diary] {
        let context = context
        return try await context.perform {
            let request: NSFetchRequest<DiaryEntity> = DiaryEntity.fetchRequest()
            request.predicate = NSPredicate(format: "petId == %@", petId as CVarArg)
            request.sortDescriptors = [
                NSSortDescriptor(key: "date", ascending: false)
            ]

            do {
                let results = try context.fetch(request)
                return results.compactMap { (entity: DiaryEntity) -> Diary? in
                    self.makeDiary(from: entity)
                }
            } catch {
                throw PoochyDiaryCoreDataError.entityFetchError(error)
            }
        }
    }

    func removeDiary(diary: Diary) async throws {
        try await context.perform { [weak self] in
            guard let self else { return }

            do {
                let request: NSFetchRequest<DiaryEntity> = DiaryEntity.fetchRequest()
                request.predicate = NSPredicate(format: "id = %@", diary.id as CVarArg)
                request.fetchLimit = 1

                if let diaryEntity = try context.fetch(request).first {
                    context.delete(diaryEntity)
                    try saveContext()
                }
            }
        }
    }

    func removeDiaries(petId: UUID) async throws {
        let context = context
        try await context.perform { [weak self] in
            guard let self else { return }

            do {
                let request: NSFetchRequest<DiaryEntity> = DiaryEntity.fetchRequest()
                request.predicate = NSPredicate(format: "petId = %@", petId as CVarArg)

                let diaryEntities = try context.fetch(request)
                diaryEntities.forEach { context.delete($0) }

                try saveContext()
            }
        }
    }

    func getDiaryImages(diaryId: UUID) async throws -> [String] {
        let context = context
        return try await context.perform {
            let request: NSFetchRequest<DiaryPhotoEntity> = DiaryPhotoEntity.fetchRequest()
            request.predicate = NSPredicate(format: "diary.id == %@", diaryId as CVarArg)
            request.sortDescriptors = [
                NSSortDescriptor(key: "sortOrder", ascending: true)
            ]

            do {
                let results = try context.fetch(request)
                return results.compactMap { $0.fileName }
            } catch {
                throw PoochyDiaryCoreDataError.entityFetchError(error)
            }
        }
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

    func saveDiary(diary: Diary) async throws {
        let context = context
        try await context.perform { [weak self] in
            guard let self else { return }

            do {
                let request: NSFetchRequest<DiaryEntity> = DiaryEntity.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", diary.id as CVarArg)
                request.fetchLimit = 1

                let existing = try context.fetch(request).first

                let entity = existing ?? DiaryEntity(context: context)

                entity.id = diary.id
                entity.petId = diary.petId
                entity.bloodAmount = diary.bloodAmount.rawValue
                entity.mucusLevel = diary.mucusLevel.rawValue
                entity.note = diary.notes
                entity.date = diary.date
                entity.stoolType = diary.stoolType.rawValue
                let tagEntities = try diary.tags.map {
                    try self.fetchOrCreateTag(tag: $0)
                }
                entity.tags = NSSet(array: tagEntities)

                if let existingImages = entity.photos as? Set<DiaryPhotoEntity> {
                    existingImages.forEach { context.delete($0) }
                    entity.photos = nil
                }

                entity.photos = NSSet(
                    array: diary.photos.enumerated().map { (index, photo) in
                        let imageEntity = DiaryPhotoEntity(context: context)
                        imageEntity.id = photo.id
                        imageEntity.fileName = photo.fileName
                        imageEntity.createdAt = Date()
                        imageEntity.sortOrder = Int16(index)
                        imageEntity.diary = entity
                        return imageEntity
                    })

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
                tags = results.compactMap { makeTag(from: $0) }
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

    private func makeTag(from entity: TagEntity) -> Tag? {
        guard let id = entity.id,
            let name = entity.name
        else { return nil }

        return Tag(id: id, name: name)
    }

    private func makeDiary(from entity: DiaryEntity) -> Diary? {
        guard let id = entity.id,
            let petId = entity.petId,
            let date = entity.date,
            let stoolTypeStr = entity.stoolType,
            let stoolType = StoolType(rawValue: stoolTypeStr),
            let mucusLevelStr = entity.mucusLevel,
            let mucusLevel = MucusLevel(rawValue: mucusLevelStr),
            let bloodAmountStr = entity.bloodAmount,
            let bloodAmount = BloodAmount(rawValue: bloodAmountStr)
        else { return nil }

        let photoEntities = Array(entity.photos as? Set<DiaryPhotoEntity> ?? [])
        let tagEntities = Array(entity.tags as? Set<TagEntity> ?? [])

        return Diary(
            id: id,
            petId: petId,
            date: date,
            stoolType: stoolType,
            mucusLevel: mucusLevel,
            bloodAmount: bloodAmount,
            note: entity.note,
            photos: photoEntities.compactMap { makePhoto(form: $0) }.sorted(by: {
                $0.sortOrder < $1.sortOrder
            }),
            tags: tagEntities.compactMap { makeTag(from: $0) }.sorted(by: { $0.name < $1.name }))
    }

    private func makePhoto(form entity: DiaryPhotoEntity) -> Photo? {
        guard let id = entity.id,
            let fileName = entity.fileName,
            let createdAt = entity.createdAt
        else {
            return nil
        }
        let sortOrder = entity.sortOrder
        return Photo(
            id: id,
            fileName: fileName,
            createdAt: createdAt,
            sortOrder: Int(sortOrder)
        )
    }

    private func removeDiaries(
        petId: UUID,
        context: NSManagedObjectContext
    ) throws {
        let request: NSFetchRequest<DiaryEntity> = DiaryEntity.fetchRequest()
        request.predicate = NSPredicate(format: "petId == %@", petId as CVarArg)

        let diaryEntities = try context.fetch(request)

        diaryEntities.forEach {
            context.delete($0)
        }
    }
}
