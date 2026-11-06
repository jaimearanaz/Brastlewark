import Foundation
import SwiftData

protocol CharactersCacheProtocol: Sendable {
    func get() async -> [CharacterEntity]?
    func save(_ characters: [CharacterEntity]) async
    func isValid() async -> Bool
    func clearCache() async
}

@ModelActor
final actor PersistentCharactersCache: CharactersCacheProtocol {
    private var cacheValidity: TimeInterval = 10
    private var timestamp: Date? {
        get { UserDefaults.standard.object(forKey: "characters_cache_timestamp") as? Date }
        set { UserDefaults.standard.set(newValue, forKey: "characters_cache_timestamp") }
    }

    init?(cacheValidityInSeconds: TimeInterval = 10, modelContainer: ModelContainer? = nil) {
        self.cacheValidity = cacheValidityInSeconds
        let container: ModelContainer
        if let modelContainer = modelContainer {
            container = modelContainer
        } else {
            do {
                container = try ModelContainer(for: CharacterModel.self)
            } catch {
                return nil
            }
        }
        self.modelContainer = container
        let modelContext = ModelContext(container)
        self.modelExecutor = DefaultSerialModelExecutor(modelContext: modelContext)
    }

    func get() async -> [CharacterEntity]? {
        let fetchDescriptor = FetchDescriptor<CharacterModel>()
        guard let persistentCharacters = try? modelContext.fetch(fetchDescriptor), !persistentCharacters.isEmpty else {
            return nil
        }
        return persistentCharacters.map { $0.toCharacterEntity() }
    }

    func save(_ characters: [CharacterEntity]) async {
        guard replaceCachedCharacters(with: characters) else { return }
        timestamp = Date()
    }

    func isValid() async -> Bool {
        guard let timestamp = timestamp,
              Date().timeIntervalSince(timestamp) < cacheValidity else {
            return false
        }
        let fetchDescriptor = FetchDescriptor<CharacterModel>()
        guard let persistentCharacters = try? modelContext.fetch(fetchDescriptor) else {
            return false
        }
        return !persistentCharacters.isEmpty
    }

    func clearCache() async {
        guard replaceCachedCharacters(with: []) else { return }
        timestamp = nil
    }

    private func replaceCachedCharacters(with characters: [CharacterEntity]) -> Bool {
        let fetchDescriptor = FetchDescriptor<CharacterModel>()
        do {
            let oldCharacters = try modelContext.fetch(fetchDescriptor)
            for character in oldCharacters {
                modelContext.delete(character)
            }

            for entity in characters {
                let persistent = CharacterModel(
                    id: entity.id,
                    name: entity.name,
                    thumbnail: entity.thumbnail,
                    age: entity.age,
                    weight: entity.weight,
                    height: entity.height,
                    hairColor: entity.hairColor,
                    professions: entity.professions,
                    friends: entity.friends
                )
                modelContext.insert(persistent)
            }
            try modelContext.save()
            return true
        } catch {
            modelContext.rollback()
            return false
        }
    }
}
