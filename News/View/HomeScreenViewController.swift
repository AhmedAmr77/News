//
//  HomeScreenViewController.swift
//  News
//
//  Created by Ahmd Amr on 26/08/2021.
//  Copyright © 2021 ahmdamr. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HomeScreenViewController: UIViewController {
    
    @IBOutlet weak private var searchBar: UISearchBar!
    @IBOutlet weak var newsTableView: UITableView!
    
    private var homeScreenViewModel: HomeScreenViewModel!
    private var disposeBag: DisposeBag!
    private var activityView:UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //register cell nib file
        let homeScreenNibCell = UINib(nibName: Constants.homeScreenNibCell, bundle: nil)
        newsTableView.register(homeScreenNibCell, forCellReuseIdentifier: Constants.homeScreenNibCell)
        
        //initialization
        homeScreenViewModel = HomeScreenViewModel()
        disposeBag = DisposeBag()
        activityView = UIActivityIndicatorView(style: .large)

        //setting delegate
        newsTableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        //bindingData from viewModel
        homeScreenViewModel.newsObservable.bind(to: newsTableView.rx.items(cellIdentifier: Constants.homeScreenNibCell)){row, item, cell in
            let castedCell = cell as! CardTableViewCell
            castedCell.article = item
        }.disposed(by: disposeBag)
        
        //when item selected
        newsTableView.rx.modelSelected(Article.self).subscribe(onNext: { [weak self] (article) in
            guard let self = self else { return }
            let detailsVC = self.storyboard?.instantiateViewController(identifier: Constants.detailsScreenVC) as! DetailsScreenViewController
            detailsVC.article = article
            self.navigationController?.pushViewController(detailsVC, animated: true)
        }).disposed(by: disposeBag)
        
        
        homeScreenViewModel.getNews()
    }
}

extension HomeScreenViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 1.75
    }
}
