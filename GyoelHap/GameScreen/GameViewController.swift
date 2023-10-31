//
//  GameViewController.swift
//  GyeolHap
//
//  Created by Terry Lee on 2021/02/03.
//

import UIKit
import GoogleMobileAds
import GameKit
import SnapKit


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
        gyeolHintOutline.alpha = 0
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
            guard let item = currentItem, let gameManager else { return UICollectionViewCell() }
            cell.updateUI(index: indexPath.item, item: item.getArrayData()[indexPath.item], tryList: gameManager.getTryList(), hint: gameManager.currentHint)
            cell.tapHandler = {
                guard let manager = self.gameManager else { return }
                manager.addToTryList(indexPath.item + 1)
                
                if manager.getTryList().count == 3 {
                    switch manager.checkHap() {
                    case .hap:
                        break
                    case .submittedAnswer:
                        self.deciSeconds += 100
                        self.showSeconds(second: 10)
                        print("asdfasdf 제출된 정답입니다.")
                        
                    case .wrongAnswer:
                        self.deciSeconds += 100
                        self.showSeconds(second: 10)

                        let hintInformation = manager.hintInformation
                        
                        let shapeHint = hintInformation?.shapeHintArray
                        let bgColorHint = hintInformation?.bgColorHintArray
                        let colorHint = hintInformation?.colorHintArray
                        print("shapeHint: ", shapeHint)
                        print("bgColorHint: ", bgColorHint)
                        print("colorHint: ", colorHint)
                        
                        //I want to replace hintView with a table view.
                        //and replace each stackView with a cell in the table view.
                        //each cell has 3 images and a label and a image view for sf symbol

                        //table view's size is the same with hintView's size below
                        //each cell's height is 1/3 of the table view's height

                        let tableView = UITableView()
                        tableView.backgroundColor = .white
                        tableView.layer.borderColor = UIColor(red: 175/255, green: 153/255, blue: 73/255, alpha: 1).cgColor
                        tableView.layer.cornerRadius = 10
                        tableView.layer.masksToBounds = true
                        tableView.layer.borderWidth = 3
                        self.view.addSubview(tableView)
                        tableView.snp.makeConstraints { (make) in
                            make.top.equalTo(self.upperCollectionView.snp.bottom).offset(-10)
                            make.bottom.equalToSuperview().offset(-5)
                            make.leading.equalToSuperview().offset(10)
                            make.trailing.equalToSuperview().offset(-10)
                        }
                        tableView.delegate = self
                        tableView.dataSource = self
                        tableView.register(HintTableViewCell.self, forCellReuseIdentifier: "HintTableViewCell")





                        // DispatchQueue.main.async {
                        //     let hintView = UIView()
                        //     hintView.backgroundColor = .white
                        //     hintView.layer.borderColor = UIColor(red: 175/255, green: 153/255, blue: 73/255, alpha: 1).cgColor
                        //     hintView.layer.cornerRadius = 10
                        //     hintView.layer.masksToBounds = true
                        //     hintView.layer.borderWidth = 3
                        //     self.view.addSubview(hintView)
                        //     hintView.snp.makeConstraints { (make) in
                        //         make.top.equalTo(self.upperCollectionView.snp.bottom).offset(-10)
                        //         make.bottom.equalToSuperview().offset(-5)
                        //         make.leading.equalToSuperview().offset(10)
                        //         make.trailing.equalToSuperview().offset(-10)
                        //     }
                            
                        //     let shapeHintStackView = UIStackView()
                        //     shapeHintStackView.axis = .horizontal
                        //     shapeHintStackView.distribution = .fillProportionally
                        //     shapeHintStackView.spacing = 5
                        //     guard let shapeHint else { return }
                        //     for i in shapeHint {
                        //         let imageView = UIImageView()
                        //         imageView.contentMode = .scaleAspectFit
                        //         imageView.image = UIImage(named: "shape\(i)")
                        //         shapeHintStackView.addArrangedSubview(imageView)
                        //     }
                        //     let shapeHintLabel = UILabel()
                        //     shapeHintLabel.text = "모양이 다 같거나 다르지 않습니다."
                        //     shapeHintLabel.font = UIFont.boldSystemFont(ofSize: 12)
                        //     shapeHintLabel.textAlignment = .center
                        //     shapeHintLabel.textColor = .black
                        //     shapeHintStackView.addArrangedSubview(shapeHintLabel)

                        //     hintView.addSubview(shapeHintStackView)
                            
                        //     shapeHintStackView.snp.makeConstraints { (make) in
                        //         make.top.equalToSuperview().offset(10)
                        //         make.leading.equalToSuperview().offset(5)
                        //         make.trailing.equalToSuperview().offset(-5)
                        //         make.height.equalTo(hintView.snp.height).multipliedBy(1.0/3).offset(-20)
                        //     }
                            
                        //     let bgColorHintStackView = UIStackView()
                        //     bgColorHintStackView.axis = .horizontal
                        //     bgColorHintStackView.distribution = .fillProportionally
                        //     bgColorHintStackView.spacing = 5
                        //     guard let bgColorHint else { return }
                        //     for i in bgColorHint {
                        //         let imageView = UIImageView()
                        //         imageView.contentMode = .scaleAspectFit
                        //         imageView.image = UIImage(named: "bgColor\(i)")
                        //         bgColorHintStackView.addArrangedSubview(imageView)
                        //     }
                        //     //add a UILabel in bgColorHint StackView at the mote right
                        //     //label text is "배경색"
                        //     let bgColorHintLabel = UILabel()
                        //     bgColorHintLabel.text = "배경색이 다 같거나 다르지 않습니다."
                        //     bgColorHintLabel.font = UIFont.boldSystemFont(ofSize: 12)
                        //     bgColorHintLabel.textAlignment = .center
                        //     bgColorHintLabel.textColor = .black
                        //     bgColorHintStackView.addArrangedSubview(bgColorHintLabel)
                            
                        //     hintView.addSubview(bgColorHintStackView)
                            
                        //     bgColorHintStackView.snp.makeConstraints { (make) in
                        //         make.top.equalTo(shapeHintStackView.snp.bottom).offset(10)
                        //         make.leading.equalToSuperview().offset(5)
                        //         make.trailing.equalToSuperview().offset(-5)
                        //         make.height.equalTo(hintView.snp.height).multipliedBy(1.0/3).offset(-20)
                        //     }
                            
                        //     let colorHintStackView = UIStackView()
                        //     colorHintStackView.axis = .horizontal
                        //     colorHintStackView.distribution = .fillProportionally
                        //     colorHintStackView.spacing = 5
                        //     guard let colorHint else { return }
                        //     for i in colorHint {
                        //         let imageView = UIImageView()
                        //         imageView.contentMode = .scaleAspectFit
                        //         imageView.image = UIImage(named: "color\(i)")
                        //         colorHintStackView.addArrangedSubview(imageView)
                        //     }
                        //     //add a UILabel in colorHint StackView at the mote right
                        //     //label text is "색"
                        //     let colorHintLabel = UILabel()
                        //     colorHintLabel.text = "색이 다 같거나 다르지 않습니다."
                        //     colorHintLabel.font = UIFont.boldSystemFont(ofSize: 12)
                        //     colorHintLabel.textAlignment = .center
                        //     colorHintLabel.textColor = .black
                        //     colorHintStackView.addArrangedSubview(colorHintLabel)
                            
                        //     hintView.addSubview(colorHintStackView)
                            
                        //     colorHintStackView.snp.makeConstraints { (make) in
                        //         make.top.equalTo(bgColorHintStackView.snp.bottom).offset(10)
                        //         make.leading.equalToSuperview().offset(5)
                        //         make.trailing.equalToSuperview().offset(-5)
                        //         make.height.equalTo(hintView.snp.height).multipliedBy(1.0/3).offset(-20)
                        //     }

                        //     DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        //         UIView.animate(withDuration: 2, delay: 0, options: [],
                        //                        animations: {
                        //             hintView.alpha = 0
                        //         },
                        //                        completion: { _ in
                        //             hintView.removeFromSuperview()
                        //             for view in hintView.subviews {
                        //                 view.removeFromSuperview()
                        //             }
                        //         }
                        //         )
                        //     }
                        // }
                    }
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

extension GameViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let manager = self.gameManager else { return 0 }
        return manager.hintInformation?.shapeHintArray.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let manager = self.gameManager else { return UITableViewCell() }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HintTableViewCell", for: indexPath) as? HintTableViewCell else {
            return UITableViewCell()
        }
        guard let shapeHint = manager.hintInformation?.shapeHintArray,
              let bgColorHint = manager.hintInformation?.bgColorHintArray,
              let colorHint = manager.hintInformation?.colorHintArray else { return UITableViewCell() }
        let shapeHintImage = UIImage(named: "shape\(shapeHint[indexPath.row])")
        let bgColorHintImage = UIImage(named: "bgColor\(bgColorHint[indexPath.row])")
        let colorHintImage = UIImage(named: "color\(colorHint[indexPath.row])")
        let labelText = "모양, 배경색, 색이 다 같거나 다르지 않습니다."
        let symbolImage = UIImage(systemName: "questionmark.circle")
        cell.bindData(image1: shapeHintImage!, image2: bgColorHintImage!, image3: colorHintImage!, labelText: labelText, symbolImage: symbolImage!)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height / 3
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

  //I want to replace hintView with a table view.
                        //and replace each stackView with a cell in the table view.
                        //each cell has 3 images and a label and a image view for sf symbol

                        //table view's size is the same with hintView's size below
                        //each cell's height is 1/3 of the table view's height

class HintTableViewCell: UITableViewCell {
    lazy var imageView1: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    lazy var imageView2: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    lazy var imageView3: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    lazy var symbolImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //Add label for new class
        setUpContentView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bindData(image1: UIImage, image2: UIImage, image3: UIImage, labelText: String, symbolImage: UIImage) {
        imageView1.image = image1
        imageView2.image = image2
        imageView3.image = image3
        label.text = labelText
        symbolImageView.image = symbolImage
    }

    private func setUpContentView() {
        contentView.backgroundColor = .white
        contentView.layer.borderColor = UIColor(red: 175/255, green: 153/255, blue: 73/255, alpha: 1).cgColor
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 3

        contentView.addSubview(imageView1)
        imageView1.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(5)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        contentView.addSubview(imageView2)
        imageView2.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.leading.equalTo(imageView1.snp.trailing).offset(5)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        contentView.addSubview(imageView3)
        imageView3.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.leading.equalTo(imageView2.snp.trailing).offset(5)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        contentView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.leading.equalTo(imageView3.snp.trailing).offset(5)
            make.trailing.equalToSuperview().offset(-5)
            make.height.equalTo(30)
        }
        contentView.addSubview(symbolImageView)
        symbolImageView.snp.makeConstraints { (make) in
            make.top.equalTo(imageView1.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().offset(-5)
            make.bottom.equalToSuperview().offset(-5)
        }
    }
    
}
