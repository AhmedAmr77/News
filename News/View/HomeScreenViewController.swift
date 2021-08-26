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
    
    @IBOutlet weak var newsTableView: UITableView!
    
    private var searchBar: UISearchBar!
    
    private var homeScreenViewModel: HomeScreenViewModel!
    private var disposeBag: DisposeBag!
    private var activityView:UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add search bar to navigation bar
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9176470588, green: 0.9176470588, blue: 0.9176470588, alpha: 1)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()

        
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 20))
        let rightNavBarButton = UIBarButtonItem(customView:searchBar)
        navigationItem.rightBarButtonItem = rightNavBarButton
                
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
        searchBar.rx.text.orEmpty.distinctUntilChanged().bind(to: homeScreenViewModel.searchValue).disposed(by: disposeBag)
        
        //when item selected
        newsTableView.rx.modelSelected(Article.self).subscribe(onNext: { [weak self] (article) in
            guard let self = self else { return }
            let detailsVC = self.storyboard?.instantiateViewController(identifier: Constants.detailsScreenVC) as! DetailsScreenViewController
            detailsVC.article = article
            self.navigationController?.pushViewController(detailsVC, animated: true)
        }).disposed(by: disposeBag)
        
        
        homeScreenViewModel.getNews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let indexPathForSelectedRow = newsTableView.indexPathForSelectedRow {
            newsTableView.deselectRow(at: indexPathForSelectedRow, animated: animated)
        }
    }
}

extension HomeScreenViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 1.75
    }
}
