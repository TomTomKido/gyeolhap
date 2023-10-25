//
//  LogManager.swift
//  GyeolHap
//
//  Created by JeongAh Hong on 2023/08/28.
//

import Foundation
import FirebaseAnalytics

struct LogManager {
    static func sendButtonClickLog(screenName: String, buttonName: String) {
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
            AnalyticsParameterScreenName: screenName,
            AnalyticsParameterItemID: "\(screenName)_\(buttonName)",
            AnalyticsParameterItemName: buttonName
        ])
    }
    
    static func sendClickLog(screenName: String, buttonName: String, stageNumber: Int? = nil) {
        if let stageNumber {
            Analytics.logEvent("click", parameters: [
              "screen_name": screenName,
              "click_target": "\(buttonName)_button",
              "stage_number": stageNumber
            ])
        } else {
            Analytics.logEvent("click", parameters: [
                "screenName": screenName,
                "click_target": "\(buttonName)_button"
            ])
        }
    }
    
    static func sendScreenLog(screenName: String) {
        Analytics.logEvent("screen", parameters: [
          "screenName": screenName
        ])
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.lastScreenName = screenName
        }
    }
    
    static func sendAppLaunchLog() {
        Analytics.logEvent("app_launch", parameters: [:])
    }
    
    static func sendAppFinishLog(screenName: String) {
        Analytics.logEvent("app_finish", parameters: [
          "screenName": screenName
        ])
    }
}
