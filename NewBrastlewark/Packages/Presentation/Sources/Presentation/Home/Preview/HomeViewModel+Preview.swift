import Foundation
import Domain

extension HomeViewModel {
    static var preview: HomeViewModel {
        HomeViewModel(
            getAllCharactersUseCase: GetAllCharactersUseCaseMock(),
            saveSelectedCharacterUseCase: SaveSelectedCharacterUseCaseMock(),
            getActiveFilterUseCase: GetActiveFilterUseCaseMock(),
            getFilteredCharactersUseCase: GetFilteredCharactersUseCaseMock(),
            deleteActiveFilterUseCase: DeleteActiveFilterUseCaseMock(),
            getSearchedCharacterUseCase: GetSearchedCharacterUseCaseMock()
        )
    }
}
