//
//  ViewController.swift
//  MyOkashi
//
//  Created by Swift-Beginners.
//  Copyright © 2016年 Swift-Beginners. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UIViewController , UISearchBarDelegate , UITableViewDataSource , UITableViewDelegate , SFSafariViewControllerDelegate {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    // Search Barのdelegate通知先を設定
    searchText.delegate = self
    // 入力のヒントになる、プレースホルダを設定
    searchText.placeholder = "お菓子の名前を入力してください"
    
    // Table ViewのdataSourceを設定
    tableView.dataSource = self
    
    // Table Viewのdelegateを設定
    tableView.delegate = self
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBOutlet weak var searchText: UISearchBar!
  @IBOutlet weak var tableView: UITableView!

  // お菓子のリスト（タプル配列）
  var okashiList : [(maker:String , name:String , link:String , image:String)] = []

  //サーチボタンクリック時
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    // キーボードを閉じる
    view.endEditing(true)
    // デバックエリアに出力
    print(searchBar.text ?? "値が入っていません")
    
    if let searchWord = searchBar.text {
      // 入力されていたら、お菓子を検索
      searchOkashi(keyword: searchWord)
    }
  }
  
  // SearchOkashiメソッド
  // 第一引数：keyword 検索したいワード
  func searchOkashi(keyword : String) {
    
    // お菓子の検索キーワードをURLエンコードする
    guard let keyword_encode = keyword.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
      return
    }
    
    // URLオブジェクトの生成
    guard let url = URL(string: "http://www.sysbird.jp/toriko/api/?apikey=guest&format=json&keyword=\(keyword_encode)&max=10&order=r") else {
      return
    }
    
    print(url)
    
    // リクエストオブジェクトの生成
    let req = URLRequest(url: url)
    
    // セッションの接続をカスタマイズできる
    // タイムアウト値、キャッシュポリシーなどが指定できる。今回は、デフォルト値を使用
    let configuration = URLSessionConfiguration.default
    
    // セッション情報を取り出し
    let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
    
    // リクエストをタスクとして登録
    let task = session.dataTask(with: req, completionHandler: {
      (data , request , error) in
      
      //セッションを終了
      session.finishTasksAndInvalidate()
      
      // do try catch エラーハンドリング
      do {
        
        // 受け取ったJSONデータをパース（解析）して格納
        guard let json = try JSONSerialization.jsonObject(with: data!) as? [String:Any] else {
          return
        }
        
        // print("count = \(json["count"])")
        
        // お菓子のリストを初期化
        self.okashiList.removeAll()
        
        // お菓子の情報が取得できているか確認
        if let items = json["item"] as? [[String:Any]] {
          
          // 取得しているお菓子の数だけ処理
          for item in items {
            // メーカー名
            guard let maker = item["maker"] as? String else {
              continue
            }
            // お菓子の名称
            guard let name = item["name"] as? String else {
              continue
            }
            // 掲載URL
            // urlからlinkに名称を変更しているのでご注意ください
            guard let link = item["url"] as? String else {
              continue
            }
            // 画像URL
            guard let image = item["image"] as? String else {
              continue
            }
            
            // １つのお菓子をタプルでまとめて管理
            let okashi = (maker,name,link,image)
            // お菓子の配列へ追加
            self.okashiList.append(okashi)
            
          }
        }
        
        if let okashiList = self.okashiList.first {
          print ("----------------")
          print ("okashiList[0] = \(okashiList)")
        }
        
        // Table Viewを更新する
        self.tableView.reloadData()
        
      } catch {
        // エラー処理
        print("エラーが出ました")
      }
    })
    // ダウンロード開始
    task.resume()
  }
  
  // Cellの総数を返すdatasourceメソッド、必ず記述する必要があります
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // お菓子リストの総数
    return okashiList.count
  }
  
  // Cellに値を設定するdatasourceメソッド。必ず記述する必要があります
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    // 今回表示を行う、Cellオブジェクト（１行）を取得する
    let cell = tableView.dequeueReusableCell(withIdentifier: "okashiCell", for: indexPath)
    
    // お菓子のタイトル設定
    cell.textLabel?.text = okashiList[indexPath.row].name
    
    // お菓子画像のURLを取り出し、画像を取得
    if let url = URL(string: okashiList[indexPath.row].image), let imageData = try? Data(contentsOf: url) {
      // 正常に取得できた場合は、UIImageで画像オブジェクトを生成して、Cellにお菓子画像を設定
      cell.imageView?.image = UIImage(data: imageData)
    }
    
    // 設定済みのCellオブジェクトを画面に反映
    return cell
  }
  
  // Cellが選択された際に呼び出されるdelegateメソッド
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    // ハイライト解除
    tableView.deselectRow(at: indexPath, animated: true)
    
    // URLをstring → URL型に変換
    let urlToLink = URL(string: okashiList[indexPath.row].link)
    
    // SFSafariViewを開く
    let safariViewController = SFSafariViewController(url: urlToLink!)
    
    // delegateの通知先を自分自身
    safariViewController.delegate = self
    
    // SafariViewが開かれる
    present(safariViewController, animated: true, completion: nil)
    
  }
  
  // SafariViewが閉じられた時に呼ばれるdelegateメソッド
  func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
    
    // SafariViewを閉じる
    dismiss(animated: true, completion: nil)
    
  }
}

