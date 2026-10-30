public enum LogCategory: String, CaseIterable, Sendable {
    case network = "data.network"
    case decoding = "data.decoding"
    case persistence = "data.persistence"
    case repository = "data.repository"
    case domain
    case viewModel = "presentation.viewmodel"
    case interaction = "presentation.interaction"
    case navigation = "presentation.navigation"
    case lifecycle = "app.lifecycle"
    case performance
    case diagnostics
}
