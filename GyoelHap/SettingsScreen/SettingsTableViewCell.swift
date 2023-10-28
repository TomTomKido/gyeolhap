//
//  SettingsTableViewCell.swift
//  GyeolHap
//
//  Created by JeongAh Hong on 2023/10/28.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    static let identifier = "SettingsTableViewCell"

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(title: String, iconName: String) {
        self.iconImageView.image = UIImage(systemName: iconName)
        self.titleLabel.text = title
    }

    override func prepareForReuse() {
        self.iconImageView.image = nil
        self.titleLabel.text = ""
    }
}
