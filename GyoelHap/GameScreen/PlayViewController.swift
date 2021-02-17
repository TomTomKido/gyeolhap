//
//  PlayViewController.swift
//  GyeolHap
//
//  Created by Terry Lee on 2021/02/03.
//

import UIKit

class PlayViewController: UIViewController {
//    let stageManager = StageManager.shared

    var currentStage: Stage?
    var currentStageManager: CurrentStageManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let item = currentStage else { return }
        self.currentStageManager = CurrentStageManager(stage: item)
        print((currentStageManager?.answers)!)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension PlayViewController: UICollectionViewDataSource {

    //셀을 몇개 보여줄까?
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    //컬렉션 뷰 셀 어떻게 보여줄까?
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TileCollectionViewCell", for: indexPath) as? TileCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.updateUI(index: indexPath.item, item: currentStage?.dataArray[indexPath.item] ?? 0)
        cell.tapHandler = {
            guard let manager = self.currentStageManager else { return }
            manager.addToTryList(indexPath.item + 1)
            manager.printTryList()
        }
        cell.isClicked = {
            //TODO: manager 옵셔널 바인딩을 실패했을 때 return false부분이 맞는지 알아보고 바꾸기
            guard let manager = self.currentStageManager else { return false}
            return manager.isClicked(at: indexPath.item)
        }
        return cell
    }

}


//extension PlayViewController: UICollectionViewDelegate {
//    //클릭했을 때 동작
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print(stageManager.currentStage!.id)
//
//    }
//}

extension PlayViewController:UICollectionViewDelegateFlowLayout {
    //셀 사이즈 어떻게 할까?
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let inset: CGFloat = 20
        let width: CGFloat = (collectionView.bounds.width - inset * 4) / 3
        let height: CGFloat = width + 30
        return CGSize(width:width, height: height)
    }
}
