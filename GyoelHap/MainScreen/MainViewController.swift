//
//  MainViewController.swift
//  GyeolHap
//
//  Created by TaeHyeok LEE on 2021/03/10.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var howToPlayButton: UIButton!
    @IBOutlet weak var EXITButton: UIButton!
    
    private var screenName = "main"

    override func viewDidLoad() {
        super.viewDidLoad()
        LogManager.sendScreenLog(screenName: screenName)

        // Do any additional setup after loading the view.
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
    
    @IBAction func cloudBackupButtonTapped(_ sender: Any) {
        let cloudBackupStoryboard = UIStoryboard.init(name: "CloudBackup", bundle: nil)
        guard let cloudBackupVC = cloudBackupStoryboard.instantiateViewController(identifier: "CloudBackupVC") as? CloudBackupViewController else { return }
        self.navigationController?.pushViewController(cloudBackupVC, animated: true)
        LogManager.sendButtonClickLog(screenName: screenName, buttonName: "cloudBackupButton")
    }
    
    
    @IBAction func EXIT(_ sender: UIButton) {
        LogManager.sendButtonClickLog(screenName: screenName, buttonName: "exit")
        exit(0)
    }
}
