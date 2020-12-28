//
//  ViewController.swift
//  GyoelHap
//
//  Created by Terry Lee on 2020/12/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var Tile1: UIButton!
    @IBOutlet weak var Tile2: UIButton!
    @IBOutlet weak var Tile3: UIButton!
    @IBOutlet weak var Tile4: UIButton!
    @IBOutlet weak var Tile5: UIButton!
    @IBOutlet weak var Tile6: UIButton!
    @IBOutlet weak var Tile7: UIButton!
    @IBOutlet weak var Tile8: UIButton!
    @IBOutlet weak var Tile9: UIButton!
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let tileImageSet = [
            UIImage(named: "tile1"), UIImage(named: "tile2"), UIImage(named: "tile3"),
            UIImage(named: "tile4"), UIImage(named: "tile5"), UIImage(named: "tile6"),
            UIImage(named: "tile7"), UIImage(named: "tile8"), UIImage(named: "tile9")
        ]
        var randomArray: [Int] = randomNumberGen()
        print("randomArray", randomArray)
        var propertyArray : [[Int]] = numberToProperty(array: randomArray)
        var answer : [[Int]] = solver(array : propertyArray)
        print(answer)
        
        Tile1.setImage(UIImage(named: "tile\(randomArray[0])")?.withRenderingMode(.alwaysOriginal), for: .normal)
        Tile2.setImage(UIImage(named: "tile\(randomArray[1])")?.withRenderingMode(.alwaysOriginal), for: .normal)
        Tile3.setImage(UIImage(named: "tile\(randomArray[2])")?.withRenderingMode(.alwaysOriginal), for: .normal)
        Tile4.setImage(UIImage(named: "tile\(randomArray[3])")?.withRenderingMode(.alwaysOriginal), for: .normal)
        Tile5.setImage(UIImage(named: "tile\(randomArray[4])")?.withRenderingMode(.alwaysOriginal), for: .normal)
        Tile6.setImage(UIImage(named: "tile\(randomArray[5])")?.withRenderingMode(.alwaysOriginal), for: .normal)
        Tile7.setImage(UIImage(named: "tile\(randomArray[6])")?.withRenderingMode(.alwaysOriginal), for: .normal)
        Tile8.setImage(UIImage(named: "tile\(randomArray[7])")?.withRenderingMode(.alwaysOriginal), for: .normal)
        Tile9.setImage(UIImage(named: "tile\(randomArray[8])")?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        
        
    }


}

