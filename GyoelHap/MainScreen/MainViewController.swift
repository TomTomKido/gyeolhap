//
//  MainViewController.swift
//  GyeolHap
//
//  Created by TaeHyeok LEE on 2021/03/10.
//

import UIKit
import GoogleMobileAds

class MainViewController: UIViewController {

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var howToPlayButton: UIButton!
    @IBOutlet weak var EXITButton: UIButton!
    
    var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAds()
    }
    
    private func setAds() {
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        addBannerViewToView(bannerView)
        bannerView.adSize = GADCurrentOrientationInlineAdaptiveBannerAdSizeWithWidth(UIScreen.main.bounds.width)
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
                                 attribute: .bottom,
                                 relatedBy: .equal,
                                 toItem: view.safeAreaLayoutGuide,
                                 attribute: .bottom,
                                 multiplier: 1,
                                 constant: 0),
              NSLayoutConstraint(item: bannerView,
                                 attribute: .centerX,
                                 relatedBy: .equal,
                                 toItem: view,
                                 attribute: .centerX,
                                 multiplier: 1,
                                 constant: 0)
             ])
    }

    @IBAction func goToStageScreen(_ sender: UIButton) {
        let stageStoryboard = UIStoryboard.init(name: "Stage", bundle: nil)
        guard let stageVC = stageStoryboard.instantiateViewController(identifier: "StageVC") as? StageViewController else { return }
        self.navigationController?.pushViewController(stageVC, animated: true)
    }
    
    @IBAction func goToHowToScreen(_ sender: UIButton) {
        let howToStoryboard = UIStoryboard.init(name: "HowTo", bundle: nil)
        guard let howToVC = howToStoryboard.instantiateViewController(identifier: "HowToVC") as? HowToViewController else { return }
        self.navigationController?.pushViewController(howToVC, animated: true)
    }
    
    @IBAction func EXIT(_ sender: UIButton) {
        exit(0)
    }
}

extension MainViewController: GADBannerViewDelegate {
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
