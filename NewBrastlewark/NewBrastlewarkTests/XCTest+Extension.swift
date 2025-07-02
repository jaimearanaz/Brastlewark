import XCTest
import SwiftUI
import SnapshotTesting

extension XCTestCase {
    func assertSnapshot<V: View>(view: V, folder: StaticString, test: String, isRecording: Bool) {
        let navigationView = NavigationStack {
            view
        }

        let hostingController = UIHostingController(rootView: navigationView)
        SnapshotTesting.assertSnapshot(of: hostingController, as: .image(on: .iPhone13Pro), record: isRecording, file: folder, testName: test)
    }
}
