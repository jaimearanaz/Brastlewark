## What's this?

This project is a technical test developed for an iOS developer position. The description and requirements for the test are included in this repository as a PDF file named _“Brastlewark_mobile_test”_.

### Welcome to Brastlewark!

**Brastlewark** is an iOS application that displays all the inhabitants of the Gnome city called Brastlewark. Through the app, you can browse the complete city directory, search for people by name, characteristics or professions, and view detailed information and friends of each resident.

(animated GIF with app)

## Table of Contents

- [Basic Architecture](#basic-architecture)
- [Layer Separation](#layer-separation)
  - [Domain](#domain)
  - [Data](#data)
  - [Presentation](#presentation)
  - [App target](#app-target)
- [Navigation](#navigation)
- [Dependency Injection](#dependency-injection)
- [Testing](#testing)
- [Third Party Libraries](#third-party-libraries)
- [About Me](#about-me)

## Basic architecture

This project is based on a few fundamental technical decisions that guide the development, structure, and behavior of the app:

-   **Clean Architecture**, as described by [Uncle Bob](https://blog.cleancoder.com/uncle-bob/2012/08/13/The-Clean-Architecture.html), where the different elements of a software system are divided into three main layers: Data, Domain, and Presentation. Communication between layers follows strict boundaries to promote separation of concerns and maintainability.
-   The **MVVM pattern**, where views react to state changes, and view models are responsible for holding state and handling user interactions. This project is fully implemented using SwiftUI, `ObservableObject`, and `@Published` to achieve this reactive behavior.
-   The [**SOLID**](https://en.wikipedia.org/wiki/SOLID) **principles**, a set of essential rules that every software project should follow: single responsibility for each component, favoring extension over modification, protocol-oriented communication, and exposing only what is necessary to ensure modularity and testability.

## Layer separation

Although in an Xcode project the modularization by layers can be achieved in several ways, in Brastlewark each layer has been defined as an independent *Swift Package* for several reasons:
- faster compilation times
- enforces a true separation of concerns
- makes it easier to completely replace the implementation of a layer
- allows work to be smoothly divided among different teams

(diagram with layer communication)

### Domain

The **Domain layer** represents the core of the software system. It contains the business logic required to fulfill the application's requirements, defines the models that describe the business world, and specifies how data sources should be used and how data is returned.

**Use cases** represent the business logic, and they are implemented through classes known as `UseCase`. Each use case exposes an `execute()` method, which may receive input data through `params`. The execution follows an `async` pattern and returns a `Result` type, indicating either `.success` or `.failure`.

```swift
public struct GetCharacterByIdUseCaseParams {
    public let id: Int
    public init(id: Int) {
        self.id = id
    }
}

public protocol GetCharacterByIdUseCaseProtocol {
    func execute(params: GetCharacterByIdUseCaseParams) async -> Result<Character?, CharactersRepositoryError>
}
```

**Models** within the Domain layer are implemented as structs with simple, descriptive names. They represent entities and value objects relevant to the business logic and are used as both inputs and outputs in use cases.

**Repositories** are defined as abstractions over data sources. Their purpose is to provide a clean interface for use cases to interact with, without exposing implementation details. Repositories are defined through protocols, with all methods marked as `async throws`. They consistently use Domain models for both input and output data.

```swift
public protocol FilterRepositoryProtocol {
    func getAvailableFilter(fromCharacters: [Character]) async throws -> Filter
    func saveActiveFilter(_ filter: Filter) async throws
    func getActiveFilter() async throws -> Filter?
    func deleteActiveFilter() async throws
}
```

**Errors** are declared as `enum` types conforming to the `Error` protocol. In Brastlewark, errors are structured per repository (although additional domain-specific errors can be defined within use cases when necessary).

```swift
public enum FilterRepositoryError: Error {
    case noInternetConnection
    case unableToSaveFilter
    case unableToFetchFilter
    case unableToDeleteFilter
}
```

### Data

The **Data layer** is responsible for providing the data required by the use cases in the Domain layer. It interacts with different sources of truth, such as network services, caches or persistent storage. This layer implements the repository interfaces declared in the Domain layer.

All **repositories** are implemented in this layer through concrete `Repository` classes, conforming to the protocols defined in Domain. Each repository manages its own source of truth, which can vary depending on the specific scenario. 

For remote data retrieval, the `NetworkService` handles communication with external providers using `Combine` and `URLSession`. Requests can be forced to bypass the cache and fetch fresh data when necessary.

**Persistent storage** is managed using the `SwiftData` framework, allowing the application to store and retrieve previous request results across app launches.

```swift
protocol CharactersCacheProtocol {
    func get() async -> [CharacterEntity]?
    func save(_ characters: [CharacterEntity]) async
    func isValid() async -> Bool
    func clearCache() async
}
```

**Entities** represent the models used in Data layer. They typically respond to request and responses from network, and must be translated to Domain model using the corresponding **mappers**.

```swift
struct CharacterEntityMapper {
    static func map(entity: CharacterEntity) -> Character {
        Character(
            id: entity.id,
            name: entity.name,
            thumbnail: entity.thumbnail,
            age: entity.age,
            weight: entity.weight,
            height: entity.height,
            hairColor: entity.hairColor,
            professions: entity.professions,
            friends: entity.friends)
    }
}
```

### Presentation

The **Presentation layer** handles all user interface concerns. It enables users to interact with the app and delegates business logic and data requests to the use cases defined in the Domain layer.

All **views** are built using SwiftUI. They subscribe to their corresponding view models via `@StateObject` properties and automatically refresh when the view model's state changes. Views communicate user interactions back to the view model and leverage SwiftUI's **previews** to visualize different layout states during development.

```swift
public struct HomeView<ViewModel: HomeViewModelProtocol & ObservableObject>: View {
    @StateObject private var viewModel: ViewModel

    public init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
}

private extension HomeView {
    @ViewBuilder
    var contentView: some View {
        switch viewModel.state {
        case .loading:
            loadingView
        case .ready(let characters, _):
            readyView(characters: characters)
        case .empty:
            emptyView
        case .error(let error):
            errorView(error: error)
        }
    }
}
```

**View models** encapsulate all Presentation logic. They handle user interactions, manage the view state, and expose relevant data to the views. By conforming to the `ObservableObject` protocol and using `@Published` properties, view models trigger view updates automatically when their state changes.

```swift
public protocol HomeViewModelProtocol: ObservableObject {
    // Outputs
    var state: HomeState { get }
    var searchText: String { get set }

    // Inputs
    func didOnAppear()
    func didSelectCharacter(_ character: CharacterUIModel)
    func didTapFilterButton()
    func didTapResetButton()
    func didSearchTextChanged()
    func didRefreshCharacters()
}
```

View models interact with the Domain layer exclusively through **use cases**, which provide Domain models and errors. The view model translates Domain models into lightweight `UIModel` structs, containing only the data required to render the view. Likewise, Domain errors are transformed into user-friendly, localized messages suitable for display, allowing users to retry actions or recover gracefully from errors.

Finally, view models manage navigation using a `router`` property. When navigation actions occur, the **router** is responsible for constructing and presenting the next view along with its associated view model, ensuring a decoupled and testable navigation flow.

### App target

The final layer in this Xcode project is the **main target**, which represents the application itself. It serves as the entry point when the app is launched. Since it has visibility over all the layers in the project, it is responsible for assembling the different components and establishing communication between them through dependency injection.

Additionally, the main target handles the app’s navigation structure and UI flow.

## Navigation

Navigation in the Brastlewark app is managed by injecting a class called `Router` into every view model. This approach delegates all navigation logic away from views and view models into a dedicated, centralized component.

The `Router` class exposes intuitive methods such as `navigate(to:)`, `navigateBack()`, or `navigateToRoot()`.

```swift
public protocol RouterProtocol: ObservableObject {
    var path: NavigationPath { get set }

    func navigate(to route: Route)
    func navigateBack()
    func navigateToRoot()
    func popToView(count: Int)
    func canNavigateBack() -> Bool
}
```

Available routes are defined in a simple `Route` enum, where each navigation flow has its own case and declares the input data required to initialize its corresponding view and view model.

Navigation relies entirely on SwiftUI’s native mechanisms, using `NavigationStack` and `NavigationPath`. The full view hierarchy and available navigation flows are configured in the app’s main target.

```swift
public enum Route: Hashable {
    case filter
    case details(characterId: Int, showHome: Bool)
}
```

## Dependency injection

Dependency injection is a fundamental mechanism to achieve a truly **Clean Architecture**, where each component receives its configured and ready-to-use dependencies, without worrying about how they are created or where they come from. In addition, injected dependencies significantly simplify **testing and mocking**.

In Brastlewark, dependency injection is handled using a popular third-party library called [Swinject](https://github.com/Swinject/Swinject). Each layer has its own `Module` file, where all its components are declared, instantiated, and configured to be ready for use when required.

Finally, the app’s main target is responsible for executing all dependency injection modules, assembling the application, and wiring together the actors involved in the app’s lifecycle.

```swift
public enum DIContainer {
    public static let shared: Container = {
        let container = Container()
        DataModule.registerDependencies(inContainer: container)
        DomainModule.registerDependencies(inContainer: container)
        PresentationModule.registerDependencies(inContainer: container)
        return container
    }()
}
```

## Testing

Proper test coverage is essential for building high-quality software. Tests ensure that the system meets its requirements, behaves as expected, and helps prevent regressions when inevitable changes occur.

In the Brastlewark app, testing is implemented through two main approaches: **unit testing** and **snapshot-based UI testing**.

### Unit tests

Unit tests verify that small, isolated pieces of code work correctly — typically methods and functions. Each method has one or more tests to guarantee the expected behavior across the system.

To achieve this, a wide range of `Mock` classes and structs are implemented across all layers, allowing the simulation of different scenarios.

Unit testing in this project focuses primarily on the core components of the app: **view models**, **use cases**, **repositories**, **mappers**, and any additional logic or helpers used throughout the application’s features.

Tests are implemented using Apple’s native frameworks: the modern `Testing` framework and the reliable, well-established `XCTest`. All test cases follow a standard _given-when-then_ structure.

### Snapshot tests

Snapshot testing ensures that UI elements render as expected on the device screen. This technique compares screenshots taken during test execution with pre-approved reference images, which serve as the source of truth for the expected appearance.

For snapshot testing, the project uses the third-party library [SnapshotTesting](https://github.com/pointfreeco/swift-snapshot-testing) by Point-Free.


## Third party libraries
Brastlewark app uses the following third party libraries through Swift Package Manager:
- [MultiSlider](https://github.com/yonat/MultiSlider): for the double sliders used in filter view
- [Swinject](https://github.com/Swinject/Swinject): for dependency injection across the app
- [SnapshotTesting](https://github.com/pointfreeco/swift-snapshot-testing): for snapshot testing

## About me
Jaime Aranaz | *Freelance iOS developer* | jaime.aranaz@gmail.com | Madrid, Spain

 - [LinkedIn](https://www.linkedin.com/in/jaimearanaztudela/)
 - [X](https://x.com/JaimeAranaz)
 - [Website](https://www.jaimearanaz.com/)
