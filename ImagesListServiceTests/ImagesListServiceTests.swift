//
//  ImagesListServiceTests.swift
//  ImagesListServiceTests
//
//  Created by Эльдар Айдумов on 31.08.2023.
//

@testable import ImageFeed
import XCTest

final class ImagesListServiceTests: XCTestCase {

    func testImagesListService() throws {
        let service = ImagesListService.shared

        let expectation = self.expectation(description: "Wait for notification")
        NotificationCenter.default.addObserver(forName: ImagesListService.didChangeNotification,
                                               object: nil,
                                               queue: .main,
                                               using: { _ in expectation.fulfill() })

        service.fetchPhotosNextPage()
        wait(for: [expectation], timeout: 10)

        XCTAssertEqual(service.photos.count, 10)
    }
}
