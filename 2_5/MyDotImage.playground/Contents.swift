//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    // UICollectionViewのインスタンス
    var myCollectionView : UICollectionView!
    // UICollectionViewCellのID
    let cellIdentifier = "myCell"

    override func loadView() {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 640, height: 480)
        view.backgroundColor = .white

        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // CollectionViewのレイアウトを生成.
        let layout = UICollectionViewFlowLayout()
        
        // Cell一つ一つの大きさ.
        layout.itemSize = CGSize(width:20, height:20)
        
        // Cellのマージン.
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        // セクション毎のヘッダーサイズ.
        layout.headerReferenceSize = CGSize(width:0,height:0)
        
        //
        layout.minimumLineSpacing = 1.0
        layout.minimumInteritemSpacing = 1.0
        
        // CollectionViewを生成.
        myCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        
        // Cellに使われるクラスを登録.
        myCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
        // Viewに追加
        view.addSubview(myCollectionView)
    }
    
    // Cellが選択された際に呼び出される
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("Num: \(indexPath.row)")
        print("Value:\(collectionView)")
        
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.backgroundColor = (cell.backgroundColor == .black ? .orange : . black)
        }
    }
    
    // Cellの総数を返す
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 690
    }
    
    // Cellに値を設定する
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath as IndexPath)
        
        cell.backgroundColor = .orange
        return cell
    }
    
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
