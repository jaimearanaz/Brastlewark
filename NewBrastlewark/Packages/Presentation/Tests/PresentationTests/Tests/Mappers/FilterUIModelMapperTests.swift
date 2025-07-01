import Testing
import Domain

@testable import Presentation

struct FilterUIModelMapperTests {
    @Test
    func givenFilterUIModelWithActiveRanges_whenMap_thenCreatesCorrectFilter() {
        // given
        let model = FilterUIModel(
            age: .init(available: 0...100, active: 20...80),
            weight: .init(available: 20...150, active: 50...120),
            height: .init(available: 100...200, active: 130...180),
            hairColor: [
                .init(title: "Red", checked: true),
                .init(title: "Black", checked: true),
                .init(title: "Brown", checked: false)
            ],
            profession: [
                .init(title: "Miner", checked: false),
                .init(title: "Baker", checked: true),
                .init(title: "Woodcarver", checked: false)
            ],
            friends: .init(available: 0...10, active: 2...8)
        )
        
        // when
        let result = FilterUIModel.map(model: model)
        
        // then
        #expect(result.age == 20...80)
        #expect(result.weight == 50...120)
        #expect(result.height == 130...180)
        #expect(result.friends == 2...8)
        
        #expect(result.hairColor.count == 2)
        #expect(result.hairColor.contains("Red"))
        #expect(result.hairColor.contains("Black"))
        #expect(!result.hairColor.contains("Brown"))
        
        #expect(result.profession.count == 1)
        #expect(result.profession.contains("Baker"))
        #expect(!result.profession.contains("Miner"))
        #expect(!result.profession.contains("Woodcarver"))
    }
    
    @Test
    func givenFilterUIModelWithNoCheckedItems_whenMap_thenCreatesFilterWithEmptyCollections() {
        // given
        let model = FilterUIModel(
            age: .init(available: 0...100, active: 0...100),
            weight: .init(available: 20...150, active: 20...150),
            height: .init(available: 100...200, active: 100...200),
            hairColor: [
                .init(title: "Red", checked: false),
                .init(title: "Black", checked: false),
                .init(title: "Brown", checked: false)
            ],
            profession: [
                .init(title: "Miner", checked: false),
                .init(title: "Baker", checked: false),
                .init(title: "Woodcarver", checked: false)
            ],
            friends: .init(available: 0...10, active: 0...10)
        )
        
        // when
        let result = FilterUIModel.map(model: model)
        
        // then
        #expect(result.age == 0...100)
        #expect(result.weight == 20...150)
        #expect(result.height == 100...200)
        #expect(result.friends == 0...10)
        
        #expect(result.hairColor.isEmpty)
        #expect(result.profession.isEmpty)
    }
    
    @Test
    func givenEmptyFilterUIModel_whenMap_thenCreatesEmptyFilter() {
        // given
        let model = FilterUIModel()
        
        // when
        let result = FilterUIModel.map(model: model)
        
        // then
        #expect(result.age == 0...0)
        #expect(result.weight == 0...0)
        #expect(result.height == 0...0)
        #expect(result.friends == 0...0)
        #expect(result.hairColor.isEmpty)
        #expect(result.profession.isEmpty)
    }
    
    @Test
    func givenFilterUIModelWithAllItemsChecked_whenMap_thenCreatesFilterWithAllCollections() {
        // given
        let model = FilterUIModel(
            hairColor: [
                .init(title: "Red", checked: true),
                .init(title: "Black", checked: true),
                .init(title: "Brown", checked: true)
            ],
            profession: [
                .init(title: "Miner", checked: true),
                .init(title: "Baker", checked: true),
                .init(title: "Woodcarver", checked: true)
            ]
        )
        
        // when
        let result = FilterUIModel.map(model: model)
        
        // then
        #expect(result.hairColor.count == 3)
        #expect(result.hairColor.contains("Red"))
        #expect(result.hairColor.contains("Black"))
        #expect(result.hairColor.contains("Brown"))
        
        #expect(result.profession.count == 3)
        #expect(result.profession.contains("Miner"))
        #expect(result.profession.contains("Baker"))
        #expect(result.profession.contains("Woodcarver"))
    }
}
