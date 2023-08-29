//
//  HowToViewController.swift
//  GyeolHap
//
//  Created by JeongAh Hong on 2021/03/13.
//

import UIKit

class HowToViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    
    private var screenName = "howTo"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LogManager.sendScreenLog(screenName: screenName)
        // Do any additional setup after loading the view.
    }
 
    
    @IBAction func goToMainMenu(_ sender: UIButton) {
        LogManager.sendButtonClickLog(screenName: screenName, buttonName: "back")
        self.navigationController?.popViewController(animated: true)
    }
    

}
