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
    @IBOutlet weak var noConnectionContainerView: UIView!
    @IBOutlet weak var noItemContainerView: UIView!

    private var searchBar: UISearchBar!

    private var homeScreenViewModel: ViewModelProtocol!
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

        //swipe to refresh
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipe(_:)))
        swipe.direction = .down
        swipe.numberOfTouchesRequired = 1
        noConnectionContainerView.addGestureRecognizer(swipe)
        
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
        
        //listen while getting data
        homeScreenViewModel.connectivityObservable.subscribe(onNext: {[weak self] (boolValue) in
            guard let self = self else { return }
                switch boolValue{
                case true:
                    self.noConnectionContainerView.isHidden = true
                    print("connectivityObservable true")
                case false:
                    self.noConnectionContainerView.isHidden = false
                    print("connectivityObservable false")
                }
        }).disposed(by: disposeBag)
        
        homeScreenViewModel.errorObservable.subscribe(onNext: {[weak self] (message) in
            guard let self = self else { return }
            self.showError(message: message)
        }).disposed(by: disposeBag)
        
        homeScreenViewModel.noItemObservable.subscribe(onNext: {[weak self] (boolValue) in
            guard let self = self else { return }
            switch boolValue{
            case true:
                self.noItemContainerView.isHidden = false
                print("noItemContainerView true")
            case false:
                self.noItemContainerView.isHidden = true
                print("noItemContainerView false")
            }
        }).disposed(by: disposeBag)
        
        homeScreenViewModel.loadingObservable.subscribe(onNext: {[weak self] (boolValue) in
            guard let self = self else { return }
            switch boolValue{
            case true:
                self.showLoading()
            case false:
                self.hideLoading()
            }
        }).disposed(by: disposeBag)
        
        homeScreenViewModel.getNews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let indexPathForSelectedRow = newsTableView.indexPathForSelectedRow {
            newsTableView.deselectRow(at: indexPathForSelectedRow, animated: animated)
        }
    }
    
    @objc func handleSwipe(_ sender: UITapGestureRecognizer? = nil) {
        homeScreenViewModel.getNews()
    }
    
    private func showError(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    }
    
    private func showLoading() {
        activityView!.center = self.view.center
        self.view.addSubview(activityView!)
        activityView!.startAnimating()
    }
    
    private func hideLoading() {
        activityView!.stopAnimating()
    }
}

extension HomeScreenViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 1.75
    }
}
