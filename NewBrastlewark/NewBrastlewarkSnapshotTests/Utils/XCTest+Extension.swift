import SnapshotTesting
import SwiftUI
import XCTest

extension XCTestCase {
  func assertSnapshot<V: View>(view: V, folder: StaticString, test: String, isRecording: Bool) {
    let navigationView = NavigationStack {
      view
    }

    let hostingController = UIHostingController(rootView: navigationView)
    SnapshotTesting.assertSnapshot(
      of: hostingController,
      as: .image(on: .iPhone13Pro),
      record: isRecording ? .all : .missing,
      file: folder,
      testName: test
    )
  }
}
