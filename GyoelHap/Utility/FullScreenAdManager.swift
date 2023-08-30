//
//  AdvertisementManager.swift
//  GyeolHap
//
//  Created by JeongAh Hong on 2023/08/31.
//

import Foundation
import GoogleMobileAds

class FullScreenAdManager: NSObject {
    private var fullScreenAdID: String = ""
    private var interstitial: GADInterstitialAd?
    
    weak var delegate: GameViewController?
    
    override init() {
        super.init()
        setUpFullScreenAdID()
    }
    
    private func setUpFullScreenAdID() {
        #if DEBUG
        fullScreenAdID = "ca-app-pub-3940256099942544/4411468910" //전면광고 test id
        #else
        fullScreenAdID = "ca-app-pub-8667576295496816/8682486631" //전면광고 실제 id
        #endif
        loadFullScreenAd()
    }
    
    private func loadFullScreenAd() {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: fullScreenAdID,
                               request: request,
                               completionHandler: { [weak self] ad, error in
            guard let self else { return }
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            self.interstitial = ad
            self.interstitial?.fullScreenContentDelegate = self
        })
    }
    
    // MARK: display Ad
    func displayAds() {
        if let interstitial, let delegate {
            interstitial.present(fromRootViewController: delegate)
        } else {
            print("Ad wasn't ready")
        }
    }
}

// MARK: 전면광고 Delegate

extension FullScreenAdManager: GADFullScreenContentDelegate {
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
        delegate?.giveHint()
        loadFullScreenAd()
    }
}
