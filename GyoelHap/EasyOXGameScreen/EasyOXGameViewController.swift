//
//  EasyOXGameViewController.swift
//  GyeolHap
//
//  Created by JeongAh Hong on 2023/10/29.
//

import UIKit

class EasyOXGameViewController: UIViewController {
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var timerFillView: UIView!
    @IBOutlet weak var timerBackgroundView: UIView!
    
    @IBOutlet weak var tile1: UIImageView!
    @IBOutlet weak var tile2: UIImageView!
    @IBOutlet weak var tile3: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func hapButtonTapped(_ sender: Any) {
        print("hap")
    }
    
    @IBAction func gyeolButtonTapped(_ sender: Any) {
        print("gyeol")
    }
    
}
