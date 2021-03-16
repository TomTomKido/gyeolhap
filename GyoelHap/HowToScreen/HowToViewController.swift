//
//  HowToViewController.swift
//  GyeolHap
//
//  Created by JeongAh Hong on 2021/03/13.
//

import UIKit

class HowToViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
 
    
    @IBAction func goToMainMenu(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
