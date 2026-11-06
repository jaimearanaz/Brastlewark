import Foundation

public struct FilterUIModel: Sendable {
    var age: FilterSliderUIModel
    var weight: FilterSliderUIModel
    var height: FilterSliderUIModel
    var hairColor: [FilterItemListUIModel]
    var profession: [FilterItemListUIModel]
    var friends: FilterSliderUIModel

    public init(
        age: FilterSliderUIModel = FilterSliderUIModel(),
        weight: FilterSliderUIModel = FilterSliderUIModel(),
        height: FilterSliderUIModel = FilterSliderUIModel(),
        hairColor: [FilterItemListUIModel] = [FilterItemListUIModel](),
        profession: [FilterItemListUIModel] = [FilterItemListUIModel](),
        friends: FilterSliderUIModel = FilterSliderUIModel()) {
        self.age = age
        self.weight = weight
        self.height = height
        self.hairColor = hairColor
        self.profession = profession
        self.friends = friends
    }
}

public struct FilterSliderUIModel: Sendable {
    var available: ClosedRange<Int>
    var active: ClosedRange<Int>

    public init(available: ClosedRange<Int> = 0...0, active: ClosedRange<Int> = 0...0) {
        self.available = available
        self.active = active
    }
}

public struct FilterItemListUIModel: Sendable, Identifiable {
    public var id = UUID()
    var title: String
    var checked: Bool

    public init(title: String = "", checked: Bool = false) {
        self.title = title
        self.checked = checked
    }
}
