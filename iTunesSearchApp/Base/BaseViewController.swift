//
//  BaseViewController.swift
//  iTunesSearchApp
//
//  Created by 박다현 on 8/8/24.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureHierarchy()
        configureLayout()
        configureView()
        configureNavigation()
    }
    
    func configureHierarchy() {}
    
    func configureLayout() {}
    
    func configureView() {}
    
    func configureNavigation() {}



}
