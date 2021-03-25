//
//  SuccessViewController.swift
//  GyeolHap
//
//  Created by TaeHyeok LEE on 2021/03/11.
//

import UIKit

//class SuccessViewController: UIViewController {
//
//    var gameManager:GameManager?
//    var stageId: Int?
//    
//    @IBOutlet weak var record: UILabel!
//    @IBOutlet weak var menuButton: UIButton!
//    @IBOutlet weak var retryButton: UIButton!
//    @IBOutlet weak var nextButton: UIButton!
//
//    @IBAction func goToMenuScreen(_ sender: UIButton) {
//        let controller = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 3]
//        self.navigationController?.popToViewController(controller!, animated: true)
//        
//    }
//    
//    @IBAction func retry(_ sender: UIButton) {
//        self.navigationController?.popViewController(animated: true)
//        let playStoryboard = UIStoryboard.init(name: "Game", bundle: nil)
//        guard let gameVC = playStoryboard.instantiateViewController(identifier: "GameVC") as? GameViewController else { return }
//        gameVC.deciSeconds = 0
//        //TODO: answer sheet 에 있는 정답 지우기
//    }
//    
//    @IBAction func goToNextStage(_ sender: UIButton) {
//        let controller = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 3]
//        self.navigationController?.popToViewController(controller!, animated: false)
//        let playStoryboard = UIStoryboard.init(name: "Game", bundle: nil)
//        print(self.stageId)
//        let items = StageRealm.all()
//        guard let gameVC = playStoryboard.instantiateViewController(identifier: "GameVC") as? GameViewController else { return }
//        gameVC.currentItem = items[self.stageId ?? 0]
//        self.navigationController?.pushViewController(gameVC, animated: true)
//        
//        
//    }
//    
//}
