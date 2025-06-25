import Domain
import SwiftUI

public enum DetailsState {
    case loading
    case ready(details: DetailsUIModel)
    case error
}

@MainActor
public protocol DetailsViewModelProtocol: ObservableObject {
    // Outputs
    var state: DetailsState { get }

    // Inputs
    func didViewLoad()
    func didSelectCharacter(_ id: String)
}

@MainActor
public final class DetailsViewModel: DetailsViewModelProtocol {
    @Published public var state: DetailsState = .loading

    private let getAllCharactersUseCase: GetAllCharactersUseCaseProtocol
    private let getSelectedCharacterUseCaseProtocol: GetSelectedCharacterUseCaseProtocol
    private let saveSelectedCharacterUseCase: SaveSelectedCharacterUseCaseProtocol

    public init(
        getAllCharactersUseCase: GetAllCharactersUseCaseProtocol,
        getSelectedCharacterUseCaseProtocol: GetSelectedCharacterUseCaseProtocol,
        saveSelectedCharacterUseCase: SaveSelectedCharacterUseCaseProtocol) {
            self.getAllCharactersUseCase = getAllCharactersUseCase
            self.getSelectedCharacterUseCaseProtocol = getSelectedCharacterUseCaseProtocol
            self.saveSelectedCharacterUseCase = saveSelectedCharacterUseCase
    }

    public func didViewLoad() {
        state = .loading
        let getSelectedCharacterUseCase = getSelectedCharacterUseCaseProtocol
        Task {
            let result = await getSelectedCharacterUseCase.execute()
            switch result {
            case .success(let character):
                guard let character = character else {
                    self.state = .error
                    return
                }
                self.state = .ready(details: mapToUIModel(character))
            case .failure(let error):
                self.state = .error
            }
        }
    }
    
    public func didSelectCharacter(_ id: String) {
        // TODO: implement
    }
}

private extension DetailsViewModel {
    // TODO: move to a mapper
    func mapToUIModel(_ character: Character) -> DetailsUIModel {
        DetailsUIModel(
            name: character.name,
            age: character.age,
            weight: character.weight,
            height: character.height,
            hairColor: character.hairColor,
            professions: character.professions)
    }
}
