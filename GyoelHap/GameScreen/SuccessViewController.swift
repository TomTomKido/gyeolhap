//
//  SuccessViewController.swift
//  GyeolHap
//
//  Created by TaeHyeok LEE on 2021/03/11.
//

import UIKit

class SuccessViewController: UIViewController {

    @IBOutlet weak var record: UILabel!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var retryButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }

    @IBAction func goToMenuScreen(_ sender: UIButton) {
        let controller = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 3]
        self.navigationController?.popToViewController(controller!, animated: true)
        
    }
    
    @IBAction func retry(_ sender: UIButton) {
        
    }
    
    @IBAction func goToNextStage(_ sender: UIButton) {
        
    }
    
}
