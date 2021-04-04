//
//  SelectViewController.swift
//  GyeolHap
//
//  Created by TaeHyeok LEE on 2021/04/03.
//

import UIKit
import RealmSwift

class SelectViewController: UIViewController {
    @IBOutlet weak var BackButton: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var items: Results<StageRealm>?
    private var itemsToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        items = StageRealm.all()
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      itemsToken = items?.observe { [weak collectionView] changes in
        guard let collectionView = collectionView else { return }
        switch changes {
             case .initial:
                 self.collectionView?.reloadData()

             case .update(_, let deletions, let insertions, let updates):
                 let cv = self.collectionView!

                 cv.performBatchUpdates({
                     cv.insertItems(at: insertions.map {IndexPath(row: $0, section: 0)})
                     cv.reloadItems(at: updates.map {IndexPath(row: $0, section: 0)})
                     cv.deleteItems(at: deletions.map {IndexPath(row: $0, section: 0)})
                 }, completion: nil)

             default: break
         }
      }
    }
    


}

extension SelectViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectCell", for: indexPath) as? SelectCell else {
            return UICollectionViewCell()
        }
        
        return cell
    }
    
    
    
}

extension SelectViewController: UICollectionViewDelegate {
}

extension SelectViewController:UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
            let inset: CGFloat = 10
            let width: CGFloat = (collectionView.bounds.width - inset * 2)
            let height: CGFloat = CGFloat(50)
            return CGSize(width:width, height: height)
        }
}

