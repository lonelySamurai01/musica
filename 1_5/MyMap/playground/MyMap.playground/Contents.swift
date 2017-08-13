//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport
import MapKit

class MyViewController : UIViewController , UITextFieldDelegate {
    
    var inputText: UITextField!
    
    var dispMap: MKMapView!

    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        // Text Fieldを配置する
        inputText = UITextField()
        // オートレイアウト設定するので自動でリサイズするのは無効にする
        inputText.translatesAutoresizingMaskIntoConstraints = false
        // 枠線のスタイルを設定
        inputText.borderStyle = .roundedRect
        // ClearButton設定をis always visibleにする
        inputText.clearButtonMode = .always
        // Return Key設定をSearchにする
        inputText.returnKeyType = .search
        // 親ビューにText Fieldを追加する
        view.addSubview(inputText)
        
        // Map Kit Viewを配置する
        dispMap = MKMapView()
        // オートレイアウト設定するので自動でリサイズするのは無効にする
        dispMap.translatesAutoresizingMaskIntoConstraints = false
        // 親ビューにMap Kit Viewを追加する
        view.addSubview(dispMap)

        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // オートレイアウト設定する
        // Text Fieldの左端は、親ビューの左端から0ptの位置
        inputText.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0.0).isActive = true
        // Text Fieldの右端は、親ビューの右端から0ptの位置
        inputText.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0.0).isActive = true
        // Text Fieldの上端は、親ビューの上端から0ptの位置
        inputText.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0.0).isActive = true
        
        // Map Kit Viewの上端は、Text Fieldの下端から0ptの位置
        dispMap.topAnchor.constraint(equalTo: inputText.bottomAnchor, constant: 0.0).isActive = true
        // Map Kit Viewの左端は、親ビューの左端から0ptの位置
        dispMap.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0.0).isActive = true
        // Map Kit Viewの右端は、親ビューの右端から0ptの位置
        dispMap.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0.0).isActive = true
        // Map Kit Viewの下端は、親ビューの上端から0ptの位置
        dispMap.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0).isActive = true
        
        // Text Fieldのdelegate通知先を設定
        inputText.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる(1)
        textField.resignFirstResponder()
        
        // 入力された文字を取り出す(2)
        if let searchKey = textField.text {
            
            // 入力された文字をデバックエリアに表示(3)
            print(searchKey)
            
            // CLGeocoderインスタンスを取得(5)
            let geocoder = CLGeocoder()
            
            // 入力された文字から位置情報を取得(6)
            geocoder.geocodeAddressString(searchKey, completionHandler: { (placemarks, error) in
                
                // 位置情報が存在する場合はunwarpPlacemarksに取り出す(7)
                if let unwarpPlacemarks = placemarks {
                    
                    // 1件目の情報を取り出す(8)
                    if let firstPlacemark = unwarpPlacemarks.first {
                        
                        // 位置情報を取り出す(9)
                        if let location = firstPlacemark.location {
                            
                            // 位置情報から緯度経度をtargetCoordinateに取り出す(10)
                            let targetCoordinate = location.coordinate
                            
                            // 緯度経度をデバックエリアに表示(12)
                            print(targetCoordinate)
                            
                            // MKPointAnnotationインスタンスを取得し、ピンを生成(13)
                            let pin = MKPointAnnotation()
                            
                            // ピンの置く場所に経度緯度を設定(13)
                            pin.coordinate = targetCoordinate
                            
                            // ピンのタイトルを設定(14)
                            pin.title = searchKey
                            
                            // ピンを地図に置く(15)
                            self.dispMap.addAnnotation(pin)
                            
                            // 緯度経度を中心にして半径500mの範囲を表示(16)
                            self.dispMap.region = MKCoordinateRegionMakeWithDistance(targetCoordinate, 500.0, 500.0)
                        }
                    }
                }
            })
        }
        
        // デフォルト動作を行うのでtrueを返す(4)
        return true
    }

    
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
