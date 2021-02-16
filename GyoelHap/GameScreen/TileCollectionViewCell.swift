//
//  TileCollectionViewCell.swift
//  GyeolHap
//
//  Created by Terry Lee on 2021/02/03.
//

import UIKit

class TileCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var tileNumber: UILabel!
    @IBOutlet weak var tileImage: UIImageView!
    @IBOutlet weak var tileButton: UIButton!
    
//    var tapHandler: ((AVPlayerItem) -> Void)?
    var tapHandler: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateUI(index: Int, item: Int) {
        tileNumber.text = String(index + 1)
        tileImage.image = UIImage(named: "tile\(item)")
        tileImage.layer.cornerRadius = 10
        tileImage.layer.borderColor = CGColor.init(red: 178/255, green: 80/255, blue: 255/255, alpha: 1)
        
    }

    @IBAction func cardTapped(_ sender: UIButton) {
        //TODO: 탭했을 때 처리
        tapHandler?()
        tileImage.layer.borderWidth = 5
        
    }
}
