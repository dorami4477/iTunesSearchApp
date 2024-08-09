//
//  KeywordsCollectionViewCell.swift
//  iTunesSearchApp
//
//  Created by 박다현 on 8/9/24.
//

import UIKit
import SnapKit

class KeywordsCollectionViewCell: UICollectionViewCell {
    static let id = "KeywordsCollectionViewCell"
    
    let titleLabel = {
        let label = UILabel()
        label.textAlignment = .center
     return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.cornerRadius = 5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
