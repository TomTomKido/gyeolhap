//
//  GameViewController.swift
//  GyeolHap
//
//  Created by Terry Lee on 2021/02/03.
//

import UIKit

class GameViewController: UIViewController {

    
    @IBOutlet weak var stageIndicator: UILabel!
    @IBOutlet weak var timeIndicator: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var upperCollectionView: UICollectionView!
    @IBOutlet weak var lowerCollectionView: UICollectionView!
    @IBOutlet weak var sec10: UILabel!
    @IBOutlet weak var gyeolButton: UIButton!
    @IBOutlet weak var completeMenu: UIView!
    
    var currentItem: StageRealm?
    var gameManager: GameManager?

    var deciSeconds = 0
    var timer = Timer()
    var isTimerRunning = false

    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }

    @objc func updateTimer() {
        deciSeconds += 1
        self.timeIndicator.text = timeString(time: TimeInterval(deciSeconds))
    }

    func timeString(time:TimeInterval) -> String {
        let newTime = time / 10
        let hours = Int(newTime) / 3600
        let minutes = Int(newTime) / 60 % 60
        let seconds = Int(newTime) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }

    func showSeconds(second: Int) {
        sec10.text = "+\(String(second))sec"
        UIView.animate(withDuration: 0.3, delay: 0, options: [],
        animations: {
            self.sec10.alpha = 1
        },
        completion: nil
        )
        UIView.animate(withDuration: 1, delay: 0, options: [],
        animations: {
            self.sec10.alpha = 0
        },
        completion: nil
        )
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let item = self.currentItem else { return }
        self.gameManager = GameManager(stage: item)
        self.timeIndicator.text = "00:00:00"
        self.stageIndicator.text = "Stage " + String(item.stageId)
        runTimer()
        print("정답리스트: \((gameManager?.answers)!)")
        upperCollectionView.delegate = self
        upperCollectionView.dataSource = self
        lowerCollectionView.delegate = self
        lowerCollectionView.dataSource = self
    }
    
    @IBAction func gyeol(_ sender: UIButton) {
        guard let manager = self.gameManager, let item = self.currentItem else { return }
        print("hi")
        if !manager.checkGyeol() {
            self.showSeconds(second: 30)
            self.deciSeconds += 300
        } else {
            self.timer.invalidate()
            item.solve(second: timeString(time: TimeInterval(deciSeconds)))
            let gameStoryboard = UIStoryboard.init(name: "Game", bundle: nil)
            guard let successVC = gameStoryboard.instantiateViewController(identifier: "SuccessVC") as? SuccessViewController else { return }
            self.navigationController?.pushViewController(successVC, animated: true)
        }
    }
    
    @IBAction func tapPause(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
                if manager.checkAnswer() == false {
                    self.deciSeconds += 100
//                    self.showAlert()
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
