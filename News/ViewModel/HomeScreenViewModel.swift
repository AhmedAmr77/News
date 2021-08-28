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

protocol ViewModelProtocol {
    var newsObservable: Observable<[Article]>{ get }
    var searchValue: BehaviorRelay<String>{ get }
    var connectivityObservable: Observable <Bool>{ get }
    var errorObservable: Observable<String>{ get }
    var loadingObservable: Observable<Bool>{ get }
    var noItemObservable: Observable<Bool>{ get }
    func getNews()
}

class HomeScreenViewModel: ViewModelProtocol {
    
    private let networkService: NetworkServiceProtocol!
    private let disposeBag = DisposeBag()

    private var newsSubject = PublishSubject<[Article]>()
    var newsObservable: Observable<[Article]>
    
    private lazy var searchValueObservable: Observable<String> = searchValue.asObservable()
    var searchValue: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    var articles: [Article]!
    private var searchedData: [Article]!
    
    private var connectivitySubject = PublishSubject<Bool>()
    private var errorSubject = PublishSubject<String>()
    private var loadingSubject = PublishSubject<Bool>()
    private var noItemSubject = PublishSubject<Bool>()
    var connectivityObservable: Observable<Bool>
    var errorObservable: Observable<String>
    var loadingObservable: Observable<Bool>
    var noItemObservable: Observable<Bool>
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
        newsObservable = newsSubject.asObservable()
        searchedData = articles
        
        noItemObservable = noItemSubject.asObservable()
        errorObservable = errorSubject.asObservable()
        loadingObservable = loadingSubject.asObservable()
        connectivityObservable = connectivitySubject.asObservable()
        
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
    
    private func checkConnectivity() -> Bool {
        if(Connectivity.isConnectedToInternet){
            return true
        }
        return false
    }

    func getNews() {
        if checkConnectivity() {
            connectivitySubject.onNext(true)
            loadingSubject.onNext(true)
            networkService.getNews { [weak self] (result) in
                guard let self = self else { return }
                switch result {
                case .success(let news):
                    guard let news = news else { return }
                    if news.status == "ok" {
                        if news.articles.count > 0 {
                            self.articles = news.articles
                            self.noItemSubject.onNext(false)
                            self.newsSubject.onNext(news.articles)
                        } else {
                            self.noItemSubject.onNext(true)
                        }
                    } else {
                        self.errorSubject.onNext("Status NOT ok")
                    }
                case .failure(let error):
                    self.errorSubject.onNext(error.localizedDescription)
                }
                self.loadingSubject.onNext(false)
            }
        } else {
            connectivitySubject.onNext(false)
        }
    }
}
