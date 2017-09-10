//: A UIKit based Playground for presenting user interface

import UIKit
import PlaygroundSupport

class MyViewController : UIViewController , UICollectionViewDelegate, UICollectionViewDataSource {
  override func loadView() {
    let view = UIView()
    view.backgroundColor = .white
    
    view.frame = CGRect(x: 0, y: 0, width: 640, height: 480)
    
    self.view = view
  }
  
  // UICollectionViewのインスタンス
  var myCollectionView : UICollectionView!
  // UICollectionViewCellのID
  let cellIdentifier = "myCell"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // CollectionViewのレイアウトを生成
    let layout = UICollectionViewFlowLayout()
    
    // Cell一つ一つの大きさ
    layout.itemSize = CGSize(width:20, height:20)
    
    // Cellの列間の余白を指定する
    layout.minimumInteritemSpacing = 1.0
    
    // Cellの行間の余白を指定する
    layout.minimumLineSpacing = 1.0
    
    // CollectionViewを生成
    myCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
    
    // Cellに使われるクラスを登録
    myCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
    
    // Viewに追加
    view.addSubview(myCollectionView)
    
    // DataSourceの通知先を設定
    myCollectionView.dataSource = self
    
    // delegateの通知先を設定
    myCollectionView.delegate = self
  }
  
  // Cellの総数を返す
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 690
  }
  
  // Cellに値を設定する
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
    
    cell.backgroundColor = .orange
    
    return cell
  }
  
  // Cellが選択された際に呼び出される
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    if let cell = collectionView.cellForItem(at: indexPath) {
      cell.backgroundColor = (cell.backgroundColor == .black ? .orange : . black)
    }
  }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()

