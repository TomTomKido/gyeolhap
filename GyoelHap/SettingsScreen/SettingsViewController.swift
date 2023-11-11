//
//  SettingsViewController.swift
//  GyeolHap
//
//  Created by JeongAh Hong on 2023/10/28.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    let screenName = "settings"
    var settingsData: [(iconName: String, title: String, action: () -> Void)] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        LogManager.sendScreenLog(screenName: screenName)
        settingsData = [
            ("doc.text", "How To Play", { [weak self] in self?.howToMenuTapped() })
        ]
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        LogManager.sendButtonClickLog(screenName: screenName, buttonName: "back")
        self.navigationController?.popViewController(animated: true)
    }

    func howToMenuTapped() {
        let howToStoryboard = UIStoryboard.init(name: "HowTo", bundle: nil)
        guard let howToVC = howToStoryboard.instantiateViewController(identifier: "HowToVC") as? HowToViewController else { return }
        self.navigationController?.pushViewController(howToVC, animated: true)
        LogManager.sendButtonClickLog(screenName: screenName, buttonName: "howToButton")
    }
}

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        settingsData.count
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier, for: indexPath) as? SettingsTableViewCell else {
            return UITableViewCell()
        }
        let currentCellData = settingsData[indexPath.row]
        cell.configure(title: currentCellData.title, iconName: currentCellData.iconName)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        settingsData[indexPath.row].action()
        tableView.deselectRow(at: indexPath, animated: true)
        LogManager.sendButtonClickLog(screenName: screenName, buttonName: settingsData[indexPath.row].title)
    }
}
