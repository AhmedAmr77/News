//
//  MockNetworkService.swift
//  NewsTests
//
//  Created by Ahmd Amr on 27/08/2021.
//  Copyright © 2021 ahmdamr. All rights reserved.
//

import Foundation
@testable import News

class MockNetworkService: NetworkServiceProtocol {
    
    var isGetNewsCalled = false
    var completionClosure: ((Result<News?, NSError>) -> Void)!
    
    func getNews(completion: @escaping (Result<News?, NSError>) -> Void) {
        isGetNewsCalled = true
        completionClosure = completion
    }
    
    func getSuccess() {
        completionClosure(.success(News(status: "ok", totalResults: 0, articles:[Article]())))
    }
    
    func getFail(error: NSError?) {
        completionClosure(.failure(error ?? NSError()))
    }
}
