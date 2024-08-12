//
//  BaseViewModel.swift
//  iTunesSearchApp
//
//  Created by 박다현 on 8/12/24.
//

import Foundation

protocol BaseViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
