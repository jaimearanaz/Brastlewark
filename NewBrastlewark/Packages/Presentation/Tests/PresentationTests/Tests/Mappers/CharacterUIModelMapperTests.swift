import Testing
import Domain
@testable import Presentation

struct CharacterUIModelMapperTests {
    @Test
    func testMapFromUIModelToCharacter() {
        // given
        let uiModel = CharacterUIModel(
            id: 123,
            name: "Test UI Character",
            thumbnail: "http://example.com/test.jpg",
            age: 45,
            weight: 75.2,
            height: 185.5,
            hairColor: "Golden",
            professions: ["Blacksmith", "Warrior"],
            friends: ["FriendA", "FriendB", "FriendC"]
        )
        
        // when
        let result = CharacterUIModel.map(model: uiModel)
        
        // then
        #expect(result.id == 123)
        #expect(result.name == "Test UI Character")
        #expect(result.thumbnail == "http://example.com/test.jpg")
        #expect(result.age == 45)
        #expect(result.weight == 75.2)
        #expect(result.height == 185.5)
        #expect(result.hairColor == "Golden")
        #expect(result.professions.count == 2)
        #expect(result.professions.contains("Blacksmith"))
        #expect(result.professions.contains("Warrior"))
        #expect(result.friends.count == 3)
        #expect(result.friends.contains("FriendA"))
        #expect(result.friends.contains("FriendB"))
        #expect(result.friends.contains("FriendC"))
    }
    
    @Test
    func testMappingPreservesEmptyCollections() {
        // given
        let uiModel = CharacterUIModel(
            id: 456,
            name: "Empty Collections",
            thumbnail: "http://example.com/empty.jpg",
            age: 20,
            weight: 60.0,
            height: 170.0,
            hairColor: "Bald",
            professions: [], // Empty professions
            friends: []      // Empty friends
        )
        
        // when
        let result = CharacterUIModel.map(model: uiModel)
        
        // then
        #expect(result.id == 456)
        #expect(result.name == "Empty Collections")
        #expect(result.professions.isEmpty)
        #expect(result.friends.isEmpty)
        #expect(result.hairColor == "Bald")
    }
    
    @Test
    func testMappingFieldTypesArePreserved() {
        // given
        let uiModel = CharacterUIModel(
            id: 789,
            name: "Type Check",
            thumbnail: "http://example.com/type.jpg",
            age: 1000, // Extreme value
            weight: 0.1, // Very small value
            height: 999.999, // Precise decimal
            hairColor: "",  // Empty string
            professions: ["Multiple", "Different", "Professions"],
            friends: ["One Single Friend"]
        )
        
        // when
        let result = CharacterUIModel.map(model: uiModel)
        
        // then
        #expect(result.id == 789)
        #expect(result.age == 1000)
        #expect(result.weight == 0.1)
        #expect(result.height == 999.999)
        #expect(result.hairColor.isEmpty)
        #expect(result.professions.count == 3)
        #expect(result.friends.count == 1)
        #expect(result.friends[0] == "One Single Friend")
    }
}
