//
//  ImagesListTests.swift
//  ImageFeedTests
//
//  Created by Эльдар Айдумов on 18.09.2023.
//

import XCTest
@testable import ImageFeed

final class ImagesListTests: XCTestCase {
    func testPresenterCallsAlertShow() {
        //Given
        let tableView = UITableView()
        let cell = ImagesListCell()
        let indexPath = tableView.indexPath(for: cell)
        
        guard let indexPath else { return }
        
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListPresenter()
        viewController.presenter = presenter
        presenter.viewController = viewController
        
        //When
        presenter.changeLike(indexPath: indexPath, cell: cell)
        
        //Then
        XCTAssertTrue(viewController.alertIsCalled)
    }
    
    func testViewControllerCallsUpdateAnimated() {
        //Given
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        viewController.configure(presenter)
        
        //When
        viewController.updateImagesList()
        
        //Then
        XCTAssertTrue(presenter.updateIsCalled)
    }
    
    func testViewControllerCallsChangeLike() {
        //Given
        let tableView = UITableView()
        let cell = ImagesListCell()
        let indexPath = tableView.indexPath(for: cell)
        
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        viewController.configure(presenter)
        
        //When
        guard indexPath != nil else { return }
        viewController.imagesListCellDidTapLike(cell)
        
        //Then
        XCTAssertTrue(presenter.changeLike)
    }
    
    func testFetchPhotosMethod() {
        //Given
        let tableView = UITableView()
        let cell = ImagesListCell()
        let indexPath = IndexPath()
        
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        viewController.configure(presenter)
        
        //When
        viewController.tableView(tableView, willDisplay: cell, forRowAt: indexPath)
        
        //Then
        XCTAssertTrue(presenter.fetchIsCalled)
    }
    
}
