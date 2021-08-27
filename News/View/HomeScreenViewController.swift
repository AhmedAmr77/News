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
    
    @IBOutlet weak private var newsTableView: UITableView!
    @IBOutlet weak private var noConnectionContainerView: UIView!
    @IBOutlet weak private var noItemContainerView: UIView!

    private var searchBar: UISearchBar!
    private var homeScreenViewModel: ViewModelProtocol!
    private var disposeBag: DisposeBag!
    private var activityView:UIActivityIndicatorView!
    private var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Initialization
        initView()
        initializeSearchBar()
        initializeSwipeToRefresh()
        
        //register cell nib file
        registerCell()
        
        //initialization
        homeScreenViewModel = HomeScreenViewModel()
        disposeBag = DisposeBag()
        activityView = UIActivityIndicatorView(style: .large)
        
        //setting delegate
        newsTableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        //bindingData from viewModel
        binding()
        
        //when item selected
        itemSelected()
        
        //listen while getting data
        subscribing()
        
        //get news
        homeScreenViewModel.getNews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //deselect selected cell
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

extension HomeScreenViewController {
    private func initView() {
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9176470588, green: 0.9176470588, blue: 0.9176470588, alpha: 1)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    private func registerCell() {
        let homeScreenNibCell = UINib(nibName: Constants.homeScreenNibCell, bundle: nil)
        newsTableView.register(homeScreenNibCell, forCellReuseIdentifier: Constants.homeScreenNibCell)
    }
    private func initializeSearchBar() {
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 20))
        let rightNavBarButton = UIBarButtonItem(customView:searchBar)
        navigationItem.rightBarButtonItem = rightNavBarButton
    }
    private func initializeSwipeToRefresh() {
        //swipe for view
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipe(_:)))
        swipe.direction = .down
        swipe.numberOfTouchesRequired = 1
        view.addGestureRecognizer(swipe)
        
        //swipe for table view
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing")
        refreshControl.addTarget(self, action: #selector(self.handleSwipe(_:)), for: .valueChanged)
        newsTableView.addSubview(refreshControl)
    }
    @objc func handleSwipe(_ sender: UITapGestureRecognizer? = nil) {
        homeScreenViewModel.getNews()
        refreshControl.endRefreshing()
    }
    private func binding() {
        homeScreenViewModel.newsObservable.bind(to: newsTableView.rx.items(cellIdentifier: Constants.homeScreenNibCell)){row, item, cell in
            let castedCell = cell as! CardTableViewCell
            castedCell.article = item
        }.disposed(by: disposeBag)
        searchBar.rx.text.orEmpty.distinctUntilChanged().bind(to: homeScreenViewModel.searchValue).disposed(by: disposeBag)
    }
    private func itemSelected() {
        newsTableView.rx.modelSelected(Article.self).subscribe(onNext: { [weak self] (article) in
            guard let self = self else { return }
            let detailsVC = self.storyboard?.instantiateViewController(identifier: Constants.detailsScreenVC) as! DetailsScreenViewController
            detailsVC.article = article
            self.navigationController?.pushViewController(detailsVC, animated: true)
        }).disposed(by: disposeBag)
    }
    private func subscribing() {
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
            self.showError(message: "\(message)\nPlease swipe down to refresh")
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
    }
    private func showError(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
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
