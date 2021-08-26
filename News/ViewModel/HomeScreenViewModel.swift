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
    
    private var newsSubject = PublishSubject<News>()
    var newsObservable: Observable<News>
    
    init() {
        networkService = NetworkService()
        newsObservable = newsSubject.asObservable()
    }

    func getNews() {
        networkService.getNews { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let news):
                if let news = news {
                    self.newsSubject.onNext(news)
                } else {
                    print("errorrrrr")                  //showError
                }
            case .failure(let error):
                print(error.localizedDescription)       //showError
            }
        }
    }
    
    
}
