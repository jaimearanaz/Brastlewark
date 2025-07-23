import Testing
import Domain
@testable import Presentation

struct CharacterMapperTests {
    @Test
    func testMapSingleCharacter() {
        // given
        let character = Character(
            id: 42,
            name: "Test Character",
            thumbnail: "http://example.com/image.png",
            age: 30,
            weight: 65.5,
            height: 180.0,
            hairColor: "Brown",
            professions: ["Baker", "Miner"],
            friends: ["Friend1", "Friend2"]
        )
        
        // when
        let result = CharacterMapper.map(model: character)
        
        // then
        #expect(result.id == 42)
        #expect(result.name == "Test Character")
        #expect(result.thumbnail == "http://example.com/image.png")
        #expect(result.age == 30)
        #expect(result.weight == 65.5)
        #expect(result.height == 180.0)
        #expect(result.hairColor == "Brown")
        #expect(result.professions.count == 2)
        #expect(result.professions.contains("Baker"))
        #expect(result.professions.contains("Miner"))
        #expect(result.friends.count == 2)
        #expect(result.friends.contains("Friend1"))
        #expect(result.friends.contains("Friend2"))
    }
    
    @Test
    func testMapMultipleCharacters() {
        // given
        let characters = [
            Character(
                id: 1,
                name: "Character 1",
                thumbnail: "http://example.com/1.png",
                age: 25,
                weight: 60.0,
                height: 170.0,
                hairColor: "Black",
                professions: ["Tailor"],
                friends: ["Friend1"]
            ),
            Character(
                id: 2,
                name: "Character 2",
                thumbnail: "http://example.com/2.png",
                age: 35,
                weight: 70.0,
                height: 190.0,
                hairColor: "Red",
                professions: ["Carpenter", "Hunter"],
                friends: ["Friend2", "Friend3"]
            )
        ]
        
        // when
        let results = CharacterMapper.map(models: characters)
        
        // then
        #expect(results.count == 2)
        
        #expect(results[0].id == 1)
        #expect(results[0].name == "Character 1")
        #expect(results[0].hairColor == "Black")
        #expect(results[0].professions.count == 1)
        
        #expect(results[1].id == 2)
        #expect(results[1].name == "Character 2")
        #expect(results[1].hairColor == "Red")
        #expect(results[1].professions.count == 2)
        #expect(results[1].friends.count == 2)
    }
    
    @Test
    func testMapEmptyArray() {
        // given
        let characters: [Character] = []
        
        // when
        let results = CharacterMapper.map(models: characters)
        
        // then
        #expect(results.isEmpty)
    }
}
