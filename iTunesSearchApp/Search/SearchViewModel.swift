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
    
    struct Input {
        let searchText:ControlProperty<String>
        let searchButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let searchList:Observable<[SearchResults]>
    }
    
    func transform(input: Input) -> Output {
        let searchList = PublishSubject<[SearchResults]>()
        input.searchButtonTap
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchText)
            .distinctUntilChanged()
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
        
        return Output(searchList: searchList)
    }
}
