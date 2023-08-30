//
//  StageCarouselCell.swift
//  GyeolHap
//
//  Created by JeongAh Hong on 2023/08/30.
//

import Foundation
import UIKit

class StageCarouselCell: UICollectionViewCell {
    static let identifier = "stageCarousel"
    var scrollAction: (() -> Void)?
    
    var stageLabel = UILabel(frame: .zero)
    var backgroundRectangleView = UIView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(index: Int) {
        stageLabel.text = index.description
        setConstraints()
    }
    
    func setConstraints() {
        addSubview(backgroundRectangleView)
        addSubview(stageLabel)
        stageLabel.translatesAutoresizingMaskIntoConstraints = false
        backgroundRectangleView.translatesAutoresizingMaskIntoConstraints = false
        backgroundRectangleView.layer.cornerRadius = 8
        backgroundRectangleView.layer.borderWidth = 2
        backgroundRectangleView.layer.borderColor = UIColor.black.cgColor
        
        NSLayoutConstraint.activate([
            backgroundRectangleView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundRectangleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            backgroundRectangleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundRectangleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundRectangleView.heightAnchor.constraint(equalToConstant: 40),
            backgroundRectangleView.widthAnchor.constraint(equalToConstant: 80),
            stageLabel.centerYAnchor.constraint(equalTo: backgroundRectangleView.centerYAnchor),
            stageLabel.centerXAnchor.constraint(equalTo: backgroundRectangleView.centerXAnchor)
        ])
    }
}
