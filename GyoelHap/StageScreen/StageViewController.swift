//
//  StageViewController.swift
//  GyeolHap
//
//  Created by TaeHyeok LEE on 2021/03/10.
//

import UIKit
import RealmSwift
import GoogleMobileAds

class StageViewController: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stageSelectLabel: UILabel!
    @IBOutlet weak var solvedProblemNumberLabel: UILabel!
    @IBOutlet weak var tableViewBottomAnchor: NSLayoutConstraint!
    @IBOutlet weak var tableViewTopAnchor: NSLayoutConstraint!
    var bannerView: GADBannerView!
    
    var stageCarouselView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private var items: Results<StageRealm>?
    private var itemsToken: NotificationToken?
    
    private var screenName = "stage"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        items = StageRealm.all()
        addSolvedProblemNumber()
        scrollToFirstNotSolvedIndex()
        setUpCollectionView()
        setUpConstraints()
        setAds()
    }
    
    private func setAds() {
//        bannerView.adSize = GADCurrentOrientationInlineAdaptiveBannerAdSizeWithWidth(UIScreen.main.bounds.width) //width만 지정해서 높이 도출
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
    
    private func setUpConstraints() {
        let width: Double = UIScreen.main.bounds.width
        let height = Double(width * 50 / 320)
        let adSize = GADAdSizeFromCGSize(CGSize(width: width, height: height)) //사이즈 직접지정
        bannerView = GADBannerView(adSize: adSize)

        view.addSubview(stageCarouselView)
        stageCarouselView.translatesAutoresizingMaskIntoConstraints = false
        tableViewTopAnchor.isActive = false
        
        self.view.addSubview(bannerView)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        tableViewBottomAnchor.isActive = false
        
        
        NSLayoutConstraint.activate([
            stageCarouselView.topAnchor.constraint(equalTo: stageSelectLabel.bottomAnchor, constant: 20),
            stageCarouselView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            stageCarouselView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            stageCarouselView.bottomAnchor.constraint(equalTo: tableView.topAnchor),
            stageCarouselView.heightAnchor.constraint(equalToConstant: 60),
            bannerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bannerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bannerView.heightAnchor.constraint(equalToConstant: height),
            tableView.bottomAnchor.constraint(equalTo: bannerView.topAnchor)
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
    
    private func addSolvedProblemNumber() {
        let solvedProblem = self.items?.reduce(0, { previous, item  in
            if item.isSolved == true {
                return previous + 1
            }
            return previous
        })
        
        if let solvedProblem, let totalProbelm = items?.count {
            solvedProblemNumberLabel.text = "\(solvedProblem)/\(totalProbelm)"
            print(totalProbelm)
        } else {
            solvedProblemNumberLabel.text = ""
        }
    }
    
    private func scrollToFirstNotSolvedIndex() {
        //첫번째로 안 푼 문제를 찾아서 거기까지 스크롤 해줌
        guard let firstNotSolvedIndex = self.items?.firstIndex(where: { !$0.isSolved }) else { return }
        //        print("첫번째로 안푼 문제: ", firstNotSolvedIndex)
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: firstNotSolvedIndex, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LogManager.sendScreenLog(screenName: screenName)
        
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        itemsToken?.invalidate()
    }
    
    @IBAction func goToMainMenu(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
        LogManager.sendStageClickLog(screenName: screenName, buttonName: "play", stageNumber: indexPath.row)
        //        print(item.stageId)
        pushGameVC(item)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func pushGameVC(_ item: StageRealm) {
        let playStoryboard = UIStoryboard.init(name: "Game", bundle: nil)
        guard let gameVC = playStoryboard.instantiateViewController(identifier: "GameVC") as? GameViewController else { return }
        gameVC.currentItem = item
        self.navigationController?.pushViewController(gameVC, animated: true)
    }
}

// MARK: Banner Delegate

extension StageViewController: GADBannerViewDelegate {
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

// MARK: Carousel Delegate

extension StageViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        (items?.count ?? 0) / 200
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StageCarouselCell.identifier, for: indexPath) as? StageCarouselCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(index: 200 * indexPath.item)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 80
        let height = 40
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
}
