import Domain
import SwiftUI

public enum DetailsState: Sendable {
    case loading
    case ready(details: DetailsUIModel)
    case error
}

@MainActor
public protocol DetailsViewModelProtocol: ObservableObject {
    // Outputs
    var state: DetailsState { get }
    var characterId: Int { get set }

    // Inputs
    func didViewLoad()
    func didSelectCharacter(_ id: Int)
    func didTapHomeButton()
}

@MainActor
public final class DetailsViewModel: DetailsViewModelProtocol {
    @Published public var state: DetailsState = .loading
    public var characterId: Int

    private let router: any RouterProtocol
    private let getCharacterByIdUseCase: GetCharacterByIdUseCaseProtocol
    private let getSearchedCharacterUseCase: GetSearchedCharacterUseCaseProtocol


    public init(
        characterId: Int = 0,
        router: any RouterProtocol,
        getCharacterByIdUseCase: GetCharacterByIdUseCaseProtocol,
        getSearchedCharacterUseCase: GetSearchedCharacterUseCaseProtocol) {
            self.characterId = characterId
            self.router = router
            self.getCharacterByIdUseCase = getCharacterByIdUseCase
            self.getSearchedCharacterUseCase = getSearchedCharacterUseCase
    }

    public func didViewLoad() {
        state = .loading
        let getCharacterByIdUseCase = getCharacterByIdUseCase
        let getSearchedCharacterUseCase = getSearchedCharacterUseCase
        Task {
            let result = await getCharacterByIdUseCase.execute(params: .init(id: characterId))
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

                self.state = .ready(details: mapToDetailsUIModel(character: character, friends: friends))
            case .failure(_):
                self.state = .error
            }
        }
    }
    
    public func didSelectCharacter(_ id: Int) {
        router.navigate(to: .details(characterId: id, showHome: true))
    }

    public func didTapHomeButton() {
        router.navigateToRoot()
    }
}

private extension DetailsViewModel {
    func mapToDetailsUIModel(character: Character, friends: [DetailsFriendUIModel]) -> DetailsUIModel {
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
