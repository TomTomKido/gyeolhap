//
//  AnswerCell.swift
//  GyeolHap
//
//  Created by Terry Lee on 2/23/21.
//

import UIKit

class AnswerCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
    
    func updateUI(index: Int, item: [[Int]], hints: [[Int]]) {
        if index < item.count {
            label.text = AnswertoString(item: item, index: index)
            if hints.contains(item[index].sorted()) {
                label.textColor = .yellow
            } else {
                label.textColor = UIColor(red: 103/255, green: 67/255, blue: 161/255, alpha: 1)
            }
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
