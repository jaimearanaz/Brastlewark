import XCTest
import SwiftUI
import SnapshotTesting

@testable import Presentation

@MainActor
final class FilterViewSnapshotTests: XCTestCase {
    private let isRecording = false

    func testFilterViewNoFilterActiveSnapshot() {
        // Given
        let view = FilterView(viewModel: FilterViewModelPreview.noFilterActive)

        // When & Then
        assertSnapshot(view: view, test: #function)
    }

    func testFilterViewFilterActiveSnapshot() {
        // Given
        let view = FilterView(viewModel: FilterViewModelPreview.filterActive)

        // When & Then
        assertSnapshot(view: view, test: #function)
    }
}

private extension FilterViewSnapshotTests {
    func assertSnapshot<V: View>(view: V, test: String) {
        assertSnapshot(view: view, folder: #filePath, test: test, isRecording: isRecording)
    }
}
