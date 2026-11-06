import Domain
import Testing

@testable import Presentation

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
    if case .ready(let filter) = state {
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
    if case .ready(let filter) = state {
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
    if case .ready(let filter) = state {
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
    if case .ready(let filter) = state {
      #expect(
        filter.hairColor.contains { $0.title == "Red" && $0.checked },
        "Red hair color should be checked")
      #expect(
        filter.hairColor.contains { $0.title == "Brown" && !$0.checked },
        "Brown hair color should not be checked")
      #expect(
        filter.hairColor.contains { $0.title == "Black" && !$0.checked },
        "Black hair color should not be checked")
    } else {
      #expect(Bool(false), "Expected .ready state but got \(state)")
    }
    #expect(
      await trackerMock.didTrackEvent(.hairColorChanged(title: hairColorTitle, checked: isChecked)))
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
    if case .ready(let filter) = state {
      #expect(
        filter.hairColor.contains { $0.title == "Red" && !$0.checked },
        "Red hair color should be unchecked after reset")
      #expect(
        filter.hairColor.contains { $0.title == "Brown" && !$0.checked },
        "Brown hair color should be unchecked")
      #expect(
        filter.hairColor.contains { $0.title == "Black" && !$0.checked },
        "Black hair color should be unchecked")
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
    if case .ready(let filter) = state {
      #expect(
        filter.profession.contains { $0.title == "Baker" && $0.checked },
        "Baker profession should be checked")
      #expect(
        filter.profession.contains { $0.title == "Miner" && !$0.checked },
        "Miner profession should not be checked")
      #expect(
        filter.profession.contains { $0.title == "Woodcarver" && !$0.checked },
        "Woodcarver profession should not be checked")
    } else {
      #expect(Bool(false), "Expected .ready state but got \(state)")
    }
    #expect(
      await trackerMock.didTrackEvent(
        .professionChanged(title: professionTitle, checked: isChecked)))
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
    if case .ready(let filter) = state {
      #expect(
        filter.profession.contains { $0.title == "Baker" && !$0.checked },
        "Baker profession should be unchecked after reset")
      #expect(
        filter.profession.contains { $0.title == "Miner" && !$0.checked },
        "Miner profession should be unchecked")
      #expect(
        filter.profession.contains { $0.title == "Woodcarver" && !$0.checked },
        "Woodcarver profession should be unchecked")
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
    if case .ready(let filter) = state {
      #expect(filter.friends.active == newFriendsRange, "Friends range should be updated")
    } else {
      #expect(Bool(false), "Expected .ready state but got \(state)")
    }
    #expect(await trackerMock.didTrackEvent(.friendsChanged(friends: newFriendsRange)))
  }
}
