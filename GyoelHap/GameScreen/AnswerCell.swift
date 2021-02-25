//
//  AnswerCell.swift
//  GyeolHap
//
//  Created by Terry Lee on 2/23/21.
//

import UIKit

class AnswerCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
    
    func updateUI(index: Int, item: [[Int]]) {
        
        if index < item.count {
            let answerArray = item[index]
            let stringArray = answerArray.map { String($0) }
            let string = stringArray.joined(separator: "   ")
            label.text = string
            print(string)
        } else {
            label.text = ""
        }
    }

}
