//
//  MainViewController.swift
//  GyeolHap
//
//  Created by TaeHyeok LEE on 2021/03/10.
//

import UIKit
import SnapKit
import FirebaseRemoteConfig

class MainViewController: UIViewController {
    struct Notice: Codable {
        let message: String
        let shouldRepeat: Bool
    }
    typealias Notices = [String: Notice]
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var howToPlayButton: UIButton!
    @IBOutlet weak var EXITButton: UIButton!
    
    private var screenName = "main"
    private lazy var versionLabel: UILabel = {
        let label = UILabel()
        label.text = "version loding"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LogManager.sendScreenLog(screenName: screenName)
        view.addSubview(versionLabel)
        setAutoLayout()
        setVersionLabel()
        fetchAndActivateRemoteConfig()
    }
    
    private func setAutoLayout() {
        versionLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-10)
            make.leading.equalToSuperview().offset(10)
        }
    }
    
    private func setVersionLabel() {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
           let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            versionLabel.text = "Version \(version) (\(build))"
        }
    }
    
    @IBAction func goToStageScreen(_ sender: UIButton) {
        let stageStoryboard = UIStoryboard.init(name: "Stage", bundle: nil)
        guard let stageVC = stageStoryboard.instantiateViewController(identifier: "StageVC") as? StageViewController else { return }
        self.navigationController?.pushViewController(stageVC, animated: true)
        LogManager.sendButtonClickLog(screenName: screenName, buttonName: "playButton")
    }
    
    @IBAction func goToHowToScreen(_ sender: UIButton) {
        let howToStoryboard = UIStoryboard.init(name: "HowTo", bundle: nil)
        guard let howToVC = howToStoryboard.instantiateViewController(identifier: "HowToVC") as? HowToViewController else { return }
        self.navigationController?.pushViewController(howToVC, animated: true)
        LogManager.sendButtonClickLog(screenName: screenName, buttonName: "howToButton")
    }
    
    @IBAction func EXIT(_ sender: UIButton) {
        LogManager.sendButtonClickLog(screenName: screenName, buttonName: "exit")
        exit(0)
    }
}

extension MainViewController {
    private func fetchAndActivateRemoteConfig() {
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        
        remoteConfig.fetch { (status, error) in
            guard status == .success else {
                print("Failed to fetch remote config: \(error?.localizedDescription ?? "No error description available")")
                return
            }
            remoteConfig.activate() { (changed, error) in
                self.displayNotice(remoteConfig: remoteConfig)
            }
        }
    }
    
    
    private func displayNotice(remoteConfig: RemoteConfig) {
        guard let noticeJSONString = remoteConfig.configValue(forKey: "notice_message").stringValue,
              let noticeData = noticeJSONString.data(using: .utf8) else {
            print("Failed to get or parse notice data")
            return
        }
        
        let decoder = JSONDecoder()
        do {
            let notices = try decoder.decode(Notices.self, from: noticeData)
            if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
               let notice = notices[appVersion] {
                showNotice(message: notice.message, shouldRepeat: notice.shouldRepeat)
            } else {
                print("No notice available for this app version")
            }
        } catch {
            print("Failed to decode JSON: \(error.localizedDescription)")
        }
    }
    
    private func showNotice(message: String, shouldRepeat: Bool) {
        DispatchQueue.main.async {
            let noticeView = UIView()
            noticeView.backgroundColor = .white

            noticeView.layer.borderColor = UIColor(red: 175/255, green: 153/255, blue: 73/255, alpha: 1).cgColor
            noticeView.layer.cornerRadius = 10
            noticeView.layer.masksToBounds = true
            noticeView.layer.borderWidth = 3
            self.view.addSubview(noticeView)
            noticeView.snp.makeConstraints { (make) in
                make.center.equalToSuperview()
                make.leading.equalToSuperview().offset(20)
                make.trailing.equalToSuperview().offset(-20)
            }

            let noticeLabel = UILabel()
            noticeLabel.text = "공지사항"
            noticeLabel.font = UIFont.boldSystemFont(ofSize: 20)
            noticeLabel.textAlignment = .center
            noticeLabel.textColor = .black
            noticeLabel.backgroundColor = UIColor(red: 251/255, green: 234/255, blue: 138/255, alpha: 1)
            //set border width to 5
            noticeView.addSubview(noticeLabel)
            //left and right padding is 20 to the text

            noticeLabel.snp.makeConstraints { (make) in
                make.top.equalToSuperview().offset(20)
                make.centerX.equalToSuperview()
                make.width.equalTo(120)
                make.height.equalTo(40)
            }


            let messageLabel = UILabel()
            messageLabel.text = message
            messageLabel.numberOfLines = 0
            messageLabel.textAlignment = .center
            //set message color to black
            messageLabel.textColor = .black
            noticeView.addSubview(messageLabel)
            messageLabel.snp.makeConstraints { (make) in
                make.top.equalTo(noticeLabel.snp.bottom).offset(20)
                make.leading.equalToSuperview().offset(20)
                make.trailing.equalToSuperview().offset(-20)
            }
            
            let closeButton = UIButton()
            //set background color for button is 746FB4
            closeButton.backgroundColor = UIColor(red: 116/255, green: 111/255, blue: 180/255, alpha: 1)
            closeButton.setTitle("close", for: .normal)
            closeButton.setTitleColor(.white, for: .normal)
            closeButton.addTarget(self, action: #selector(self.closeButtonTapped(_:)), for: .touchUpInside)
            //set font size to 20
            closeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
            
            noticeView.addSubview(closeButton)
            closeButton.snp.makeConstraints { (make) in
                make.top.equalTo(messageLabel.snp.bottom).offset(20)
                make.centerX.equalToSuperview()
                make.width.equalTo(170)
                make.height.equalTo(50)
                make.bottom.equalToSuperview().offset(-20)
            }
        }
    }
    
    @objc
    private func closeButtonTapped(_ sender: UIButton) {
        sender.superview?.subviews.forEach{$0.removeFromSuperview()}
        sender.superview?.removeFromSuperview()
    }
}
