//
//  CustomTableViewCell.swift
//  NYTApp
//
//  Created by Denis Kobylkov on 16.05.2023.
//

import Foundation
import UIKit
import SnapKit



class CustomTableViewCell: UITableViewCell {
    
    

    
    var didTapFavoriteClosure: (() -> ())?
    var appNews: [AppNew] = []
    
    //MARK: - Components of Cell
    let heartButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.tintColor = .systemGray
        button.layer.zPosition = 1
        return button
    }()
    let myImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemBlue
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        label.text = ""
        label.numberOfLines = 2
        return label
    }()
    var captionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: .regular)
        return label
    }()
    var sectionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 15, weight: .light)
        label.text = ""
        return label
    }()
    
    

    
    
    
    
    //MARK: - initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    
    //MARK: - Setup UI
    func setupUI() {
        self.contentView.addSubview(heartButton)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(myImageView)
        self.contentView.addSubview(captionLabel)
        self.contentView.addSubview(sectionLabel)
        
        myImageView.snp.makeConstraints{ make in
            make.leading.equalTo(self.contentView.layoutMarginsGuide.snp.leading)
            make.top.equalTo(self.contentView.layoutMarginsGuide.snp.top)
            make.bottom.equalTo(self.contentView.layoutMarginsGuide.snp.bottom)
            make.width.equalTo(90)
            make.height.equalTo(90)
        }
        titleLabel.snp.makeConstraints{ make in
            make.leading.equalTo(myImageView.snp.trailing).inset(-16)
            make.top.equalTo(myImageView.snp.top)
            make.width.equalTo(contentView.frame.size.width/1.2)

        }
        captionLabel.snp.makeConstraints{ make in
            make.leading.equalTo(myImageView.snp.trailing).inset(-16)
            make.top.equalTo(titleLabel.snp.bottom).inset(-5)

        }
        sectionLabel.snp.makeConstraints{ make in
            make.top.equalTo(contentView.snp.bottom).inset(30)
            make.right.equalTo(contentView.snp.right).inset(10)
        }
        heartButton.snp.makeConstraints{ make in
            make.top.equalTo(myImageView.snp.top).inset(-5)
            make.left.equalTo(myImageView.snp.left).inset(-5)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        heartButton.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
        
    }
    @objc func tapButton() {
        if heartButton.tag == 0 {
            heartButton.tintColor = .systemRed
            didTapFavoriteClosure?()
            heartButton.tag = 1
        } else {
            heartButton.tintColor = .systemGray
            heartButton.tag = 0
        }
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
 
    
}

