import XCTest
import SwiftUI
import SnapshotTesting

@testable import Presentation

@MainActor
final class HomeViewSnapshotTests: XCTestCase {
    private let isRecording = false

    func testHomeViewFullSnapshot() {
        // Given
        let view = HomeView(viewModel: HomeViewModelPreview.full)

        // When & Then
        assertSnapshot(view: view, test: #function)
    }

    func testHomeViewNotFullSnapshot() {
        // Given
        let view = HomeView(viewModel: HomeViewModelPreview.notFull)

        // When & Then
        assertSnapshot(view: view, test: #function)
    }

    func testHomeViewFilteredSnapshot() {
        // Given
        let view = HomeView(viewModel: HomeViewModelPreview.filtered)

        // When & Then
        assertSnapshot(view: view, test: #function)
    }

    func testHomeViewEmptySnapshot() {
        // Given
        let view = HomeView(viewModel: HomeViewModelPreview.empty)

        // When & Then
        assertSnapshot(view: view, test: #function)
    }

    func testHomeViewLoadingSnapshot() {
        // Given
        let view = HomeView(viewModel: HomeViewModelPreview.loading)

        // When & Then
        assertSnapshot(view: view, test: #function)
    }

    func testHomeViewGeneralErrorSnapshot() {
        // Given
        let view = HomeView(viewModel: HomeViewModelPreview.generalError)

        // When & Then
        assertSnapshot(view: view, test: #function)
    }

    func testHomeViewNoInternetErrorSnapshot() {
        // Given
        let view = HomeView(viewModel: HomeViewModelPreview.noInternet)

        // When & Then
        assertSnapshot(view: view, test: #function)
    }
}

private extension HomeViewSnapshotTests {
    func assertSnapshot<V: View>(view: V, test: String) {
        assertSnapshot(view: view, folder: #filePath, test: test, isRecording: isRecording)
    }
}
