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
            label.text = AnswertoString(item: item, index: index)
        } else {
            label.text = ""
        }
    }

    private func AnswertoString(item: [[Int]], index: Int) -> String {
        let answerAtIndex = item[index]
        let stringAnswer = answerAtIndex.map { String($0) }
        let joinedAnswer = stringAnswer.joined(separator: "   ")
        return joinedAnswer
    }

}
