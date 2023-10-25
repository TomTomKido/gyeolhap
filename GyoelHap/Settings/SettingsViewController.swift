//
//  SettingsViewController.swift
//  GyeolHap
//
//  Created by JeongAh Hong on 2023/10/26.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let screenName = "cloudBackup"
    var settingsData: [(iconName: String, text: String, action: () -> Void)] = []
    let cloudManager = CloudManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LogManager.sendScreenLog(screenName: screenName)
        settingsData = [
            ("icloud.and.arrow.up", "클라우드에 데이터 백업하기", { [weak self] in self?.backupToCloudTapped() }),
            ("icloud.and.arrow.down", "클라우드 데이터 가져오기", { [weak self] in self?.bringCloudDataTapped() })
        ]
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        LogManager.sendClickLog(screenName: screenName, buttonName: "back")
        self.navigationController?.popViewController(animated: true)
    }
    
    func backupToCloudTapped() {
        AlertManager.showAlert(at: self, message: "클라우드의 데이터ㄹ 현재 데이터로 교체합니다. 백업하시겠습니까?", okActionMessage: "백업하기") { [weak self] in
            self?.cloudManager.backupToCloud()
        }
    }
    
    func bringCloudDataTapped() {
        AlertManager.showAlert(at: self, message: "현재 데이터를 클라우드 데이터로 교체합니다. 클라우드 데이터를 가져오시겠습니까?", okActionMessage: "가져오기") { [weak self] in
            self?.cloudManager.bringCloudData()
        }
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
        cell.configure(title: currentCellData.text, iconName: currentCellData.iconName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        settingsData[indexPath.row].action()
        tableView.deselectRow(at: indexPath, animated: true)
        LogManager.sendClickLog(screenName: screenName, buttonName: settingsData[indexPath.row].text)
    }
}


