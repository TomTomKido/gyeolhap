//
//  GameViewController.swift
//  GyeolHap
//
//  Created by Terry Lee on 2021/02/03.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var alertBackground: UIView!
    @IBOutlet weak var collectionViewUp: UICollectionView!
    @IBOutlet weak var collectionViewDown: UICollectionView!
    @IBOutlet weak var gyeolImage: UIImageView!
    @IBOutlet weak var sec10: UILabel!
    @IBOutlet weak var GyeolButton: UIButton!
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
        self.navigationItem.title = timeString(time: TimeInterval(deciSeconds))

    }

    func timeString(time:TimeInterval) -> String {
        let newTime = time / 10
        let hours = Int(newTime) / 3600
        let minutes = Int(newTime) / 60 % 60
        let seconds = Int(newTime) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }

    func showAlert() {
        UIView.animate(withDuration: 0.3, delay: 0, options: [],
        animations: {
            self.alertBackground.alpha = 0.5
        },
        completion: nil
        )
        UIView.animate(withDuration: 0.6, delay: 0, options: [],
        animations: {
            self.alertBackground.alpha = 0
        },
        completion: nil
        )
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
//        self.navigationController?.isNavigationBarHidden = true
        self.navigationItem.title = "00:00:00"
        runTimer()
        guard let item = self.currentItem else { return }
        self.gameManager = GameManager(stage: item)
        print("정답리스트: \((gameManager?.answers)!)")
        
        collectionViewUp.delegate = self
        collectionViewUp.dataSource = self
        collectionViewDown.delegate = self
        collectionViewDown.dataSource = self
    }
    
    @IBAction func gyeol(_ sender: UIButton) {
        guard let manager = self.gameManager, let item = self.currentItem else { return }
        print("hi")
        if !manager.checkGyeol() {
            self.showAlert()
            self.showSeconds(second: 30)
            self.deciSeconds += 300
        } else {
            self.timer.invalidate()
            item.solve(second: timeString(time: TimeInterval(deciSeconds)))
            completeMenu.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        }
    }
}

extension GameViewController: UICollectionViewDataSource {
    //셀을 몇개 보여줄까?
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionViewUp {
            return 9
        } else {
            return 12
        }
    }
    
    //컬렉션 뷰 셀 어떻게 보여줄까?
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewUp {
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
                    self.showAlert()
                    self.showSeconds(second: 10)
                }
                manager.printTryList()
                self.collectionViewUp.reloadData()
                self.collectionViewDown.reloadData()
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
        if collectionView == collectionViewUp {
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
