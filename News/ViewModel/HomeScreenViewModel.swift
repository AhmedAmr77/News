//
//  HomeScreenViewModel.swift
//  News
//
//  Created by Ahmd Amr on 26/08/2021.
//  Copyright © 2021 ahmdamr. All rights reserved.
//

import Foundation
import RxSwift

class HomeScreenViewModel {
    
    private var networkService: NetworkService!
    
    private var newsSubject = PublishSubject<[Article]>()
    var newsObservable: Observable<[Article]>
    
    init() {
        networkService = NetworkService()
        newsObservable = newsSubject.asObservable()
    }

    func getNews() {
        networkService.getNews { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let news):
                guard let news = news else { return }
                if news.status == "ok" {
                    self.newsSubject.onNext(news.articles)
                } else {
                    print("sttus not ok")                  //showError
                }
            case .failure(let error):
                print(error.localizedDescription)          //showError
            }
        }
    }
    
    
}
