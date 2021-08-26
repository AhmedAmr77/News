//
//  NetworkService.swift
//  News
//
//  Created by Ahmd Amr on 26/08/2021.
//  Copyright © 2021 ahmdamr. All rights reserved.
//

import Foundation
import Alamofire

class NetworkService {
    func getNews(completion: @escaping (Result<News?, NSError>) -> Void) {
        AF.request(Constants.newsURL)
            .validate()
            .responseJSON(completionHandler: { (response) in
                guard let statusCode = response.response?.statusCode else {
                    //add custom Error
                    let error = NSError(domain: Constants.newsURL, code: 0, userInfo: [NSLocalizedDescriptionKey: Constants.NetworkServiceErrorMessage])
                    print("at guard statusCode")
                    completion(.failure(error))
                    return
                }
                if statusCode == 200 {
                    //successful request
                    guard let jsonResponse = try? response.result.get() else {
                        //add custom Error
                        let error = NSError(domain: Constants.newsURL, code: 0, userInfo: [NSLocalizedDescriptionKey: Constants.NetworkServiceErrorMessage])
                        print("at jsonResponse")
                        completion(.failure(error))
                        return
                    }
                    guard let theJsonData = try? JSONSerialization.data(withJSONObject: jsonResponse, options: []) else {
                        //add custom Error
                        let error = NSError(domain: Constants.newsURL, code: 0, userInfo: [NSLocalizedDescriptionKey: Constants.NetworkServiceErrorMessage])
                        print("at jsonData error")
                        completion(.failure(error))
                        return
                    }
                    guard let responseObject = try? JSONDecoder().decode(News.self, from: theJsonData) else {
                        //add custom Error
                        let error = NSError(domain: Constants.newsURL, code: 0, userInfo: [NSLocalizedDescriptionKey: Constants.NetworkServiceErrorMessage])
                        print("at responseObject, error on parsing")
                        completion(.failure(error))
                        return
                    }
                    print("success API Call")
                    completion(.success(responseObject))
                }else{
                    //add error depending on statusCode
                    let message = "Error Message Parsed From Server"
                    let error = NSError(domain: Constants.newsURL, code: 0, userInfo: [NSLocalizedDescriptionKey: message])
                    print(error)
                    completion(.failure(error))
                }
            })
    }
}
