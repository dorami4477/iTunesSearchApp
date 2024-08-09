//
//  SearchViewModel.swift
//  iTunesSearchApp
//
//  Created by 박다현 on 8/8/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchViewModel {
    let disposeBag = DisposeBag()
    var searchTerms:[String] = UserDefaultsManager.searchTerms
    
    struct Input {
        let searchText:ControlProperty<String>
        let searchButtonTap: ControlEvent<Void>
        let modelSeleted: ControlEvent<SearchResults>
    }
    
    struct Output {
        let searchList:Observable<[SearchResults]>
        let modelSeleted: ControlEvent<SearchResults>
        let keywords:Observable<[String]>
    }
    
    func transform(input: Input) -> Output {
        let searchList = PublishSubject<[SearchResults]>()
        let keywords = BehaviorSubject(value: searchTerms)
        
        let searchTerm = input.searchButtonTap
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchText)
            .distinctUntilChanged()
            .share()
        
        searchTerm
            .flatMap{ value in
                NetworkManager.shared.callRequest(query: value)
            }
            .subscribe(with: self, onNext: { owner, value in
                searchList.onNext(value.results)
            }, onError: { owner, error in
                print(error)
            }, onCompleted: { owner in
                print("onCompleted")
            }, onDisposed: { owner in
                print("onDisposed")
            })
            .disposed(by: disposeBag)
        
        searchTerm
            .subscribe(with: self) { owner, value in
                owner.searchTerms.removeAll { $0 == value }
                owner.searchTerms.insert(value, at: 0)
                UserDefaultsManager.searchTerms = owner.searchTerms
                keywords.onNext(owner.searchTerms)
            }
            .disposed(by: disposeBag)
        
        return Output(searchList: searchList, modelSeleted: input.modelSeleted, keywords: keywords)
    }
}
