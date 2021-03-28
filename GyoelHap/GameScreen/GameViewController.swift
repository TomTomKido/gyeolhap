//
//  GameViewController.swift
//  GyeolHap
//
//  Created by Terry Lee on 2021/02/03.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var stageLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var upperCollectionView: UICollectionView!
    @IBOutlet weak var lowerCollectionView: UICollectionView!
    @IBOutlet weak var plus10sec: UILabel!
    @IBOutlet weak var gyeolButton: UIButton!
    @IBOutlet weak var SuccessView: UIView!
    
    @IBOutlet weak var MenuButton: UIButton!
    @IBOutlet weak var RetryButton: UIButton!
    @IBOutlet weak var NextButton: UIButton!
    var currentItem: StageRealm?
    var gameManager: GameManager?
    
    var deciSeconds = 0
    var timer = Timer()
    var isTimerRunning = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        upperCollectionView.delegate = self
        upperCollectionView.dataSource = self
        lowerCollectionView.delegate = self
        lowerCollectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let item = self.currentItem else { return }
        self.gameManager = GameManager(stage: item)
        self.timerLabel.text = "00:00:00"
        self.stageLabel.text = "Stage " + String(item.stageId)
        print("정답리스트: \((gameManager?.answers)!)")
        deciSeconds = 0
        runTimer()
        guard let manager = self.gameManager else { return }
        manager.tryList = []
    }
    
    @IBAction func gyeol(_ sender: UIButton) {
        guard let manager = self.gameManager, let item = self.currentItem else { return }
        print("hi")
//        if !manager.checkGyeol() {
//            self.showSeconds(second: 30)
//            self.deciSeconds += 300
//        } else {
//            self.timer.invalidate()
//            item.solve(second: timeString(time: TimeInterval(deciSeconds)))
//
//            UIView.animate(withDuration: 0, delay: 0, options: [],
//            animations: {
//                let safeArea = self.view.safeAreaLayoutGuide
//                self.SuccessView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
//            },
//            completion: nil
//            )
////            let gameStoryboard = UIStoryboard.init(name: "Game", bundle: nil)
////            guard let successVC = gameStoryboard.instantiateViewController(identifier: "SuccessVC") as? SuccessViewController else { return }
////            self.navigationController?.pushViewController(successVC, animated: false)
//
//
////            successVC.gameManager = gameManager
////            successVC.stageId = currentItem?.stageId
//        }
        self.timer.invalidate()
        item.solve(second: timeString(time: TimeInterval(deciSeconds)))
        
        UIView.animate(withDuration: 0, delay: 0, options: [],
        animations: {
            let safeArea = self.view.safeAreaLayoutGuide
            self.SuccessView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        },
        completion: nil
        )
        
    }
    
    @IBAction func tapBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}



//타이머 로직
extension GameViewController {
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }

    @objc func updateTimer() {
        deciSeconds += 1
        self.timerLabel.text = timeString(time: TimeInterval(deciSeconds))
    }

    func timeString(time:TimeInterval) -> String {
        let newTime = time / 10
        let hours = Int(newTime) / 3600
        let minutes = Int(newTime) / 60 % 60
        let seconds = Int(newTime) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }

    func showSeconds(second: Int) {
        plus10sec.text = "+\(String(second))sec"
        UIView.animate(withDuration: 0.3, delay: 0, options: [],
        animations: {
            self.plus10sec.alpha = 1
        },
        completion: nil
        )
        UIView.animate(withDuration: 1, delay: 0, options: [],
        animations: {
            self.plus10sec.alpha = 0
        },
        completion: nil
        )
    }
}

extension GameViewController: UICollectionViewDataSource {
    //셀을 몇개 보여줄까?
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.upperCollectionView {
            return 9
        } else {
            return 12
        }
    }
    
    //컬렉션 뷰 셀 어떻게 보여줄까?
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == upperCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TileCollectionViewCell", for: indexPath) as? TileCollectionViewCell else {
                return UICollectionViewCell()
            }
            guard let item = currentItem else { return UICollectionViewCell() }
            cell.updateUI(index: indexPath.item, item: item.getArrayData()[indexPath.item], tryList: gameManager?.tryList ?? [])
            cell.tapHandler = {
                guard let manager = self.gameManager else { return }
                manager.addToTryList(indexPath.item + 1)
                if manager.checkHap() == false {
                    self.deciSeconds += 100
                    self.showSeconds(second: 10)
                }
                manager.printTryList()
                self.upperCollectionView.reloadData()
                self.lowerCollectionView.reloadData()
            }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnswerCell", for: indexPath) as? AnswerCell else {
                return UICollectionViewCell()
            }
            cell.updateUI(index: indexPath.item, item: gameManager?.revealedAnswers ?? [])
            return cell
        }
    }
}

extension GameViewController:UICollectionViewDelegateFlowLayout {
    //셀 사이즈 어떻게 할까?
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == upperCollectionView {
            let inset: CGFloat = 10
            let width: CGFloat = (collectionView.bounds.width - inset * 4) / 3
            let height: CGFloat = (collectionView.bounds.height - inset * 4) / 3
            return CGSize(width:width, height: height)
        } else {
            let inset: CGFloat = 0
            let width: CGFloat = (collectionView.bounds.width - inset * 3) / 2
            let height: CGFloat = (collectionView.bounds.height - inset * 7) / 6
            return CGSize(width:width, height: height)
        }
    }
}
