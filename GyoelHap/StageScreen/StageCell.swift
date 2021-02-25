//
//  StageCell.swift
//  GyeolHap
//
//  Created by Terry Lee on 2021/02/13.
//

import UIKit

class stageCell: UITableViewCell {

    @IBOutlet weak var stageName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUI(item: Stage?) {
        guard let stage = item else { return }
        stageName.text = String("Stage \(stage.id)")
    }

    
}
