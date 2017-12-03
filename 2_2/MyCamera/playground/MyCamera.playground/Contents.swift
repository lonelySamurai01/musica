//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController , UINavigationControllerDelegate , UIImagePickerControllerDelegate {
    override func loadView() {
        let view = UIView()
        
        pictureImage = UIImageView()
        pictureImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pictureImage)
        
        cameraButton = UIButton()
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cameraButton)
        
        SNSButton = UIButton()
        SNSButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(SNSButton)
        
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //オートレイアウト設定
        // ImageViewの左端は、親ビューの左端から16ptの位置
        pictureImage.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16.0).isActive = true
        // ImageViewの右端は、親ビューの右端から16ptの位置
        pictureImage.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16.0).isActive = true
        // ImageViewの上端は、親ビューの上端から0ptの位置
        pictureImage.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0.0).isActive = true
        // ImageViewの下端は、 カメラボタンの上端から30ptの位置
        pictureImage.bottomAnchor.constraint(equalTo: cameraButton.topAnchor, constant: -30.0).isActive = true
        // ImageViewの縦横比設定
        pictureImage.contentMode = .scaleAspectFit
        
        // カメラボタンの左端は、親ビューの左端から16ptの位置
        cameraButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16.0).isActive = true
        // カメラボタンの右端は、親ビューの右端から16ptの位置
        cameraButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16.0).isActive = true
        // カメラボタンの下端は、 SNSボタンの上端から30ptの位置
        cameraButton.bottomAnchor.constraint(equalTo: SNSButton.topAnchor, constant: -30.0).isActive = true
        // カメラボタンの高さは30
        cameraButton.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        // カメラボタンのタイトル設定
        cameraButton.setTitle("カメラを起動する", for: .normal)
        // カメラボタンのタイトル色設定
        cameraButton.setTitleColor(UIColor.white, for: .normal)
        // カメラボタンの背景設定
        cameraButton.backgroundColor = UIColor.blue
        // カメラボタンをタップしたときにメソッド実行するように設定
        cameraButton.addTarget(self, action: #selector(cameraButtonAction(_:)), for: .touchUpInside)
        
        // SNSボタンの左端は、親ビューの左端から16ptの位置
        SNSButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16.0).isActive = true
        // SNSボタンの右端は、親ビューの右端から16ptの位置
        SNSButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16.0).isActive = true
        // SNSボタンの下端は、 親ビューの下端から30ptの位置
        SNSButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30.0).isActive = true
        // SNSボタンの高さは30
        SNSButton.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        // SNSボタンのタイトル設定
        SNSButton.setTitle("SNSに投稿する", for: .normal)
        // SNSボタンのタイトル色設定
        SNSButton.setTitleColor(UIColor.white, for: .normal)
        // SNSボタンの背景設定
        SNSButton.backgroundColor = UIColor.blue
        // SNSボタンをタップしたときにメソッド実行するように設定
        SNSButton.addTarget(self, action: #selector(SNSButtonAction(_:)), for: .touchUpInside)
    }
    
    var pictureImage: UIImageView!
    var cameraButton: UIButton!
    var SNSButton: UIButton!
    
    // カメラを起動するをタップすると実行
    @objc func cameraButtonAction(_ sender: Any) {
        // カメラが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("カメラは利用できます")
            // (1)UIImagePickerControllerのインスタンスを作成
            let imagePickerController = UIImagePickerController()
            // (2)sourceTypeにCameraを設定
            imagePickerController.sourceType = .camera
            // (3)delegate設置
            imagePickerController.delegate = self
            // (4)モーダルビューで表示
            present(imagePickerController, animated: true, completion: nil)
        } else {
            print("カメラは利用できません")
        }
    }
    
    // SNSに投稿するボタンをタップすると実行
    @objc func SNSButtonAction(_ sender: Any) {
        // 表示画像をアンラップしてシェア画像として取り出し
        if let shareImage = pictureImage.image {
            // UIActivityViewControllerに渡す配列を作成
            let shareItems = [shareImage]
            
            // UIActivityViewControllerにシェア画像を渡す
            let controller = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
            
            // iPadで落ちてしまう対策
            controller.popoverPresentationController?.sourceView = view
            
            // UIActivityViewControllerを表示
            present(controller, animated: true, completion: nil)
        }
    }
    
    // (1)撮影が終わったときに呼ばれるdelegateメソッド
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // (2)撮影した写真を、配置したpictureImageに渡す
        pictureImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        // (3)モーダルビューを閉じる
        dismiss(animated: true, completion: nil)
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
