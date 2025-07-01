import Testing
import Domain

@testable import Presentation

struct FilterMapperTests {
    @Test
    func givenAvailableAndActiveFilter_whenMap_thenCreatesCorrectFilterUIModel() {
        // given
        let available = Filter(
            age: 0...100,
            weight: 20...150,
            height: 100...200,
            hairColor: ["Red", "Black", "Brown"],
            profession: ["Miner", "Baker", "Woodcarver"],
            friends: 0...10
        )
        
        let active = Filter(
            age: 30...70,
            weight: 50...120,
            height: 120...180,
            hairColor: ["Red", "Brown"],
            profession: ["Baker"],
            friends: 2...8
        )
        
        // when
        let result = Filter.map(available: available, active: active)
        
        // then
        #expect(result.age.available == 0...100)
        #expect(result.age.active == 30...70)
        #expect(result.weight.available == 20...150)
        #expect(result.weight.active == 50...120)
        #expect(result.height.available == 100...200)
        #expect(result.height.active == 120...180)
        #expect(result.friends.available == 0...10)
        #expect(result.friends.active == 2...8)

        #expect(result.hairColor.count == 3)
        #expect(result.hairColor.contains { $0.title == "Red" && $0.checked })
        #expect(result.hairColor.contains { $0.title == "Brown" && $0.checked })
        #expect(result.hairColor.contains { $0.title == "Black" && !$0.checked })

        #expect(result.profession.count == 3)
        #expect(result.profession.contains { $0.title == "Baker" && $0.checked })
        #expect(result.profession.contains { $0.title == "Miner" && !$0.checked })
        #expect(result.profession.contains { $0.title == "Woodcarver" && !$0.checked })
    }
    
    @Test
    func givenAvailableFilterWithNoActiveFilter_whenMap_thenCreatesFilterUIModelWithNoCheckedItems() {
        // given
        let available = Filter(
            age: 0...100,
            weight: 20...150,
            height: 100...200,
            hairColor: ["Red", "Black", "Brown"],
            profession: ["Miner", "Baker", "Woodcarver"],
            friends: 0...10
        )
        
        let active = Filter()
        
        // when
        let result = Filter.map(available: available, active: active)
        
        // then
        #expect(result.age.available == 0...100)
        #expect(result.age.active == 0...0)
        #expect(result.weight.available == 20...150)
        #expect(result.weight.active == 0...0)
        #expect(result.height.available == 100...200)
        #expect(result.height.active == 0...0)
        #expect(result.friends.available == 0...10)
        #expect(result.friends.active == 0...0)

        #expect(result.hairColor.count == 3)
        #expect(result.hairColor.allSatisfy { !$0.checked })

        #expect(result.profession.count == 3)
        #expect(result.profession.allSatisfy { !$0.checked })
    }
    
    @Test
    func givenActiveFilterWithItemsNotInAvailable_whenMap_thenOnlyMapsAvailableItems() {
        // given
        let available = Filter(
            hairColor: ["Red", "Black"],
            profession: ["Miner", "Baker"]
        )
        
        let active = Filter(
            hairColor: ["Red", "Blue"],
            profession: ["Baker", "Carpenter"]
        )
        
        // when
        let result = Filter.map(available: available, active: active)
        
        // then
        #expect(result.hairColor.count == 2)
        #expect(result.hairColor.contains { $0.title == "Red" && $0.checked })
        #expect(result.hairColor.contains { $0.title == "Black" && !$0.checked })
        #expect(!result.hairColor.contains { $0.title == "Blue" })

        #expect(result.profession.count == 2)
        #expect(result.profession.contains { $0.title == "Baker" && $0.checked })
        #expect(result.profession.contains { $0.title == "Miner" && !$0.checked })
        #expect(!result.profession.contains { $0.title == "Carpenter" })
    }
    
    @Test
    func givenEmptyAvailableFilter_whenMap_thenCreatesEmptyFilterUIModel() {
        // given
        let available = Filter()
        let active = Filter()
        
        // when
        let result = Filter.map(available: available, active: active)
        
        // then
        #expect(result.age.available == 0...0)
        #expect(result.age.active == 0...0)
        #expect(result.weight.available == 0...0)
        #expect(result.weight.active == 0...0)
        #expect(result.height.available == 0...0)
        #expect(result.height.active == 0...0)
        #expect(result.friends.available == 0...0)
        #expect(result.friends.active == 0...0)
        #expect(result.hairColor.isEmpty)
        #expect(result.profession.isEmpty)
    }
}
