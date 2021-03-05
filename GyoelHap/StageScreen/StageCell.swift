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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUI(index: Int) {
        let stageManager = StageManager.shared
        guard let stage = stageManager.stage(at: index) else { return }
        print("셀 정보:", index, stage.isSolved)
        if stage.isSolved {
            completeFlag.text = "✔️ "
            record.text = stage.record ?? ""
        } else {
            completeFlag.text = ""
            record.text = ""
        }
        stageName.text = String("Stage \(stage.id)")
    }

    
}
