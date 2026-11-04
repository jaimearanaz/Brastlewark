import Combine
import Domain
import Swinject
import Testing

@testable import Presentation

// swiftlint:disable force_cast force_unwrapping
@MainActor
struct FilterViewModelTests {
  var sut: FilterViewModel!
  var routerMock: RouterMock!
  var trackerMock: FilterTrackerMock!
  var getAvailableFilterUseCaseMock: GetAvailableFilterUseCaseMock!
  var getActiveFilterUseCaseMock: GetActiveFilterUseCaseMock!
  var saveActiveFilterUseCaseMock: SaveActiveFilterUseCaseMock!
  var delegateMock: FilterDelegateMock!

  init() {
    let container = DependencyRegistry.createFreshContainer()
    self.sut = container.resolve(FilterViewModel.self)!
    self.routerMock = (container.resolve((any RouterProtocol).self) as! RouterMock)
    self.trackerMock = (container.resolve(FilterTrackerProtocol.self) as! FilterTrackerMock)
    self.getAvailableFilterUseCaseMock =
      (container.resolve(GetAvailableFilterUseCaseProtocol.self) as! GetAvailableFilterUseCaseMock)
    self.getActiveFilterUseCaseMock =
      (container.resolve(GetActiveFilterUseCaseProtocol.self) as! GetActiveFilterUseCaseMock)
    self.saveActiveFilterUseCaseMock =
      (container.resolve(SaveActiveFilterUseCaseProtocol.self) as! SaveActiveFilterUseCaseMock)
    self.delegateMock = FilterDelegateMock()
    self.sut.delegate = delegateMock
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
    if case .ready(let filter) = state {
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
    if case .ready(let filter) = state {
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
    #expect(
      delegateMock.filterDidChangeAndApplyCalled,
      "Delegate should be notified before navigating back")
    #expect(routerMock.didNavigateBack, "Router should navigate back after applying filter")
    let capturedParams = saveActiveFilterUseCaseMock.capturedParams
    #expect(capturedParams != nil, "Filter should have been saved")
    #expect(
      capturedParams?.filter.age == testRange, "Saved filter should have the modified age range")
    #expect(await trackerMock.didTrackEvent(.applyTapped))
  }

  @Test
  func givenModifiedFilter_whenApplyIsTapped_thenFilterDelegateIsCalled() async {
    // given
    getAvailableFilterUseCaseMock.executeResult = .success(Filter.mock(age: 0...100))
    getActiveFilterUseCaseMock.executeResult = .success(nil)
    saveActiveFilterUseCaseMock.executeResult = .success(())
    sut.viewIsReady()
    try? await Task.sleep(for: .milliseconds(100))
    sut.didChangeAge(20...80)

    // when
    sut.didTapApplyButton()
    try? await Task.sleep(for: .milliseconds(100))

    // then
    #expect(delegateMock.filterDidChangeAndApplyCalled)
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
    if case .ready(let filter) = state {
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

// swiftlint:enable force_cast force_unwrapping
