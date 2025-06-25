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

    private let getSelectedCharacterUseCaseProtocol: GetSelectedCharacterUseCaseProtocol
    private let getSearchedCharacterUseCase: GetSearchedCharacterUseCaseProtocol
    private let saveSelectedCharacterUseCase: SaveSelectedCharacterUseCaseProtocol


    public init(
        getSelectedCharacterUseCaseProtocol: GetSelectedCharacterUseCaseProtocol,
        getSearchedCharacterUseCase: GetSearchedCharacterUseCaseProtocol,
        saveSelectedCharacterUseCase: SaveSelectedCharacterUseCaseProtocol) {
            self.getSelectedCharacterUseCaseProtocol = getSelectedCharacterUseCaseProtocol
            self.getSearchedCharacterUseCase = getSearchedCharacterUseCase
            self.saveSelectedCharacterUseCase = saveSelectedCharacterUseCase
    }

    public func didViewLoad() {
        state = .loading
        let getSelectedCharacterUseCase = getSelectedCharacterUseCaseProtocol
        let getSearchedCharacterUseCase = getSearchedCharacterUseCase
        Task {
            let result = await getSelectedCharacterUseCase.execute()
            switch result {
            case .success(let character):
                guard let character = character else {
                    self.state = .error
                    return
                }
                var friends: [DetailsFriendUIModel] = []
                for name in character.friends {
                    let result = await getSearchedCharacterUseCase.execute(params: .init(searchText: name))
                    if case .success(let characters) = result,
                       let oneFriend = characters.first {
                        let friendUIModel = DetailsFriendUIModel(
                            id: oneFriend.id,
                            name: oneFriend.name,
                            thumbnail: oneFriend.thumbnail
                        )
                        friends.append(friendUIModel)
                    }
                }

                self.state = .ready(details: mapToUIModel(character: character, friends: friends))
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
    func mapToUIModel(character: Character, friends: [DetailsFriendUIModel]) -> DetailsUIModel {
        DetailsUIModel(
            name: character.name,
            thumbnail: character.thumbnail,
            age: character.age,
            weight: character.weight,
            height: character.height,
            hairColor: character.hairColor,
            professions: character.professions,
            friends: friends)
    }
}
