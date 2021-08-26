//
//  HomeScreenViewModel.swift
//  News
//
//  Created by Ahmd Amr on 26/08/2021.
//  Copyright © 2021 ahmdamr. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class HomeScreenViewModel {
    
    private var networkService: NetworkService!
    private var disposeBag = DisposeBag()

    private var newsSubject = PublishSubject<[Article]>()
    var newsObservable: Observable<[Article]>
    
    private lazy var searchValueObservable: Observable<String> = searchValue.asObservable()
    var searchValue: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    private var articles: [Article]!
    private var searchedData: [Article]!

    init() {
        networkService = NetworkService()
        newsObservable = newsSubject.asObservable()
        searchedData = articles
        
        searchValueObservable.subscribe(onNext: { [weak self] (value) in
            guard let self = self else { return }
            self.searchedData = self.articles?.filter({ (article) -> Bool in
                article.title.lowercased().contains(value.lowercased())
            })
            if (value.isEmpty) {
                self.searchedData = self.articles
            }
            self.newsSubject.onNext(self.searchedData ?? [])
        }).disposed(by: disposeBag)
    }

    func getNews() {
        networkService.getNews { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let news):
                guard let news = news else { return }
                if news.status == "ok" {
                    self.articles = news.articles
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
