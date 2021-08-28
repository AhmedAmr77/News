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
    
    var mockError: NSError?
    var isGetNewsCalled = false
    var completionClosure: ((Result<News?, NSError>) -> Void)!
    
    var completeNews: News = News(status: "ok", totalResults: 1, articles: [Article]())
    
    func getNews(completion: @escaping (Result<News?, NSError>) -> Void) {
        isGetNewsCalled = true
        completionClosure = completion
    }
    
    func getSuccess() {
        completionClosure(.success(completeNews))
    }
    
    func getFail() {
        mockError = NSError(domain: "MockError", code: 101, userInfo: nil)
        completionClosure(.failure(mockError!))
    }
}

class StubGenerator {
    func stubNews(jsonContent: JsonContent) -> News {
        let path = Bundle(for: NewsTests.self).path(forResource: jsonContent.rawValue, ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let news = try! decoder.decode(News.self, from: data)
        return news
    }
}
enum JsonContent: String {
    case content
    case contentStatusError
    case contentNoItems
}
