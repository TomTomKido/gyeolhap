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
    private var itemsToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "스테이지 선택"
        self.tableView.rowHeight = 44
        items = StageRealm.all()
    }

    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
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

    // MARK: - Table view data source
    // 한섹션당 몇개의 스테이지를 보여줄까?
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        guard let item = items?[indexPath.row] else { return }
        pushGameVC(item)
    }

    func pushGameVC(_ item: StageRealm) {
        let playStoryboard = UIStoryboard.init(name: "Game", bundle: nil)
        guard let gameVC = playStoryboard.instantiateViewController(identifier: "PlayViewController") as? GameViewController else { return }
        gameVC.currentItem = item
        self.navigationController?.pushViewController(gameVC, animated: true)
    }
}
