//
//  SettingsViewController.swift
//  GyeolHap
//
//  Created by JeongAh Hong on 2023/10/15.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let screenName = "settings"
    var settingsData: [(iconName: String, text: String, action: () -> Void)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsData = [
            ("icloud.and.arrow.up", "클라우드에 데이터 백업하기", { [weak self] in self?.backupToCloudTapped() }),
            ("icloud.and.arrow.down", "클라우드 데이터 가져오기", { [weak self] in self?.bringCloudDataTapped() })
        ]
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        LogManager.sendButtonClickLog(screenName: screenName, buttonName: "back")
        self.navigationController?.popViewController(animated: true)
    }
    
    func backupToCloudTapped() {
        AlertManager.showAlert(at: self, message: "클라우드의 데이터에 현재 데이터를 덮어씌웁니다. 백업하시겠습니까?", okActionMessage: "백업하기") {
            ()
        }
    }
    
    func bringCloudDataTapped() {
        AlertManager.showAlert(at: self, message: "현재 데이터에 클라우드 데이터를 덮어씌웁니다. 클라우드 데이터를 가져오시겠습니까?", okActionMessage: "가져오기") {
            ()
        }
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        settingsData.count
    }
}

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as? SettingsTableViewCell else {
            return UITableViewCell()
        }
        let currentCellData = settingsData[indexPath.row]
        cell.configure(text: currentCellData.text, iconName: currentCellData.iconName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        settingsData[indexPath.row].action()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
