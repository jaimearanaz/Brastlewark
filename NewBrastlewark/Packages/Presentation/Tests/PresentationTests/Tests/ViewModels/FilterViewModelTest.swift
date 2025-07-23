import Testing
import Combine
import Domain
import Swinject

@testable import Presentation

// swiftlint:disable force_cast file_length force_unwrapping
@MainActor
struct FilterViewModelTests {
    private var sut: FilterViewModel!
    private var routerMock: RouterMock!
    private var trackerMock: FilterTrackerMock!
    private var getAvailableFilterUseCaseMock: GetAvailableFilterUseCaseMock!
    private var getActiveFilterUseCaseMock: GetActiveFilterUseCaseMock!
    private var saveActiveFilterUseCaseMock: SaveActiveFilterUseCaseMock!

    init() {
        let container = DependencyRegistry.createFreshContainer()
        self.sut = container.resolve(FilterViewModel.self)!
        self.routerMock = (container.resolve((any RouterProtocol).self) as! RouterMock)
        self.trackerMock = (container.resolve(FilterTrackerProtocol.self) as! FilterTrackerMock)
        self.getAvailableFilterUseCaseMock = (container.resolve(GetAvailableFilterUseCaseProtocol.self) as! GetAvailableFilterUseCaseMock)
        self.getActiveFilterUseCaseMock = (container.resolve(GetActiveFilterUseCaseProtocol.self) as! GetActiveFilterUseCaseMock)
        self.saveActiveFilterUseCaseMock = (container.resolve(SaveActiveFilterUseCaseProtocol.self) as! SaveActiveFilterUseCaseMock)
    }

    @Test
    func givenNoActiveFilter_whenFilterIsLoaded_ThenUsesDefaultFilter() async {
        // given
        let availableFilter = Filter.mock(
            age: 0...100,
            weight: 20...150,
            height: 100...200,
            hairColor: ["Red", "Brown", "Black"],
            profession: ["Miner", "Baker", "Woodcarver"],
            friends: 0...8
        )
        getAvailableFilterUseCaseMock.executeResult = .success(availableFilter)
        getActiveFilterUseCaseMock.executeResult = .success(nil)

        // when
        sut.viewIsReady()
        try? await Task.sleep(nanoseconds: 100_000_000)

        // then
        let state = sut.state
        if case let .ready(filter) = state {
            #expect(filter.age.available == 0...100)
            #expect(filter.age.active == 0...100)
            #expect(filter.weight.available == 20...150)
            #expect(filter.weight.active == 20...150)
            #expect(filter.height.available == 100...200)
            #expect(filter.height.active == 100...200)
            #expect(filter.friends.available == 0...8)
            #expect(filter.friends.active == 0...8)

            #expect(filter.hairColor.count == 3)
            #expect(filter.hairColor.contains { $0.title == "Red" && !$0.checked })
            #expect(filter.hairColor.contains { $0.title == "Brown" && !$0.checked })
            #expect(filter.hairColor.contains { $0.title == "Black" && !$0.checked })

            #expect(filter.profession.count == 3)
            #expect(filter.profession.contains { $0.title == "Miner" && !$0.checked })
            #expect(filter.profession.contains { $0.title == "Baker" && !$0.checked })
            #expect(filter.profession.contains { $0.title == "Woodcarver" && !$0.checked })
        } else {
            #expect(Bool(false), "Expected .ready state but got \(state)")
        }
        #expect(await trackerMock.didTrackEvent(.screenViewed))
    }

    @Test
    func givenActiveFilter_whenFilterIsLoaded_ThenUsesActiveFilterValues() async {
        // given
        let availableFilter = Filter.mock(
            age: 0...100,
            weight: 20...150,
            height: 100...200,
            hairColor: ["Red", "Brown", "Black", "Blue", "Green"],
            profession: ["Miner", "Baker", "Woodcarver", "Engineer", "Farmer"],
            friends: 0...10
        )
        getAvailableFilterUseCaseMock.executeResult = .success(availableFilter)

        let activeFilter = Filter.mock(
            age: 30...60,
            weight: 50...120,
            height: 130...180,
            hairColor: ["Red", "Black"],
            profession: ["Baker"],
            friends: 2...8
        )
        getActiveFilterUseCaseMock.executeResult = .success(activeFilter)

        // when
        sut.viewIsReady()
        try? await Task.sleep(nanoseconds: 100_000_000)

        let state = sut.state
        if case let .ready(filter) = state {
            #expect(filter.age.available == 0...100)
            #expect(filter.weight.available == 20...150)
            #expect(filter.height.available == 100...200)
            #expect(filter.friends.available == 0...10)

            #expect(filter.age.active == 30...60)
            #expect(filter.weight.active == 50...120)
            #expect(filter.height.active == 130...180)
            #expect(filter.friends.active == 2...8)

            #expect(filter.hairColor.count == 5)

            #expect(filter.hairColor.contains { $0.title == "Red" && $0.checked })
            #expect(filter.hairColor.contains { $0.title == "Black" && $0.checked })
            #expect(filter.hairColor.contains { $0.title == "Brown" && !$0.checked })
            #expect(filter.hairColor.contains { $0.title == "Blue" && !$0.checked })
            #expect(filter.hairColor.contains { $0.title == "Green" && !$0.checked })

            #expect(filter.profession.count == 5)

            #expect(filter.profession.contains { $0.title == "Baker" && $0.checked })
            #expect(filter.profession.contains { $0.title == "Miner" && !$0.checked })
            #expect(filter.profession.contains { $0.title == "Woodcarver" && !$0.checked })
            #expect(filter.profession.contains { $0.title == "Engineer" && !$0.checked })
            #expect(filter.profession.contains { $0.title == "Farmer" && !$0.checked })
        } else {
            #expect(Bool(false), "Expected .ready state but got \(state)")
        }
    }

    @Test
    func givenFilter_whenTapsOnApply_thenFilterIsSavedAndDismiss() async {
        // given
        let availableFilter = Filter.mock(age: 0...100)
        getAvailableFilterUseCaseMock.executeResult = .success(availableFilter)
        getActiveFilterUseCaseMock.executeResult = .success(nil)
        saveActiveFilterUseCaseMock.executeResult = .success(())

        sut.viewIsReady()
        try? await Task.sleep(nanoseconds: 100_000_000)

        let testRange = 20...80
        sut.didChangeAge(testRange)

        // when
        sut.didTapApplyButton()
        try? await Task.sleep(nanoseconds: 100_000_000)

        // then
        #expect(routerMock.didNavigateBack, "Router should navigate back after applying filter")
        let capturedParams = saveActiveFilterUseCaseMock.capturedParams
        #expect(capturedParams != nil, "Filter should have been saved")
        #expect(capturedParams?.filter.age == testRange, "Saved filter should have the modified age range")
        #expect(await trackerMock.didTrackEvent(.applyTapped))
    }

    @Test
    func givenFilter_whenTapsOnReset_thenFilterIsSetToAvailableFilterValues() async {
        // given
        let availableFilter = Filter.mock(
            age: 0...100,
            weight: 20...150,
            height: 100...200,
            hairColor: ["Red", "Brown", "Black"],
            profession: ["Miner", "Baker", "Woodcarver"],
            friends: 0...10
        )
        getAvailableFilterUseCaseMock.executeResult = .success(availableFilter)

        let activeFilter = Filter.mock(
            age: 30...60,
            weight: 50...120,
            height: 130...180,
            hairColor: ["Red"],
            profession: ["Baker"],
            friends: 2...8
        )
        getActiveFilterUseCaseMock.executeResult = .success(activeFilter)

        sut.viewIsReady()
        try? await Task.sleep(nanoseconds: 100_000_000)

        sut.didChangeAge(25...75)

        // when
        sut.didTapResetButton()
        try? await Task.sleep(nanoseconds: 100_000_000)

        // then
        let state = sut.state
        if case let .ready(filter) = state {
            #expect(filter.age.available == 0...100)
            #expect(filter.age.active == 0...100)
            #expect(filter.weight.available == 20...150)
            #expect(filter.weight.active == 20...150)
            #expect(filter.height.available == 100...200)
            #expect(filter.height.active == 100...200)
            #expect(filter.friends.available == 0...10)
            #expect(filter.friends.active == 0...10)

            #expect(filter.hairColor.count == 3)
            #expect(filter.hairColor.contains { $0.title == "Red" && !$0.checked })
            #expect(filter.hairColor.contains { $0.title == "Brown" && !$0.checked })
            #expect(filter.hairColor.contains { $0.title == "Black" && !$0.checked })

            #expect(filter.profession.count == 3)
            #expect(filter.profession.contains { $0.title == "Miner" && !$0.checked })
            #expect(filter.profession.contains { $0.title == "Baker" && !$0.checked })
            #expect(filter.profession.contains { $0.title == "Woodcarver" && !$0.checked })
        } else {
            #expect(Bool(false), "Expected .ready state but got \(state)")
        }
        #expect(await trackerMock.didTrackEvent(.resetTapped))
    }
}

// MARK: - Filter Change Tests
@MainActor
extension FilterViewModelTests {
    @Test
    func givenFilter_whenAgeChanges_thenFilterIsUpdated() async {
        // given
        let availableFilter = Filter.mock(age: 0...100)
        getAvailableFilterUseCaseMock.executeResult = .success(availableFilter)
        getActiveFilterUseCaseMock.executeResult = .success(nil)

        sut.viewIsReady()
        try? await Task.sleep(nanoseconds: 100_000_000)

        // when
        let newAgeRange = 25...75
        sut.didChangeAge(newAgeRange)
        try? await Task.sleep(nanoseconds: 100_000_000)

        // then
        let state = sut.state
        if case let .ready(filter) = state {
            #expect(filter.age.active == newAgeRange, "Age range should be updated")
        } else {
            #expect(Bool(false), "Expected .ready state but got \(state)")
        }
        #expect(await trackerMock.didTrackEvent(.ageChanged(age: newAgeRange)))
    }

    @Test
    func givenFilter_whenWeightChanges_thenFilterIsUpdated() async {
        // given
        let availableFilter = Filter.mock(weight: 20...150)
        getAvailableFilterUseCaseMock.executeResult = .success(availableFilter)
        getActiveFilterUseCaseMock.executeResult = .success(nil)

        sut.viewIsReady()
        try? await Task.sleep(nanoseconds: 100_000_000)

        // when
        let newWeightRange = 40...100
        sut.didChangeWeight(newWeightRange)
        try? await Task.sleep(nanoseconds: 100_000_000)

        // then
        let state = sut.state
        if case let .ready(filter) = state {
            #expect(filter.weight.active == newWeightRange, "Weight range should be updated")
        } else {
            #expect(Bool(false), "Expected .ready state but got \(state)")
        }
        #expect(await trackerMock.didTrackEvent(.weightChanged(weight: newWeightRange)))
    }

    @Test
    func givenFilter_whenHeightChanges_thenFilterIsUpdated() async {
        // given
        let availableFilter = Filter.mock(height: 100...200)
        getAvailableFilterUseCaseMock.executeResult = .success(availableFilter)
        getActiveFilterUseCaseMock.executeResult = .success(nil)

        sut.viewIsReady()
        try? await Task.sleep(nanoseconds: 100_000_000)

        // when
        let newHeightRange = 120...180
        sut.didChangeHeight(newHeightRange)
        try? await Task.sleep(nanoseconds: 100_000_000)

        // then
        let state = sut.state
        if case let .ready(filter) = state {
            #expect(filter.height.active == newHeightRange, "Height range should be updated")
        } else {
            #expect(Bool(false), "Expected .ready state but got \(state)")
        }
        #expect(await trackerMock.didTrackEvent(.heightChanged(height: newHeightRange)))
    }

    @Test
    func givenFilter_whenHairColorChanges_thenFilterIsUpdated() async {
        // given
        let availableFilter = Filter.mock(hairColor: ["Red", "Brown", "Black"])
        getAvailableFilterUseCaseMock.executeResult = .success(availableFilter)
        getActiveFilterUseCaseMock.executeResult = .success(nil)

        sut.viewIsReady()
        try? await Task.sleep(nanoseconds: 100_000_000)

        // when
        let hairColorTitle = "Red"
        let isChecked = true
        sut.didChangeHairColor(title: hairColorTitle, checked: isChecked)
        try? await Task.sleep(nanoseconds: 100_000_000)

        // then
        let state = sut.state
        if case let .ready(filter) = state {
            #expect(filter.hairColor.contains { $0.title == "Red" && $0.checked }, "Red hair color should be checked")
            #expect(filter.hairColor.contains { $0.title == "Brown" && !$0.checked }, "Brown hair color should not be checked")
            #expect(filter.hairColor.contains { $0.title == "Black" && !$0.checked }, "Black hair color should not be checked")
        } else {
            #expect(Bool(false), "Expected .ready state but got \(state)")
        }
        #expect(await trackerMock.didTrackEvent(.hairColorChanged(title: hairColorTitle, checked: isChecked)))

    }

    @Test
    func givenFilter_whenHairColorIsReset_thenFilterIsUpdated() async {
        // given
        let availableFilter = Filter.mock(hairColor: ["Red", "Brown", "Black"])
        getAvailableFilterUseCaseMock.executeResult = .success(availableFilter)
        getActiveFilterUseCaseMock.executeResult = .success(nil)

        sut.viewIsReady()
        try? await Task.sleep(nanoseconds: 100_000_000)
        sut.didChangeHairColor(title: "Red", checked: true)
        try? await Task.sleep(nanoseconds: 100_000_000)

        // when
        sut.didResetHairColor()
        try? await Task.sleep(nanoseconds: 100_000_000)

        // then
        let state = sut.state
        if case let .ready(filter) = state {
            #expect(filter.hairColor.contains { $0.title == "Red" && !$0.checked }, "Red hair color should be unchecked after reset")
            #expect(filter.hairColor.contains { $0.title == "Brown" && !$0.checked }, "Brown hair color should be unchecked")
            #expect(filter.hairColor.contains { $0.title == "Black" && !$0.checked }, "Black hair color should be unchecked")
        } else {
            #expect(Bool(false), "Expected .ready state but got \(state)")
        }
        #expect(await trackerMock.didTrackEvent(.hairColorReset))
    }

    @Test
    func givenFilter_whenProfessionChanges_thenFilterIsUpdated() async {
        // given
        let availableFilter = Filter.mock(profession: ["Miner", "Baker", "Woodcarver"])
        getAvailableFilterUseCaseMock.executeResult = .success(availableFilter)
        getActiveFilterUseCaseMock.executeResult = .success(nil)

        sut.viewIsReady()
        try? await Task.sleep(nanoseconds: 100_000_000)

        // when
        let professionTitle = "Baker"
        let isChecked = true
        sut.didChangeProfession(title: professionTitle, checked: isChecked)
        try? await Task.sleep(nanoseconds: 100_000_000)

        // then
        let state = sut.state
        if case let .ready(filter) = state {
            #expect(filter.profession.contains { $0.title == "Baker" && $0.checked }, "Baker profession should be checked")
            #expect(filter.profession.contains { $0.title == "Miner" && !$0.checked }, "Miner profession should not be checked")
            #expect(filter.profession.contains { $0.title == "Woodcarver" && !$0.checked }, "Woodcarver profession should not be checked")
        } else {
            #expect(Bool(false), "Expected .ready state but got \(state)")
        }
        #expect(await trackerMock.didTrackEvent(.professionChanged(title: professionTitle, checked: isChecked)))
    }

    @Test
    func givenFilter_whenProfessionIsReset_thenFilterIsUpdated() async {
        // given
        let availableFilter = Filter.mock(profession: ["Miner", "Baker", "Woodcarver"])
        getAvailableFilterUseCaseMock.executeResult = .success(availableFilter)
        getActiveFilterUseCaseMock.executeResult = .success(nil)

        sut.viewIsReady()
        try? await Task.sleep(nanoseconds: 100_000_000)
        sut.didChangeProfession(title: "Baker", checked: true)
        try? await Task.sleep(nanoseconds: 100_000_000)

        // when
        sut.didResetProfession()
        try? await Task.sleep(nanoseconds: 100_000_000)

        // then
        let state = sut.state
        if case let .ready(filter) = state {
            #expect(filter.profession.contains { $0.title == "Baker" && !$0.checked }, "Baker profession should be unchecked after reset")
            #expect(filter.profession.contains { $0.title == "Miner" && !$0.checked }, "Miner profession should be unchecked")
            #expect(filter.profession.contains { $0.title == "Woodcarver" && !$0.checked }, "Woodcarver profession should be unchecked")
        } else {
            #expect(Bool(false), "Expected .ready state but got \(state)")
        }
        #expect(await trackerMock.didTrackEvent(.professionReset))
    }

    @Test
    func givenFilter_whenFriendsChanges_thenFilterIsUpdated() async {
        // given
        let availableFilter = Filter.mock(friends: 0...10)
        getAvailableFilterUseCaseMock.executeResult = .success(availableFilter)
        getActiveFilterUseCaseMock.executeResult = .success(nil)

        sut.viewIsReady()
        try? await Task.sleep(nanoseconds: 100_000_000)

        // when
        let newFriendsRange = 2...8
        sut.didChangeFriends(newFriendsRange)
        try? await Task.sleep(nanoseconds: 100_000_000)

        // then
        let state = sut.state
        if case let .ready(filter) = state {
            #expect(filter.friends.active == newFriendsRange, "Friends range should be updated")
        } else {
            #expect(Bool(false), "Expected .ready state but got \(state)")
        }
        #expect(await trackerMock.didTrackEvent(.friendsChanged(friends: newFriendsRange)))
    }
}
// swiftlint:enable force_cast force_unwrapping
