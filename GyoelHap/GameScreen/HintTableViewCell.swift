//
//  HintTableViewCell.swift
//  GyeolHap
//
//  Created by terry.yes on 2023/10/31.
//

import UIKit

class HintTableViewCell: UITableViewCell {
    lazy var imageView1: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    lazy var imageView2: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    lazy var imageView3: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()
    lazy var symbolImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //Add label for new class
        setUpContentView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bindData(image1: UIImage, image2: UIImage, image3: UIImage, labelText: String, symbolImage: UIImage) {
        imageView1.image = image1
        imageView2.image = image2
        imageView3.image = image3
        label.text = labelText
        symbolImageView.image = symbolImage
//        let config = UIImage.SymbolConfiguration(hierarchicalColor: [.systemTeal]).preferringMulticolor()
//        symbolImageView.image = symbolImage.applyingSymbolConfiguration(config)
    }

    private func setUpContentView() {
//        self.separatorInset = .zero
//        self.layoutMargins = .zero
        contentView.backgroundColor = .white
        contentView.layer.masksToBounds = true

        contentView.addSubview(imageView1)
        imageView1.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
            make.height.equalToSuperview().offset(-10)
            make.width.equalTo(imageView1.snp.height)
        }
        contentView.addSubview(imageView2)
        imageView2.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalTo(imageView1.snp.trailing).offset(5)
            make.height.equalTo(imageView1.snp.height)
            make.width.equalTo(imageView2.snp.height)
        }
        contentView.addSubview(imageView3)
        imageView3.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalTo(imageView2.snp.trailing).offset(5)
            make.height.equalTo(imageView1.snp.height)
            make.width.equalTo(imageView3.snp.height)
        }
        contentView.addSubview(symbolImageView)
        symbolImageView.snp.makeConstraints { (make) in
        make.centerY.equalToSuperview()
            make.leading.equalTo(imageView3.snp.trailing).offset(5)
            make.height.width.equalTo(35)
        }
        contentView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.leading.equalTo(symbolImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-5)
            make.height.equalTo(30)
        }
    }
    
}
