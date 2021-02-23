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
    
    var tapHandler: (() -> Void)?
    var isClicked: (() -> [Int])?
    var reloadView: (() -> Void)?
    var index: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateUI(index: Int, item: Int) {
        self.index = index
        tileNumber.text = String(index + 1)
        tileImage.image = UIImage(named: "tile\(item)")
        tileImage.layer.cornerRadius = 10
        tileImage.layer.borderColor = CGColor.init(red: 178/255, green: 80/255, blue: 255/255, alpha: 1)
        
    }

    @IBAction func cardTapped(_ sender: UIButton) {
        //탭했을 때 어떻게 처리할까?
        tapHandler?()
        //TODO: 아래처럼 옵셔널을 까면 안될거 같은데 나중에 바꾸기
//        if (isClicked?())! {
//            tileImage.layer.borderWidth = 5
//        } else {
//            tileImage.layer.borderWidth = 0
//        }
        if (isClicked?())!.contains(self.index! + 1) {
            tileImage.layer.borderWidth = 5
        } else {
            tileImage.layer.borderWidth = 0
        }
        print(isClicked?() ?? "")
        
        //나중에 리로드고치기
//        reloadView?()
    }
}
