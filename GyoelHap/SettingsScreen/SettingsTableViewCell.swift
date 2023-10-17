//
//  SettingsTableViewCell.swift
//  GyeolHap
//
//  Created by JeongAh Hong on 2023/10/15.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var settingsLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(text: String, iconName: String) {
        icon.image = UIImage(systemName: iconName)
        icon.tintColor = .black
        settingsLabel.text = text
    }
}
