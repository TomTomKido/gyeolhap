//
//  RewardedAdManager.swift
//  GyeolHap
//
//  Created by terry.yes on 2023/09/11.
//

import Foundation
import GoogleMobileAds

class RewardedAdManager: NSObject {
    private var adID: String = ""
//    private var interstitial: GADInterstitialAd?
    private var ad: GADRewardedAd?
    
    weak var delegate: GameViewController?
    
    override init() {
        super.init()
        setUpAdID()
    }
    
    private func setUpAdID() {
        #if DEBUG
        adID = "ca-app-pub-3940256099942544/1712485313" //보상형광고 test id
        #else
        adID = "ca-app-pub-8667576295496816/8350930671" //보상형광고 실제 id
        #endif
        loadAd()
    }
    
    private func loadAd() {
        let request = GADRequest()
        GADRewardedAd.load(withAdUnitID: adID,
                               request: request,
                               completionHandler: { [weak self] ad, error in
            guard let self else { return }
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            self.ad = ad
            self.ad?.fullScreenContentDelegate = self
            print("Loading Ads completed")
        })
    }
    
    // MARK: display Ad
    func displayAds(completion: @escaping () -> Void) {
        if let ad, let delegate {
            ad.present(fromRootViewController: delegate) {
                completion()
            }
        } else {
            print("Ad wasn't ready")
        }
    }
}

// MARK: 전면광고 & 보상형광고 Delegate

extension RewardedAdManager: GADFullScreenContentDelegate {
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
        loadAd()
    }
}
