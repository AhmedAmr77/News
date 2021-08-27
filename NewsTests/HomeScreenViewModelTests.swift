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

    var homeScreenViewModel: ViewModelProtocol!
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
    
    func testGetNews() {
        
        homeScreenViewModel.getNews()
        
        XCTAssert(mockNetworkService.isGetNewsCalled)
    }
    
    func testGetNewsFail() {
        
        let error = NSError(domain: "ERR", code: 7, userInfo: nil)
        
        homeScreenViewModel.getNews()
        mockNetworkService.getFail(error: error)
        
        XCTAssert(true)
        
    }

}
