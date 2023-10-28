//
//  MainViewController.swift
//  GyeolHap
//
//  Created by TaeHyeok LEE on 2021/03/10.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var howToPlayButton: UIButton!
    @IBOutlet weak var EXITButton: UIButton!
    
    private var screenName = "main"
    private lazy var versionLabel: UILabel = {
        let label = UILabel()
        label.text = "version loding"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LogManager.sendScreenLog(screenName: screenName)
        view.addSubview(versionLabel)
        setAutoLayout()
        setVersionLabel()
    }
    
    private func setAutoLayout() {
        versionLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-10)
            make.leading.equalToSuperview().offset(10)
        }
    }
    
    private func setVersionLabel() {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
           let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            versionLabel.text = "Version \(version) (\(build))"
        }
    }
    
    @IBAction func goToStageScreen(_ sender: UIButton) {
        let stageStoryboard = UIStoryboard.init(name: "Stage", bundle: nil)
        guard let stageVC = stageStoryboard.instantiateViewController(identifier: "StageVC") as? StageViewController else { return }
        self.navigationController?.pushViewController(stageVC, animated: true)
        LogManager.sendButtonClickLog(screenName: screenName, buttonName: "playButton")
    }
    
    @IBAction func goToHowToScreen(_ sender: UIButton) {
        let howToStoryboard = UIStoryboard.init(name: "HowTo", bundle: nil)
        guard let howToVC = howToStoryboard.instantiateViewController(identifier: "HowToVC") as? HowToViewController else { return }
        self.navigationController?.pushViewController(howToVC, animated: true)
        LogManager.sendButtonClickLog(screenName: screenName, buttonName: "howToButton")
    }
    
    @IBAction func EXIT(_ sender: UIButton) {
        LogManager.sendButtonClickLog(screenName: screenName, buttonName: "exit")
        exit(0)
    }
    
    
    @IBAction func settingsButtonTapped(_ sender: Any) {
        let howToStoryboard = UIStoryboard.init(name: "Settings", bundle: nil)
        guard let howToVC = howToStoryboard.instantiateViewController(identifier: "SettingsVC") as? SettingsViewController else { return }
        self.navigationController?.pushViewController(howToVC, animated: true)
        LogManager.sendButtonClickLog(screenName: screenName, buttonName: "settingsButton")
    }
}
