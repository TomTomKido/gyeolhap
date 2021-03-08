//
//  StageCell.swift
//  GyeolHap
//
//  Created by Terry Lee on 2021/02/13.
//

import UIKit

class stageCell: UITableViewCell {

    @IBOutlet weak var stageName: UILabel!
    @IBOutlet weak var completeFlag: UILabel!
    @IBOutlet weak var record: UILabel!
    
    func updateUI(_ item: StageRealm) {
        stageName.text = String("Stage \(item.stageId)")
        if item.isSolved {
            completeFlag.text = "✔️ "
            record.text = item.record
        } else {
            completeFlag.text = ""
            record.text = ""
        }
    }
}
