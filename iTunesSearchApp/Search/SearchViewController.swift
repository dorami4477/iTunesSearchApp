//
//  SearchViewController.swift
//  iTunesSearchApp
//
//  Created by 박다현 on 8/8/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

class SearchViewController: BaseViewController {

    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    private let tableView = UITableView()
    let viewModel = SearchViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        bind()
    }
    
    func bind() {
        guard let searchbar = navigationItem.searchController?.searchBar else { return }
        let input = SearchViewModel.Input(searchText: searchbar.rx.text.orEmpty,
                                          searchButtonTap: searchbar.rx.searchButtonClicked, 
                                          modelSeleted: tableView.rx.modelSelected(SearchResults.self))
        let output = viewModel.transform(input: input)
        
        output.searchList
            .bind(to: tableView.rx.items(cellIdentifier: SearchTableViewCell.identifier, cellType: SearchTableViewCell.self)) { row, element, cell in
                cell.appNameLabel.text = element.collectionName
                let url = URL(string: element.artworkUrl100 ?? "")
                cell.appIconImageView.kf.setImage(with: url)
            }
            .disposed(by: disposeBag)
        
        output.modelSeleted
            .bind(with: self) { owner, value in
                let detailVC = DetailViewController()
                detailVC.data = value
                owner.navigationController?.pushViewController(detailVC, animated: true)
            }
            .disposed(by: disposeBag)
        
    }

    override func configureNavigation() {
        title = "검색"
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "게임, 앱, 스토리 등"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func configureHierarchy() {
        view.addSubview(tableView)
        view.addSubview(collectionView)
    }
    
    override func configureLayout() {
        tableView.rowHeight = 100
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        collectionView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
    }
    
    func layout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 50)
        layout.scrollDirection = .horizontal
        return layout
    }
}

