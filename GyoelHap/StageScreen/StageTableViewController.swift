//
//  StageTableViewController.swift
//  GyeolHap
//
//  Created by Terry Lee on 2021/02/13.
//

import UIKit
import RealmSwift

class StageTableViewController: UITableViewController {
    
    private var items: Results<StageRealm>?
    
    let stageManager = StageManager.shared
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "스테이지 선택"
        self.tableView.rowHeight = 44
        items = StageRealm.all()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
        stageManager.printSolvedStatus()
        
    }
    // MARK: - Table view data source

    // 한섹션당 몇개의 스테이지를 보여줄까?
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return stageManager.Stages.count
        return items?.count ?? 0
    }

    //각 셀을 어떻게 보여줄까?
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StageTableViewCell", for: indexPath) as? stageCell, let item = items?[indexPath.row]
            else {
            return UITableViewCell()
        }
        
        cell.updateUI(item)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("stage", indexPath.item)
        pushStage(stageId: indexPath.item)
    }

    func pushStage(stageId: Int) {
        let playStoryboard = UIStoryboard.init(name: "Game", bundle: nil)
        guard let playVC = playStoryboard.instantiateViewController(identifier: "PlayViewController") as? GameViewController else { return }
        let stage = stageManager.stage(at: stageId)
        playVC.currentStage = stage
        self.navigationController?.pushViewController(playVC, animated: true)
    }
}
