//
//  SettingsTableViewCell.swift
//  GyeolHap
//
//  Created by JeongAh Hong on 2023/10/15.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
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
        iconImageView.image = UIImage(systemName: iconName)
        iconImageView.tintColor = .black
        settingsLabel.text = text
    }
    
    override func prepareForReuse() {
        iconImageView.image = nil
        settingsLabel.text = ""
    }
}
