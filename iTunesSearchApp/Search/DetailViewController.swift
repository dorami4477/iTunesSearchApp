//
//  DetailViewController.swift
//  iTunesSearchApp
//
//  Created by 박다현 on 8/8/24.
//

import UIKit
import SnapKit
import Kingfisher

class DetailViewController: BaseViewController {

    var data:SearchResults?
    
    let mainImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let titleLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 19, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    let artistLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .darkGray
        return label
    }()
    
    let descriptionLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureHierarchy() {
        view.addSubview(mainImageView)
        view.addSubview(titleLabel)
        view.addSubview(artistLabel)
        view.addSubview(descriptionLabel)
    }
    
    override func configureLayout() {
        mainImageView.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.size.equalTo(100)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.leading.equalTo(mainImageView.snp.trailing).offset(10)
        }
        artistLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.equalTo(mainImageView.snp.trailing).offset(10)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(mainImageView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
    override func configureView() {
        let url = URL(string:data?.artworkUrl100 ?? "")
        mainImageView.kf.setImage(with: url)
        titleLabel.text = data?.collectionName
        artistLabel.text = data?.artistName
        if let description = data?.longDescription {
            descriptionLabel.text = description
        } else {
            descriptionLabel.text = data?.shortDescription
        }
    }

}
