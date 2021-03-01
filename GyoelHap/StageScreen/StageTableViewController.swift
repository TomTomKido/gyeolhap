//
//  StageTableViewController.swift
//  GyeolHap
//
//  Created by Terry Lee on 2021/02/13.
//

import UIKit

class StageTableViewController: UITableViewController {
    
//    let stageManager = StageManager.shared
    let stageManager:StageManager = StageManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "스테이지 선택"

        self.tableView.rowHeight = 44
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    //몇개의 섹션을 보여줄까?
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // 한섹션당 몇개의 스테이지를 보여줄까?
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stageManager.Stages.count
    }

    //각 셀을 어떻게 보여줄까?
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StageTableViewCell", for: indexPath) as? stageCell
            else {
            return UITableViewCell()
        }
        let stage = stageManager.stage(at: indexPath.item)
        cell.updateUI(item: stage)
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
