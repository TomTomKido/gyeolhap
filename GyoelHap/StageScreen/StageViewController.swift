//
//  StageViewController.swift
//  GyeolHap
//
//  Created by TaeHyeok LEE on 2021/03/10.
//

import UIKit
import RealmSwift
import GameKit

class StageViewController: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stageSelectLabel: UILabel!
    @IBOutlet weak var tableViewBottomAnchor: NSLayoutConstraint!
    @IBOutlet weak var tableViewTopAnchor: NSLayoutConstraint!
    
    @IBOutlet weak var upperScoreInfoView: UILabel!
    @IBOutlet weak var lowerScoreInfoView: UILabel!
    
    @IBOutlet weak var lowerScoreView: UIView!
    var stageCarouselView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private var items: Results<StageRealm>?
    private var itemsToken: NotificationToken?
    
    private var screenName = "stage"
    private let gameCenterManager = GameCenterManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        items = StageRealm.all()
        scrollToFirstNotSolvedIndex()
        setUpCollectionView()
        setUpConstraints()
    }
    
    private func setUpConstraints() {
        view.addSubview(stageCarouselView)
        stageCarouselView.translatesAutoresizingMaskIntoConstraints = false
        tableViewTopAnchor.isActive = false
        
        NSLayoutConstraint.activate([
            stageCarouselView.topAnchor.constraint(equalTo: lowerScoreView.bottomAnchor, constant: 5),
            stageCarouselView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            stageCarouselView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            stageCarouselView.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: 5),
            stageCarouselView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setUpCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        stageCarouselView.collectionViewLayout = layout
        
        stageCarouselView.delegate = self
        stageCarouselView.dataSource = self
        stageCarouselView.showsHorizontalScrollIndicator = false
        
        stageCarouselView.register(StageCarouselCell.self, forCellWithReuseIdentifier: StageCarouselCell.identifier)
    }
    
    private func updateSolvedProblemCountLabel() {
        let solvedProblem = self.items?.reduce(0, { previous, item  in
            if item.isSolved == .solved {
                return previous + 1
            }
            return previous
        })
    }
    
    private func scrollToFirstNotSolvedIndex() {
        //첫번째로 안 푼 문제를 찾아서 거기까지 스크롤 해줌
        guard let firstNotSolvedIndex = self.items?.firstIndex(where: { $0.isSolved == .unsolved }) else { return }
        //        print("첫번째로 안푼 문제: ", firstNotSolvedIndex)
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: firstNotSolvedIndex, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LogManager.sendScreenLog(screenName: screenName)
        
        updateSolvedProblemCountLabel()
        itemsToken = items?.observe { [weak tableView] changes in
            guard let tableView = tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let updates):
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: insertions.map {IndexPath(row: $0, section: 0)}, with: .automatic)
                self.tableView.reloadRows(at: updates.map {IndexPath(row: $0, section: 0)}, with: .automatic)
                self.tableView.deleteRows(at: deletions.map {IndexPath(row: $0, section: 0)}, with: .automatic)
                self.tableView.endUpdates()
            case .error: break
            }
        }
        setUpScoreViewLabel()
        
        RewardedAdManager.shared.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        itemsToken?.invalidate()
    }
    
    @IBAction func goToMainMenu(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func timeString(time:TimeInterval) -> String {
        let newTime = time / 10
        let hours = Int(newTime) / 3600
        let minutes = Int(newTime) / 60 % 60
        let seconds = Int(newTime) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    //MARK: 스코어 뷰 세팅
    private func setUpScoreViewLabel() {
        
        let clearStageNumber = StageRealm.getSolvedStageData()
        let allStageNumber = StageRealm.all().count
        upperScoreInfoView.text = "클리어 스테이지: \(clearStageNumber) / \(allStageNumber) | ??등"
        
        let averageClearTimeDouble = StageRealm.getAverageClearTimeData() ?? 0
        let averageClearTimeString = timeString(time: TimeInterval(Int(averageClearTimeDouble)))
        lowerScoreInfoView.text = "평균 클리어 시간: \(averageClearTimeString) | ??등"
        
        Task {
            do {
                let (stageRank, _) = try await gameCenterManager.getRank(of: .clearStage)
                upperScoreInfoView.text = "클리어 스테이지: \(clearStageNumber) / \(allStageNumber) | \(stageRank)등"
                
                let (playTimeRank, _) = try await gameCenterManager.getRank(of: .playTime)
                lowerScoreInfoView.text = "평균 클리어 시간: \(averageClearTimeString) | \(playTimeRank)등"
            } catch {
                print("Error: Failed to fetch rank from leaderboard")
            }
        }
        
    }
    
    @IBAction func upperScoreButtonTouched(_ sender: Any) {
        gameCenterManager.presentLeaderboard(of: .clearStage, on: self)
        
    }
    @IBAction func lowerScoreButtonTouched(_ sender: Any) {
        gameCenterManager.presentLeaderboard(of: .playTime, on: self)
    }
}

// MARK: TableView Delegate

extension StageViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        print("row: ", indexPath.row)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StageTableViewCell", for: indexPath) as? StageCell, let item = self.items?[indexPath.row]
        else {
            return UITableViewCell()
        }
        cell.updateUI(item)
        return cell
    }
}

extension StageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        print(indexPath.row)
        guard let item = items?[indexPath.row] else { return }
        if item.isSolved == .solved || item.isSolved == .failed {
            AlertManager.showAlert(at: self, message: "광고 시청 후 재시도 가능합니다. 시청하시겠습니까?", okActionMessage: "광고 보기") {
                RewardedAdManager.shared.displayAds { [weak self] in
                    self?.presentGameScreen(index: indexPath.row, item: item)
                }
            }
        } else {
            presentGameScreen(index: indexPath.row, item: item)
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    private func presentGameScreen(index: Int, item: StageRealm) {
        LogManager.sendStageClickLog(screenName: screenName, buttonName: "play", stageNumber: index)
        pushGameVC(item)
    }
    
    func pushGameVC(_ item: StageRealm) {
        let playStoryboard = UIStoryboard.init(name: "Game", bundle: nil)
        guard let gameVC = playStoryboard.instantiateViewController(identifier: "GameVC") as? GameViewController else { return }
        gameVC.currentItem = item
        self.navigationController?.pushViewController(gameVC, animated: true)
    }
}

// MARK: Carousel Delegate

extension StageViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        (items?.count ?? 0) / 200 + 1 //Not solved 셀 추가
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StageCarouselCell.identifier, for: indexPath) as? StageCarouselCell else {
            return UICollectionViewCell()
        }
        
        // Check for the special first cell
        if indexPath.item == 0 {
            cell.configure(text: "Not Solved", widthSize: 110) //아래 collectionView layout width하고 숫자 맞추기
        } else {
            let index = indexPath.item == 1 ? 1 : 200 * (indexPath.item - 1)
            cell.configure(index: index)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // If the first cell is tapped, scroll to the last cell
        if indexPath.item == 0 {
            scrollToFirstNotSolvedIndex()
            return
        }
        
        let targetIndex = indexPath.item == 1 ? 0 : 200 * (indexPath.item - 1) - 1
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: targetIndex, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = indexPath.row == 0 ? 110 : 80
        let height = 40
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
}

extension StageViewController: GKGameCenterControllerDelegate {
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
}
