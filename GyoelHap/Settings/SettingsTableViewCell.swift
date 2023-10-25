//
//  SettingsTableViewCell.swift
//  GyeolHap
//
//  Created by JeongAh Hong on 2023/10/26.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    static let identifier = "SettingsTableViewCell"

    @IBOutlet weak var settingLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(title: String, iconName: String) {
        self.iconImageView.image = UIImage(systemName: iconName)
        self.settingLabel.text = title
    }

    override func prepareForReuse() {
        self.iconImageView.image = nil
        self.settingLabel.text = ""
    }
}
