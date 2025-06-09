import Foundation
import SwiftData

protocol CharactersAsyncCacheProtocol {
    func get() async -> [CharacterEntity]?
    func save(_ characters: [CharacterEntity]) async
    func isValid() async -> Bool
    func clearCache() async
}

final class PersistentCharactersCache: CharactersAsyncCacheProtocol {
    private let modelContainer: ModelContainer
    private let cacheValidity: TimeInterval
    private var timestamp: Date? {
        get { UserDefaults.standard.object(forKey: "characters_cache_timestamp") as? Date }
        set { UserDefaults.standard.set(newValue, forKey: "characters_cache_timestamp") }
    }

    // Permite inyectar un ModelContainer personalizado (por ejemplo, en memoria para tests)
    init(cacheValidityInSeconds: TimeInterval = 10, modelContainer: ModelContainer? = nil) {
        self.cacheValidity = cacheValidityInSeconds
        if let modelContainer = modelContainer {
            self.modelContainer = modelContainer
        } else {
            self.modelContainer = try! ModelContainer(for: CharacterModel.self)
        }
    }

    func get() async -> [CharacterEntity]? {
        await MainActor.run { [weak modelContainer] in
            let context = modelContainer?.mainContext
            let fetchDescriptor = FetchDescriptor<CharacterModel>()
            guard let persistentCharacters = try? context?.fetch(fetchDescriptor), !persistentCharacters.isEmpty else {
                return nil
            }
            return persistentCharacters.map { $0.toCharacterEntity() }
        }
    }

    func save(_ characters: [CharacterEntity]) async {
        await MainActor.run { [weak modelContainer] in
            let context = modelContainer?.mainContext

            let fetchDescriptor = FetchDescriptor<CharacterModel>()
            if let old = try? context?.fetch(fetchDescriptor) {
                for obj in old {
                    context?.delete(obj)
                }
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
                context?.insert(persistent)
            }
            try? context?.save()
        }
        timestamp = Date()
    }

    func isValid() async -> Bool {
        guard let timestamp = timestamp else { return false }
        let isTimeValid = Date().timeIntervalSince(timestamp) < cacheValidity
        // Comprueba que la caché no esté vacía
        return await MainActor.run { [weak modelContainer] in
            let context = modelContainer?.mainContext
            let fetchDescriptor = FetchDescriptor<CharacterModel>()
            if let persistentCharacters = try? context?.fetch(fetchDescriptor) {
                return isTimeValid && !persistentCharacters.isEmpty
            }
            return false
        }
    }

    func clearCache() async {
        await save([])
        UserDefaults.standard.removeObject(forKey: "characters_cache_timestamp")
    }
}
