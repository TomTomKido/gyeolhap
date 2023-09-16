//
//  GameViewController.swift
//  GyeolHap
//
//  Created by Terry Lee on 2021/02/03.
//

import UIKit
import GoogleMobileAds
import GameKit


class GameViewController: UIViewController {

    @IBOutlet weak var stageLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var upperCollectionView: UICollectionView!
    @IBOutlet weak var lowerCollectionView: UICollectionView!
    @IBOutlet weak var plus10sec: UILabel!
    @IBOutlet weak var gyeolButton: UIButton!
    @IBOutlet weak var SuccessView: UIView!
    @IBOutlet weak var gyeolShineView: UIView!
    @IBOutlet weak var answerShineView: UIView!
    @IBOutlet weak var buttonsStackView: UIStackView!

    
    private var screenName = "game"
    
    var currentItem: StageRealm?
    var gameManager: GameManager?
    
    var deciSeconds = 0
    var timer: Timer?
    var isTimerRunning = false
    var safeArea: UILayoutGuide?
    var successViewLeadingToSafeAreaLeading: NSLayoutConstraint?
    var successViewLeadingToSafeAreaTrailing: NSLayoutConstraint?
    
    private var adManager = RewardedAdManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        LogManager.sendScreenLog(screenName: screenName)
        setUpConstraints()
        setUpDelegates()
        initiateGameSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        adManagerSetUp()
    }
    
    private func adManagerSetUp() {
        adManager.delegate = self
    }
    
    private func setUpConstraints() {
        safeArea = self.view.safeAreaLayoutGuide
        successViewLeadingToSafeAreaLeading = self.SuccessView.leadingAnchor.constraint(equalTo: safeArea!.leadingAnchor)
        successViewLeadingToSafeAreaTrailing = self.SuccessView.leadingAnchor.constraint(equalTo: safeArea!.trailingAnchor)
    }
    
    private func setUpDelegates() {
        upperCollectionView.delegate = self
        upperCollectionView.dataSource = self
        lowerCollectionView.delegate = self
        lowerCollectionView.dataSource = self
    }
    
    private func initiateGameSetup() {
        self.timer?.invalidate()
        self.timer = nil
        uncoverSuccessView()
        guard let item = self.currentItem else { return }
        self.gameManager = GameManager(stage: item)
        self.timerLabel.text = "00:00:00"
        self.stageLabel.text = "Stage " + String(item.stageId)
        print("정답리스트: \(String(describing: gameManager!.getAnswers()))")
        deciSeconds = 0
        start()
        guard let manager = self.gameManager else { return }
        manager.clearAllLists()
    }
    
    @IBAction func hintButtonTapped(_ sender: Any) {
        adManager.displayAds { [weak self] in
            self?.giveHint()
        }
    }
    
    @IBAction func gyeol(_ sender: UIButton) {
        LogManager.sendButtonClickLog(screenName: screenName, buttonName: "gyeol")
        guard let manager = self.gameManager, let item = self.currentItem else { return }
        if !manager.checkGyeol() { //결 실패
            self.showSeconds(second: 30)
            self.deciSeconds += 300
            return
        }
        
        //결 성공
        self.timer?.invalidate()
        
        if item.record >= deciSeconds {
            item.solve(secondString: timeString(time: TimeInterval(deciSeconds)), second: deciSeconds)
        }
        
        
        guard let successView = self.SuccessView as? SuccessView, let currentItem else {
            return
        }
        successView.timeRecord.text = timeString(time: TimeInterval(deciSeconds))
        successView.oldBestTimeRecord.text = item.recordString
        successView.menuTapHandler = { [weak self] in
            guard let self else { return }
            self.navigationController?.popViewController(animated: false)
            LogManager.sendButtonClickLog(screenName: self.screenName, buttonName: "menu")
        }
        successView.retryTapHandler = { [weak self] in
            guard let self else { return }
            LogManager.sendStageClickLog(screenName: self.screenName, buttonName: "retry", stageNumber: currentItem.stageId)

            self.adManager.displayAds { [weak self] in
                guard let self else { return }
                self.uncoverSuccessView()
                self.deciSeconds = 0
                self.start()
                self.initiateGameSetup()
                self.upperCollectionView.reloadData()
                self.lowerCollectionView.reloadData()
            }
        }
        successView.nextTapHandler = { [weak self] in
            guard let self else { return }
            guard let item = self.currentItem else { return }
            let stageID = item.stageId
            let nextStageID = stageID
            let items = StageRealm.all()
            self.currentItem = items[nextStageID]

            self.uncoverSuccessView()
            self.deciSeconds = 0
            self.start()
            self.stageLabel.text = "Stage " + String(self.currentItem!.stageId)
            self.initiateGameSetup()
//            print("정답리스트: \(manager.getAnswers())")
            self.upperCollectionView.reloadData()
            self.lowerCollectionView.reloadData()
            LogManager.sendStageClickLog(screenName: self.screenName, buttonName: "next", stageNumber: currentItem.stageId)
        }
        coverSuccessView()
        submitScores()
    }
    
    private func submitScores() {
        submitClearStageScoreToLeaderboard()
        submitAverageClearTimeScoreToLeaderboard()
    }
    
    private func submitClearStageScoreToLeaderboard() {
        let manager = GameCenterManager()
        let score = StageRealm.getSolvedStageData()
        print("leaderboard submit stage clear: ", score)
        manager.submitScore(to: .clearStage, score: score)
    }
    
    private func submitAverageClearTimeScoreToLeaderboard() {
        let manager = GameCenterManager()
        guard let score = StageRealm.getAverageClearTimeData() else { return }
        let milliSeconds = Int(score * 10)
        print("leaderboard submit clear time: ", score)
        manager.submitScore(to: .playTime, score: milliSeconds)
    }
    
    @IBAction func tapBack(_ sender: UIButton) {
        LogManager.sendButtonClickLog(screenName: screenName, buttonName: "back")
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: Give Hint
    
    func giveHint() {
        let hint = gameManager?.getHint() ?? []
        if hint.isEmpty {
            blink(shineView: gyeolShineView)
        } else {
            lowerCollectionView.reloadData()
            blink(shineView: answerShineView)
        }
    }
    
    private func blink(shineView: UIView) {
        UIView.animate(withDuration: 0.1) {
            shineView.alpha = 0.5
        } completion: { completed in
            shineView.alpha = 0
            UIView.animate(withDuration: 0.1, delay: 0.1) {
                shineView.alpha = 0.5
            } completion: { completed in
                shineView.alpha = 0
            }
        }
    }
}

extension GameViewController {
    func coverSuccessView() {
        self.successViewLeadingToSafeAreaTrailing!.isActive = false
        self.successViewLeadingToSafeAreaLeading!.isActive = true
        screenName = "success"
        LogManager.sendScreenLog(screenName: screenName)
    }
    func uncoverSuccessView() {
        self.successViewLeadingToSafeAreaLeading!.isActive = false
        self.successViewLeadingToSafeAreaTrailing!.isActive = true
        screenName = "game"
        LogManager.sendScreenLog(screenName: screenName)
    }
}

//MARK: 타이머 로직

extension GameViewController {
    func start() {
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

//MARK: CollectionView Delegate

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
            cell.updateUI(index: indexPath.item, item: item.getArrayData()[indexPath.item], tryList: gameManager!.getTryList())
            cell.tapHandler = {
                guard let manager = self.gameManager else { return }
                manager.addToTryList(indexPath.item + 1)
                if manager.checkHap() == false {
                    self.deciSeconds += 100
                    self.showSeconds(second: 10)
                }
//                manager.printTryList()
                self.upperCollectionView.reloadData()
                self.lowerCollectionView.reloadData()
            }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnswerCell", for: indexPath) as? AnswerCell else {
                return UICollectionViewCell()
            }
            cell.updateUI(index: indexPath.item, item: gameManager!.getRevealedAnswers())
            return cell
        }
    }
}

// MARK: CollectionView Layout

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
