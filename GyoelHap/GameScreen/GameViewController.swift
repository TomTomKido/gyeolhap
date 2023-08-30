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
    @IBOutlet weak var buttonsStackView: UIStackView!
    var bannerView: GADBannerView!

    
    private var screenName = "game"
    
    var currentItem: StageRealm?
    var gameManager: GameManager?
    
    var deciSeconds = 0
    var timer = Timer()
    var isTimerRunning = false
    var safeArea: UILayoutGuide?
    var successViewLeadingToSafeAreaLeading: NSLayoutConstraint?
    var successViewLeadingToSafeAreaTrailing: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        safeArea = self.view.safeAreaLayoutGuide
        successViewLeadingToSafeAreaLeading = self.SuccessView.leadingAnchor.constraint(equalTo: safeArea!.leadingAnchor)
        successViewLeadingToSafeAreaTrailing = self.SuccessView.leadingAnchor.constraint(equalTo: safeArea!.trailingAnchor)
        upperCollectionView.delegate = self
        upperCollectionView.dataSource = self
        lowerCollectionView.delegate = self
        lowerCollectionView.dataSource = self
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
        LogManager.sendScreenLog(screenName: screenName)
    }
    
    @IBAction func gyeol(_ sender: UIButton) {
        LogManager.sendButtonClickLog(screenName: screenName, buttonName: "gyeol")
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
            self.uncoverSuccessView()
            self.deciSeconds = 0
            self.start()
            manager.clearAllLists()
            self.upperCollectionView.reloadData()
            self.lowerCollectionView.reloadData()
            LogManager.sendStageClickLog(screenName: self.screenName, buttonName: "retry", stageNumber: currentItem.stageId)
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
            manager.clearAllLists()
//            print("정답리스트: \(manager.getAnswers())")
            self.upperCollectionView.reloadData()
            self.lowerCollectionView.reloadData()
            LogManager.sendStageClickLog(screenName: self.screenName, buttonName: "next", stageNumber: currentItem.stageId)
        }
        coverSuccessView()
        setAds()
    }
    @IBAction func tapBack(_ sender: UIButton) {
        LogManager.sendButtonClickLog(screenName: screenName, buttonName: "back")
        self.navigationController?.popViewController(animated: true)
    }
    private func setAds() {
         bannerView = GADBannerView(adSize: GADAdSizeBanner)
         addBannerViewToView(bannerView)
         bannerView.adSize = GADCurrentOrientationInlineAdaptiveBannerAdSizeWithWidth(UIScreen.main.bounds.width) //width만 지정해서 높이 도출
 //        bannerView.adSize = GADAdSizeFromCGSize(CGSize(width: UIScreen.main.bounds.width, height: 50)) //사이즈 직접지정
         print("screenWidth", UIScreen.main.bounds.width)
         #if DEBUG
         bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716" //test id
         #else
         bannerView.adUnitID = "ca-app-pub-8667576295496816/1622246817" //실제 하단배너 id
         #endif
         bannerView.rootViewController = self
         bannerView.load(GADRequest())

         bannerView.delegate = self
     }
     
     private func addBannerViewToView(_ bannerView: GADBannerView) {
         bannerView.translatesAutoresizingMaskIntoConstraints = false
         self.view.addSubview(bannerView)
         self.view.addConstraints(
             [NSLayoutConstraint(item: bannerView,
                                 attribute: .top,
                                 relatedBy: .equal,
                                 toItem: buttonsStackView,
                                 attribute: .bottom,
                                 multiplier: 1,
                                 constant: 10),
              NSLayoutConstraint(item: bannerView,
                                 attribute: .centerX,
                                 relatedBy: .equal,
                                 toItem: SuccessView,
                                 attribute: .centerX,
                                 multiplier: 1,
                                 constant: 0)
             ])
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

extension GameViewController: GADBannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("bannerViewDidReceiveAd")
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
        print("bannerViewDidRecordImpression")
    }
    
    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("bannerViewWillPresentScreen")
    }
    
    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("bannerViewWillDIsmissScreen")
    }
    
    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("bannerViewDidDismissScreen")
    }
}
