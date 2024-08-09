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
        
        output.keywords
            .bind(to: collectionView.rx.items(cellIdentifier: KeywordsCollectionViewCell.id, cellType: KeywordsCollectionViewCell.self)){ item, element, cell in
                cell.titleLabel.text = element
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
        collectionView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        tableView.rowHeight = 100
        collectionView.register(KeywordsCollectionViewCell.self, forCellWithReuseIdentifier: KeywordsCollectionViewCell.id)
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
    }
    
    func layout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 44)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        return layout
    }
}

