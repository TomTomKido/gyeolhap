//
//  ViewController.swift
//  GyoelHap
//
//  Created by Terry Lee on 2020/12/21.
//

import UIKit

class ViewController: UIViewController {
    var clicked : [Bool] = Array(repeating: false, count: 9) //Each tile is button. And it describes whether it's clicked or not.
    
    var answerTry : [Int] = Array()  // An array that user tries in game. It will be cleared when the number of values becomes 3.
            
    var revealedAnswers : [[Int]] = Array() //If user enters a right answer, it is moved to this array.
    
    //Extract 9 numbers through randomNumberGen. randomNumberGen generates 27 random numbers so cut it
    var numberArray : [Int] = []
    var propertyArray : [[Int]] = [];
    var answers : [[Int]] = [];
    
    
    
    
    
    @IBOutlet weak var Tile1: UIButton!
    @IBOutlet weak var Tile2: UIButton!
    @IBOutlet weak var Tile3: UIButton!
    @IBOutlet weak var Tile4: UIButton!
    @IBOutlet weak var Tile5: UIButton!
    @IBOutlet weak var Tile6: UIButton!
    @IBOutlet weak var Tile7: UIButton!
    @IBOutlet weak var Tile8: UIButton!
    @IBOutlet weak var Tile9: UIButton!
    @IBOutlet weak var answerView1: UILabel!
    @IBOutlet weak var answerView2: UILabel!
    @IBOutlet weak var answerView3: UILabel!
    @IBOutlet weak var answerView4: UILabel!
    @IBOutlet weak var answerView5: UILabel!
    @IBOutlet weak var answerView6: UILabel!
    @IBOutlet weak var answerView7: UILabel!
    @IBOutlet weak var answerView8: UILabel!
    @IBOutlet weak var answerView9: UILabel!
    @IBOutlet weak var answerView10: UILabel!
    @IBOutlet weak var answerView11: UILabel!
    @IBOutlet weak var answerView12: UILabel!
    @IBOutlet weak var gyeolButton: UIButton!
    
    var Tiles: [UIButton] = []
    var answerLabels: [UILabel] = []
    @IBAction func tileTap(_ sender: UIButton){
        self.clicked[sender.tag - 1].toggle()
        if (self.clicked[sender.tag - 1]) {
            sender.layer.borderWidth = 4;
            sender.layer.borderColor = (UIColor( red: 1, green: 250/255, blue:84/255, alpha: 1.0 )).cgColor
            sender.layer.cornerRadius = 10;
        } else {
            sender.layer.borderWidth = 0;
        }
        
        print(sender.tag)

        if let index = answerTry.firstIndex(of: sender.tag) {
            answerTry.remove(at: index)
        } else {
            self.answerTry.append(sender.tag)
        }
        print("answerTry", answerTry)
        print("revealedAnswers", revealedAnswers)
        //If the number of clicked button is more than and equal to 3
        if (self.clicked.filter { $0 }.count >= 3){
            if answers.contains(answerTry.sorted()) {
                revealedAnswers.append(answerTry)
                print("정답입니다")
                let answerArrayString = answerTry.map { String($0)}
                let answerString = answerArrayString.joined(separator: " ")
                for i in 0 ..< self.answerLabels.count {
                    if self.answerLabels[i].text == "" {
                        self.answerLabels[i].text = answerString
                        break
                    }
                }
                answerTry = Array()
            }else {
                answerTry = Array()
            }
            for i in 0..<self.clicked.count {
                Tiles[i].layer.borderWidth = 0;
                if self.clicked[i] == true {
                    self.clicked[i] = false
                }
            }
        }
    }
    @IBAction func gyeol(_ sender: UIButton) {
        if answers.count == revealedAnswers.count {
            print("결성공")
            
        } else {
            
             
            
            print("결실패 +30초")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        Tiles = [Tile1, Tile2, Tile3, Tile4, Tile5, Tile6, Tile7, Tile8, Tile9]
        answerLabels = [answerView1, answerView2, answerView3, answerView4, answerView5, answerView6, answerView7, answerView8, answerView9, answerView10, answerView11, answerView12]
        // Do any additional setup after loading the view.
        numberArray = Array(randomNumberGen()[0...8])
        propertyArray = numberToProperty(array: numberArray)
        answers = solver(array : propertyArray)
        print(numberArray)
        print(answers)
        for i in 0..<Tiles.count {
            Tiles[i].setImage(UIImage(named: "tile\(numberArray[i])")?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        for i in 0 ..< answerLabels.count {
            answerLabels[i].text = ""
        }

        
        
    }


}

