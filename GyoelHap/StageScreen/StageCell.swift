//
//  StageCell.swift
//  GyeolHap
//
//  Created by Terry Lee on 2021/02/13.
//

import UIKit

class StageCell: UITableViewCell {

    @IBOutlet weak var stageName: UILabel!
    @IBOutlet weak var completeFlag: UILabel!
    @IBOutlet weak var record: UILabel!
    
    override func awakeFromNib() {
//        self.stageName.isUserInteractionEnabled = false
//        self.completeFlag.isUserInteractionEnabled = false
//        self.record.isUserInteractionEnabled = false
    }
    
    func updateUI(_ item: StageRealm) {
        stageName.text = String("Stage \(item.stageId)")
        switch item.isSolved {
        case .solved:
            completeFlag.text = "✔️ "
            record.text = item.recordString
        case .unsolved:
            completeFlag.text = ""
            record.text = ""
        case .failed:
            completeFlag.text = ""
            record.text = "↻"
            record.font = .systemFont(ofSize: 30)
        }
    }
    
    override func prepareForReuse() {
        record.font = .systemFont(ofSize: 22)
        record.text = ""
        completeFlag.text = ""
    }
}
