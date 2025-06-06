import Testing

@testable import Domain

struct FilterTests {
    @Test
    func given_two_filters_with_same_values_when_compared_then_are_equal() async throws {
        let filter1 = Filter(
            age: 10...20,
            weight: 30...50,
            height: 100...150,
            hairColor: ["red", "blue"],
            profession: ["carpenter", "baker"],
            friends: 1...5
        )
        let filter2 = Filter(
            age: 10...20,
            weight: 30...50,
            height: 100...150,
            hairColor: ["blue", "red"],
            profession: ["baker", "carpenter"],
            friends: 1...5
        )
        #expect(filter1 == filter2)
    }

    @Test
    func given_two_filters_with_different_values_when_compared_then_are_not_equal() async throws {
        let filter1 = Filter(
            age: 10...20,
            weight: 30...50,
            height: 100...150,
            hairColor: ["red"],
            profession: ["carpenter"],
            friends: 1...5
        )
        let filter2 = Filter(
            age: 10...21,
            weight: 30...50,
            height: 100...150,
            hairColor: ["red"],
            profession: ["carpenter"],
            friends: 1...5
        )
        #expect(filter1 != filter2)
    }

    @Test
    func given_filter_with_default_init_when_checked_then_sets_are_empty() async throws {
        let filter = Filter(age: 0...0, weight: 0...0, height: 0...0, friends: 0...0)
        #expect(filter.hairColor.isEmpty)
        #expect(filter.profession.isEmpty)
    }
}
