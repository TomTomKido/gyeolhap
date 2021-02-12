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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tileImage.layer.cornerRadius = 4

    }
    
    func updateUI(index: Int){
        tileNumber.text = String(index + 1)
//        tileNumber.text = "hi"
        tileImage.image = UIImage(named: "tile0")
    }

    @IBAction func cardTapped(_ sender: UIButton) {
        //TODO: 탭했을 때 처리
        print("hi")
    }
}
