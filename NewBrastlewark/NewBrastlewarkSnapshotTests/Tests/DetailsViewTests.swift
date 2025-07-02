import XCTest
import SwiftUI
import SnapshotTesting

@testable import Presentation

@MainActor
final class DetailsViewSnapshotTests: XCTestCase {
    private let isRecording = false

    func testDetailsViewReadySnapshot() {
        // Given
        let view = DetailsView(viewModel: DetailsViewModelPreview.ready)

        // When & Then
        assertSnapshot(view: view, test: #function)
    }

    func testDetailsViewNoFriendsSnapshot() {
        // Given
        let view = DetailsView(viewModel: DetailsViewModelPreview.noFriends)

        // When & Then
        assertSnapshot(view: view, test: #function)
    }
    
    func testDetailsViewWithHomeButtonSnapshot() {
        // Given
        let view = DetailsView(showHome: true, viewModel: DetailsViewModelPreview.ready)

        // When & Then
        assertSnapshot(view: view, test: #function)
    }
}

private extension DetailsViewSnapshotTests {
    func assertSnapshot<V: View>(view: V, test: String) {
        assertSnapshot(view: view, folder: #filePath, test: test, isRecording: isRecording)
    }
}