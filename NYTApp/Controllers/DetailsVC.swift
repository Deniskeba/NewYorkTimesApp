//
//  DetailsVC.swift
//  NYTApp
//
//  Created by Denis Kobylkov on 18.05.2023.
//

import UIKit
import SnapKit

class DetailsVC: UIViewController {
    
    
    //MARK: - Components of UI
    let imageView: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .systemRed
        return image
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text          = "titleLabel"
        label.font          = .systemFont(ofSize: 30, weight: .heavy)
        label.textAlignment = .center
        label.numberOfLines = 4
        return label
    }()
    let authorLabel: UILabel = {
        let label = UILabel()
        label.text          = "authorLabel"
        label.numberOfLines = 3
        return label
    }()
    let dateLabel: UILabel = {
        let label   = UILabel()
        label.text  = "dateLabel"
        return label
    }()
    
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
    }
    
    
    //MARK: setup UI
    func setupUI() {
        view.backgroundColor = .white
        view.addSubview(imageView)
        imageView.snp.makeConstraints{ make in
            make.width.equalToSuperview()
            make.height.equalTo(view.frame.size.height/3)
        }
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints{ make in
            make.top.equalTo(imageView.snp.bottom).inset(-10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
        }
        view.addSubview(authorLabel)
        authorLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-20)
            make.width.equalToSuperview()
        }
        view.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(authorLabel.snp.bottom).inset(-20)
            make.width.equalToSuperview()
        }

    }
}

