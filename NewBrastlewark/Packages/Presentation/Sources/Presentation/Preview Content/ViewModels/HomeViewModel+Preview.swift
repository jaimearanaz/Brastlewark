import Foundation

extension HomeViewModel {
    static var preview: HomeViewModel {
        .init(
            getAllCharactersUseCase: PreviewUseCaseMocks.getAllCharactersUseCase,
            saveSelectedCharacterUseCase: PreviewUseCaseMocks.saveSelectedCharacterUseCase,
            getActiveFilterUseCase: PreviewUseCaseMocks.getActiveFilterUseCase,
            getFilteredCharactersUseCase: PreviewUseCaseMocks.getFilteredCharactersUseCase,
            deleteActiveFilterUseCase: PreviewUseCaseMocks.deleteActiveFilterUseCase,
            getSearchedCharacterUseCase: PreviewUseCaseMocks.getSearchedCharacterUseCase)
    }
}
