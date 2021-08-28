//
//  HomeScreenViewModelTests.swift
//  NewsTests
//
//  Created by Ahmd Amr on 27/08/2021.
//  Copyright © 2021 ahmdamr. All rights reserved.
//

import XCTest
@testable import News

class HomeScreenViewModelTests: XCTestCase {
    
    var homeScreenViewModel: HomeScreenViewModel!
    var mockNetworkService: MockNetworkService!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockNetworkService = MockNetworkService()
        homeScreenViewModel = HomeScreenViewModel(networkService: mockNetworkService)
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        mockNetworkService = nil
        homeScreenViewModel = nil
    }
    
    func testGetNewsSuccess() {
        
        homeScreenViewModel.getNews()
        
        XCTAssert(mockNetworkService.isGetNewsCalled)
    }
    
    func testGetNewsFail() {
                
        homeScreenViewModel.getNews()
        mockNetworkService.getFail()
        
        XCTAssertNil(homeScreenViewModel.articles)
        XCTAssertNotNil(mockNetworkService.mockError)
    }
    
    func testOkStatus() {
        // Given
        let news = StubGenerator().stubNews(jsonContent: .content)
        mockNetworkService.completeNews = news
        
        // When
        homeScreenViewModel.getNews()
        mockNetworkService.getSuccess()
        
        XCTAssertNotNil(homeScreenViewModel.articles)
    }
    
    func testErrorStatus() {
        // Given
        let news = StubGenerator().stubNews(jsonContent: .contentStatusError)
        mockNetworkService.completeNews = news
        
        // When
        homeScreenViewModel.getNews()
        mockNetworkService.getSuccess()
        
        XCTAssertNil(homeScreenViewModel.articles)
    }
    
    func testNoItems() {
        // Given
        let news = StubGenerator().stubNews(jsonContent: .contentNoItems)
        mockNetworkService.completeNews = news
        
        // When
        homeScreenViewModel.getNews()
        mockNetworkService.getSuccess()
        
        XCTAssertNil(homeScreenViewModel.articles)
    }
    
}
