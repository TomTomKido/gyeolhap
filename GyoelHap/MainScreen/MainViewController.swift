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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func goToStageScreen(_ sender: UIButton) {
        let stageStoryboard = UIStoryboard.init(name: "Stage", bundle: nil)
        guard let stageVC = stageStoryboard.instantiateViewController(identifier: "StageVC") as? StageViewController else { return }
        self.navigationController?.pushViewController(stageVC, animated: true)
    }
    @IBAction func goToHowToScreen(_ sender: UIButton) {
    }
    
    @IBAction func EXIT(_ sender: UIButton) {
        exit(0)
    }
}
