//
//  CloudBackupViewController.swift
//  GyeolHap
//
//  Created by JeongAh Hong on 2023/10/15.
//

import UIKit

class CloudBackupViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let screenName = "cloudBackup"
    var settingsData: [(iconName: String, text: String, action: () -> Void)] = []
    let cloudManager = CloudManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsData = [
            ("icloud.and.arrow.up", "클라우드에 데이터 백업하기", { [weak self] in self?.backupToCloud() }),
            ("icloud.and.arrow.down", "클라우드 데이터 가져오기", { [weak self] in self?.bringCloudData() })
        ]
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        LogManager.sendButtonClickLog(screenName: screenName, buttonName: "back")
        self.navigationController?.popViewController(animated: true)
    }
    
    func backupToCloud() {
        cloudManager.backupToCloud()
    }
    
    func bringCloudData() {
        cloudManager.bringCloudData()
    }
}

extension CloudBackupViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        settingsData.count
    }
}

extension CloudBackupViewController: UITableViewDataSource {
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
    }
}
