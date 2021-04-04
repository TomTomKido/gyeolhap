//
//  SuccessView.swift
//  GyeolHap
//
//  Created by TaeHyeok LEE on 2021/03/28.
//

import UIKit

class SuccessView: UIView {
    @IBOutlet weak var timeRecord: UILabel!
    @IBOutlet weak var oldBestTimeRecord: UILabel!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var retryButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    var menuTapHandler: (() -> Void)?
    var retryTapHandler: (() -> Void)?
    var nextTapHandler: (() -> Void)?
    
    
    
    
    @IBAction func menuTapped(_ sender: UIButton) {
        menuTapHandler?()
        
        
    }
    
    @IBAction func retryTapped(_ sender: UIButton) {
     
        retryTapHandler?()
        
    
    }
    
    @IBAction func nextTapped(_ sender: UIButton) {
        nextTapHandler?()
    }
    
}
