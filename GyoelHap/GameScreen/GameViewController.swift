//
//  GameViewController.swift
//  GyeolHap
//
//  Created by Terry Lee on 2021/02/03.
//

import UIKit
import GoogleMobileAds


class GameViewController: UIViewController {

    @IBOutlet weak var stageLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var upperCollectionView: UICollectionView!
    @IBOutlet weak var lowerCollectionView: UICollectionView!
    @IBOutlet weak var plus10sec: UILabel!
    @IBOutlet weak var gyeolButton: UIButton!
    @IBOutlet weak var SuccessView: UIView!
    
    
    var currentItem: StageRealm?
    var gameManager: GameManager?
    
    var deciSeconds = 0
    var timer = Timer()
    var isTimerRunning = false
    var safeArea: UILayoutGuide?
    var successViewLeadingToSafeAreaLeading: NSLayoutConstraint?
    var successViewLeadingToSafeAreaTrailing: NSLayoutConstraint?
    
    private var interstitial: GADInterstitialAd?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        safeArea = self.view.safeAreaLayoutGuide
        successViewLeadingToSafeAreaLeading = self.SuccessView.leadingAnchor.constraint(equalTo: safeArea!.leadingAnchor)
        successViewLeadingToSafeAreaTrailing = self.SuccessView.leadingAnchor.constraint(equalTo: safeArea!.trailingAnchor)
        upperCollectionView.delegate = self
        upperCollectionView.dataSource = self
        lowerCollectionView.delegate = self
        lowerCollectionView.dataSource = self
        
        #if DEBUG
        let adsID = "ca-app-pub-3940256099942544/4411468910" //전면광고 test id
        #else
        let adsID = "ca-app-pub-8667576295496816/8682486631" //전면광고 실제 id
        #endif
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: adsID,
                               request: request,
                               completionHandler: { [self] ad, error in
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            interstitial = ad
            interstitial?.fullScreenContentDelegate = self
        }
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        
    
    @IBAction func hintButtonTapped(_ sender: Any) {
    }
    
    @IBAction func gyeol(_ sender: UIButton) {
        guard let manager = self.gameManager, let item = self.currentItem else { return }
        if !manager.checkGyeol() {
            self.showSeconds(second: 30)
            self.deciSeconds += 300
            return
        }
        
        self.timer.invalidate()
        if item.record >= deciSeconds {
            item.solve(secondString: timeString(time: TimeInterval(deciSeconds)), second: deciSeconds)
        }
        
        
        guard let successView = self.SuccessView as? SuccessView else {
            return
        }
        successView.timeRecord.text = timeString(time: TimeInterval(deciSeconds))
        successView.oldBestTimeRecord.text = item.recordString
        successView.menuTapHandler = {
            self.navigationController?.popViewController(animated: false)
        }
        successView.retryTapHandler = {
            self.uncoverSuccessView()
            self.deciSeconds = 0
            self.start()
            manager.clearAllLists()
            self.upperCollectionView.reloadData()
            self.lowerCollectionView.reloadData()
        }
        successView.nextTapHandler = {
            guard let item = self.currentItem else { return }
            let stageID = item.stageId
            let nextStageID = stageID
            let items = StageRealm.all()
            self.currentItem = items[nextStageID]

            self.uncoverSuccessView()
            self.deciSeconds = 0
            self.start()
            self.stageLabel.text = "Stage " + String(self.currentItem!.stageId)
            manager.clearAllLists()
//            print("정답리스트: \(manager.getAnswers())")
            self.upperCollectionView.reloadData()
            self.lowerCollectionView.reloadData()
            self.displayAds()
        }
        coverSuccessView()
    }
    @IBAction func tapBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension GameViewController {
    func coverSuccessView() {
        self.successViewLeadingToSafeAreaTrailing!.isActive = false
        self.successViewLeadingToSafeAreaLeading!.isActive = true
    }
    func uncoverSuccessView() {
        self.successViewLeadingToSafeAreaLeading!.isActive = false
        self.successViewLeadingToSafeAreaTrailing!.isActive = true
    }
}

//타이머 로직
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


extension GameViewController: GADFullScreenContentDelegate { //전면광고 delegate
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
      print("Ad did fail to present full screen content.")
    }

    /// Tells the delegate that the ad will present full screen content.
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
      print("Ad will present full screen content.")
    }

    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
      print("Ad did dismiss full screen content.")
    }
    
    func displayAds() {
      if let interstitial {
        interstitial.present(fromRootViewController: self)
      } else {
        print("Ad wasn't ready")
      }
    }
}
