import XCTest
import SwiftUI
import SnapshotTesting

@testable import Presentation

@MainActor
final class HomeViewSnapshotTests: XCTestCase {
    func testHomeViewFullSnapshot() {
        // Given
        let view = HomeView(viewModel: HomeViewModelPreview.full)
        let navigationView = NavigationStack {
            view
        }

        // When & Then
        let hostingController = UIHostingController(rootView: navigationView)
        assertSnapshot(of: hostingController, as: .image(on: .iPhone13Pro), named: "full")
    }

    func testHomeViewNotFullSnapshot() {
        // Given
        let view = HomeView(viewModel: HomeViewModelPreview.notFull)
        let navigationView = NavigationStack {
            view
        }

        // When & Then
        let hostingController = UIHostingController(rootView: navigationView)
        assertSnapshot(of: hostingController, as: .image(on: .iPhone13Pro), named: "notFull")
    }

    func testHomeViewFilteredSnapshot() {
        // Given
        let view = HomeView(viewModel: HomeViewModelPreview.notFull)
        let navigationView = NavigationStack {
            view
        }

        // When & Then
        let hostingController = UIHostingController(rootView: navigationView)
        assertSnapshot(of: hostingController, as: .image(on: .iPhone13Pro), named: "filtered")
    }

    func testHomeViewEmptySnapshot() {
        // Given
        let view = HomeView(viewModel: HomeViewModelPreview.empty)
        let navigationView = NavigationStack {
            view
        }

        // When & Then
        let hostingController = UIHostingController(rootView: navigationView)
        assertSnapshot(of: hostingController, as: .image(on: .iPhone13Pro), named: "empty")
    }

    func testHomeViewLoadingSnapshot() {
        // Given
        let view = HomeView(viewModel: HomeViewModelPreview.loading)
        let navigationView = NavigationStack {
            view
        }

        // When & Then
        let hostingController = UIHostingController(rootView: navigationView)
        assertSnapshot(of: hostingController, as: .image(on: .iPhone13Pro), named: "loading")
    }

    func testHomeViewGeneralErrorSnapshot() {
        // Given
        let view = HomeView(viewModel: HomeViewModelPreview.generalError)
        let navigationView = NavigationStack {
            view
        }

        // When & Then
        let hostingController = UIHostingController(rootView: navigationView)
        assertSnapshot(of: hostingController, as: .image(on: .iPhone13Pro), named: "generalError")
    }

    func testHomeViewNoInternetErrorSnapshot() {
        // Given
        let view = HomeView(viewModel: HomeViewModelPreview.noInternet)
        let navigationView = NavigationStack {
            view
        }

        // When & Then
        let hostingController = UIHostingController(rootView: navigationView)
        assertSnapshot(of: hostingController, as: .image(on: .iPhone13Pro), named: "generalError")
    }
}
