struct Profession {
    private let originalValue: String

    init(_ value: String) {
        self.originalValue = value
    }

    var value: String {
        switch originalValue {
        case "PROFESSION_NONE":
            return "PROFESSION_NONE".localized
        default:
            return originalValue
        }
    }
}
