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
            ("icloud.and.arrow.up", "클라우드에 데이터 백업하기", { [weak self] in self?.backupToCloudTapped() }),
            ("icloud.and.arrow.down", "클라우드 데이터 가져오기", { [weak self] in self?.bringCloudDataTapped() })
        ]
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        LogManager.sendButtonClickLog(screenName: screenName, buttonName: "back")
        self.navigationController?.popViewController(animated: true)
    }
    
    func backupToCloudTapped() {
        let alert = UIAlertController(title: nil, message: "클라우드의 데이터ㄹ 현재 데이터로 교체합니다. 백업하시겠습니까?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "백업하기", style: .default) { [weak self] _ in
            self?.cloudManager.backupToCloud()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    func bringCloudDataTapped() {
        let alert = UIAlertController(title: nil, message: "현재 데이터를 클라우드 데이터로 교체합니다. 클라우드 데이터를 가져오시겠습니까?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "가져오기", style: .default) { [weak self] _ in
            self?.cloudManager.bringCloudData()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        present(alert, animated: true)
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
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
