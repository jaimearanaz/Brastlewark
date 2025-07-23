import Domain

final class FilterRepository: FilterRepositoryProtocol {
    private var activeFilter: Filter?

    func getAvailableFilter(fromCharacters characters: [Character]) async throws -> Filter {
        var professions = Set<String>()
        var hairColors = Set<String>()
        var names = Set<String>()

        characters.forEach({
            $0.professions.forEach { professions.insert($0.localized) }
            hairColors.insert($0.hairColor)
            names.insert($0.name)
        })

        let minAge = characters.min { $0.age < $1.age }?.age ?? 0
        let maxAge = characters.max { $0.age < $1.age }?.age ?? 0
        let minWeight = Int(characters.min { $0.weight < $1.weight }?.weight ?? 0)
        let maxWeight = Int(characters.max { $0.weight < $1.weight }?.weight ?? 0)
        let minHeight = Int(characters.min { $0.height < $1.height }?.height ?? 0)
        let maxHeight = Int(characters.max { $0.height < $1.height }?.height ?? 0)
        let minFriends = Int(characters.min { $0.friends.count < $1.friends.count }?.friends.count ?? 0)
        let maxFriends = Int(characters.max { $0.friends.count < $1.friends.count }?.friends.count ?? 0)

        return Filter(age: minAge...maxAge,
                      weight: minWeight...maxWeight,
                      height: minHeight...maxHeight,
                      hairColor: Set(hairColors),
                      profession: Set(professions),
                      friends: minFriends...maxFriends)
    }

    func saveActiveFilter(_ filter: Filter) async throws {
        activeFilter = filter
    }

    func getActiveFilter() async throws -> Filter? {
        activeFilter
    }

    func deleteActiveFilter() async throws {
        activeFilter = nil
    }
}
