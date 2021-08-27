//
//  NetworkServiceTests.swift
//  NewsTests
//
//  Created by Ahmd Amr on 27/08/2021.
//  Copyright © 2021 ahmdamr. All rights reserved.
//

import XCTest
@testable import News

class NetworkServiceTests: XCTestCase {

    var networkService: NetworkService?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        networkService = NetworkService()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        networkService = nil
    }
    
    func testGetNews() {

        let expect = XCTestExpectation(description: "callback")
        
        networkService?.getNews { (result) in
            expect.fulfill()
            switch result {
            case .success(let news):
                if let news = news {
                    XCTAssertGreaterThan(news.articles.count, 0)
                    for i in 0..<news.articles.count {
                        XCTAssertNotNil(news.articles[i].title)
                    }
                }
            case .failure(_):
                XCTFail()
            }
        }
        wait(for: [expect], timeout: 2)
    }

}
