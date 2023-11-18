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
    @IBOutlet weak var gyeolHintOutline: UIView!
    @IBOutlet weak var buttonsStackView: UIStackView!
    @IBOutlet weak var hapCountLabel: UILabel!
    
    private var screenName = "game"
    
    var currentItem: StageRealm?
    var gameManager: GameManager?
    
    var deciSeconds = 0
    var timer: Timer?
    var isTimerRunning = false
    var safeArea: UILayoutGuide?
    var successViewLeadingToSafeAreaLeading: NSLayoutConstraint?
    var successViewLeadingToSafeAreaTrailing: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        LogManager.sendScreenLog(screenName: screenName)
        setUpGyeolHintOutline()
        setUpConstraints()
        setUpDelegates()
        initiateGameSetup()
        
        
        //3개 randomNumber문제 내는 코드
//        if let gameManagerResult = gameManager?.getOXQuestion() {
//            let question = gameManagerResult.question
//            let isHap = gameManagerResult.isHap
//            print("question: \(question), isHap: \(isHap)")
//        } else {
//            print("GameManager or the result of getOXQuestion is nil")
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        adManagerSetUp()
    }
    
    private func adManagerSetUp() {
        RewardedAdManager.shared.delegate = self
    }
    
    private func setUpGyeolHintOutline() {
        gyeolHintOutline.layer.borderColor = UIColor.yellow.cgColor
        gyeolHintOutline.layer.borderWidth = 4
        gyeolHintOutline.layer.cornerRadius = 3
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
        // remove hint effect
        gyeolHintOutline.alpha = 0
        
        // stop and remove timer
        self.timer?.invalidate()
        self.timer = nil
        
        // show successview
        uncoverSuccessView()
        
        // get next game manager and reset
        guard let item = self.currentItem else { return }
        self.gameManager = GameManager(stage: item)
        guard let manager = self.gameManager else { return }
        manager.clearAllLists()
        print("정답리스트: \(String(describing: manager.getAnswers()))")
        
        // update stage info
        self.stageLabel.text = "Stage " + String(item.stageId)
        
        // init and start timer
        self.timerLabel.text = "00:00:00"
        deciSeconds = 0
        start()
        
        // init hap count
        hapCountLabel.alpha = 0
        hapCountLabel.text = "답 \(gameManager?.getAnswers().count ?? 0)개"
    }
    
    @IBAction func hintButtonTapped(_ sender: Any) {
        AlertManager.showAlert(at: self, message: "힌트 얻기는 광고 시청 후 가능합니다. 시청하시겠습니까?", okActionMessage: "광고 보기") {
            RewardedAdManager.shared.displayAds { [weak self] in
                self?.giveHint()
            }
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
        
        if item.record >= deciSeconds || item.record == -1 {
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

            AlertManager.showAlert(at: self, message: "광고 시청 후 재시도 가능합니다. 시청하시겠습니까?", okActionMessage: "광고 보기") {
                RewardedAdManager.shared.displayAds { [weak self] in
                    guard let self else { return }
                    self.uncoverSuccessView()
                    self.deciSeconds = 0
                    self.start()
                    self.initiateGameSetup()
                    self.upperCollectionView.reloadData()
                    self.lowerCollectionView.reloadData()
                }
            }
        }
        successView.nextTapHandler = { [weak self] in
            guard let self else { return }
            guard let item = self.currentItem else { return }
            let stageID = item.stageId
            let items = StageRealm.all()
            
            let nextStageID = stageID
            let nextItem = items[nextStageID]
            
            if nextItem.isSolved == .unsolved {
                self.currentItem = nextItem
                self.moveToStage(item: nextItem)
            } else {
                AlertManager.showAlert(at: self, message: "다음 스테이지 재시도는 광고 시청 후 가능합니다. 시청하시겠습니까?", okActionMessage: "광고 보기") {
                    self.currentItem = nextItem
                    RewardedAdManager.shared.displayAds {
                        self.moveToStage(item: nextItem)
                    }
                }
            }
        }
        coverSuccessView()
        submitScores()
    }
    
    private func moveToStage(item: StageRealm) {
        uncoverSuccessView()
        deciSeconds = 0
        start()
        stageLabel.text = "Stage " + String(self.currentItem!.stageId)
        initiateGameSetup()
        upperCollectionView.reloadData()
        lowerCollectionView.reloadData()
        LogManager.sendStageClickLog(screenName: self.screenName, buttonName: "next", stageNumber: item.stageId)
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
        guard let item = currentItem else { return }
        if item.isSolved == .unsolved {
            AlertManager.showAlert(at: self, message: "스테이지를 포기하시겠습니까? 나중에 다시 재도전하실 수 있습니다.\n(10초 이내에는 포기 기록이 남지 않습니다.)", okActionMessage: "포기") { [weak self] in
                guard let deciSeconds = self?.deciSeconds else {    return }
                if deciSeconds <= 100 {
                    self?.goBack()
                } else {
                    self?.failThisStage()
                }
            }
        } else {
            goBack()
        }
    }
    
    private func goBack() {
        LogManager.sendButtonClickLog(screenName: screenName, buttonName: "back")
        self.navigationController?.popViewController(animated: true)
    }
    
    private func failThisStage() {
        guard let item = currentItem else { return }
        item.fail()
        goBack()
    }
    
    // MARK: Give Hint
    
    func giveHint() {
        let hint = gameManager?.getHint() ?? []
        if hint.isEmpty {
            gyeolHintOutline.alpha = 1
        } else {
            upperCollectionView.reloadData()
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
        let timeString = timeString(time: TimeInterval(deciSeconds))
        self.timerLabel.text = timeString
        if timeString == "00:00:16" {
            if hapCountLabel.alpha == 1 { return }
            self.hapCountLabel.alpha = 1
            UIView.animateKeyframes(withDuration: 0.3, delay: 0.0, options: [], animations: { [weak self] in
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.7, animations: {
                    self?.hapCountLabel.transform = CGAffineTransform(scaleX: 2, y: 2)
                })

                UIView.addKeyframe(withRelativeStartTime: 0.7, relativeDuration: 0.3, animations: {
                    self?.hapCountLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
                })
            }, completion: nil)
        }
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
            guard let item = currentItem, let gameManager else { return UICollectionViewCell() }
            cell.updateUI(index: indexPath.item, item: item.getArrayData()[indexPath.item], tryList: gameManager.getTryList(), hint: gameManager.currentHint)
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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnswerCell", for: indexPath) as? AnswerCell,
            let gameManager else {
                return UICollectionViewCell()
            }
            cell.updateUI(index: indexPath.item, item: gameManager.getRevealedAnswers(), hints: gameManager.getRevealedHints())
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
