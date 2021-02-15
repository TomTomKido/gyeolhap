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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StageTableViewCell", for: indexPath) as? StageTableViewCell
            else {
            return UITableViewCell()
        }
        let stage = stageManager.stage(at: indexPath.item)
        cell.updateUI(item: stage)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playStoryboard = UIStoryboard.init(name: "Play", bundle: nil)
        guard let playVC = playStoryboard.instantiateViewController(identifier: "PlayViewController") as? PlayViewController else { return }
        let stage = stageManager.stage(at: indexPath.item)
//        stageManager.replaceCurrentStage(with: item)
        playVC.currentStage = stage
        self.navigationController?.pushViewController(playVC, animated: true)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
