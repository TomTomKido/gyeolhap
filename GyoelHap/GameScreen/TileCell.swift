//
//  TileCell.swift
//  GyeolHap
//
//  Created by Terry Lee on 2021/02/03.
//

import UIKit

class TileCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var tileNumber: UILabel!
    @IBOutlet weak var tileImage: UIImageView!
    @IBOutlet weak var tileButton: UIButton!
    
    var tapHandler: (() -> Void)?
    
    func updateUI(index: Int, item: Int, tryList: [Int]) {
        tileNumber.text = String(index + 1)
        tileImage.image = UIImage(named: "tile\(item)")
        tileImage.layer.cornerRadius = 10
        tileImage.layer.borderColor = CGColor.init(red: 178/255, green: 80/255, blue: 255/255, alpha: 1)
        drawCellBorder(tryList, index)
    }
    
    fileprivate func drawCellBorder(_ tryList: [Int], _ index: Int) {
        if tryList.contains(index + 1) {
            tileImage.layer.borderWidth = 5
        } else {
            tileImage.layer.borderWidth = 0
        }
    }

    @IBAction func cardTapped(_ sender: UIButton) {
        tapHandler?()
    }
    
}
