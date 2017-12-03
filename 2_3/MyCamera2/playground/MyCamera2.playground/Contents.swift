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
        // カメラボタンの下端は、 親ビューの下端から30ptの位置
        cameraButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30.0).isActive = true
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
    }
    
    var pictureImage: UIImageView!
    var cameraButton: UIButton!
    var SNSButton: UIButton!
    
    // カメラを起動するをタップすると実行
    @objc func cameraButtonAction(_ sender: Any) {
        // カメラかフォトライブラリーどちらから画像を取得するか選択
        let alertController = UIAlertController(title: "確認", message: "選択してください", preferredStyle: .actionSheet)
        
        // カメラが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            // カメラを起動するための選択肢を定義
            let cameraAction = UIAlertAction(title: "カメラ", style: .default, handler:  { (action:UIAlertAction) in
                // カメラを起動
                let imagePickerController : UIImagePickerController = UIImagePickerController()
                imagePickerController.sourceType = .camera
                imagePickerController.delegate = self
                self.present(imagePickerController, animated: true, completion: nil)
            })
            alertController.addAction(cameraAction)
        }
        
        // フォトライブラリーが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            // フォトライブラリーを起動するための選択肢を定義
            let photoLibraryAction = UIAlertAction(title: "フォトライブラリー", style: .default, handler: { (action:UIAlertAction) in
                // フォトライブラリーを起動
                let imagePickerController : UIImagePickerController = UIImagePickerController()
                imagePickerController.sourceType = .photoLibrary
                imagePickerController.delegate = self
                self.present(imagePickerController, animated: true, completion: nil)
            })
            alertController.addAction(photoLibraryAction)
        }
        
        // キャンセルの選択肢を定義
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // iPadで落ちてしまう対策
        alertController.popoverPresentationController?.sourceView = view
        
        // 選択肢を画面に表示
        present(alertController, animated: true, completion: nil)
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
        // (2)撮影した写真を、配置したcaptureImageに渡す
        captureImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        // (3)モーダルビューを閉じる
        dismiss(animated: true, completion: {
            // Storyboardがないため画面遷移の方法が書籍と異なります
            // (4)エフェクト画面のインスタンスを取得
            let controller = EffectViewController()
            // (5)次の画面のインスタンスに取得した画像を渡す
            controller.originalImage = self.captureImage
            // (6)エフェクト画面に遷移
            self.present(controller, animated: true, completion: nil)
        })
    }
    
    // 次の画面遷移するときに渡す画像を格納する場所
    var captureImage : UIImage?

}

// エフェクト画面
class EffectViewController: UIViewController {
    override func loadView() {
        let view = UIView()
        
        effectImage = UIImageView()
        effectImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(effectImage)
        
        effectButton = UIButton()
        effectButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(effectButton)
        
        shareButton = UIButton()
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(shareButton)
        
        closeButton = UIButton()
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeButton)

        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //オートレイアウト設定
        // ImageViewの左端は、親ビューの左端から16ptの位置
        effectImage.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16.0).isActive = true
        // ImageViewの右端は、親ビューの右端から16ptの位置
        effectImage.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16.0).isActive = true
        // ImageViewの上端は、親ビューの上端から0ptの位置
        effectImage.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0.0).isActive = true
        // ImageViewの下端は、 カメラボタンの上端から30ptの位置
        effectImage.bottomAnchor.constraint(equalTo: effectButton.topAnchor, constant: -30.0).isActive = true
        // ImageViewの縦横比設定
        effectImage.contentMode = .scaleAspectFit
        
        // エフェクトの左端は、親ビューの左端から16ptの位置
        effectButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16.0).isActive = true
        // エフェクトの右端は、親ビューの右端から16ptの位置
        effectButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16.0).isActive = true
        // エフェクトの下端は、 シェアボタンの上端から30ptの位置
        effectButton.bottomAnchor.constraint(equalTo: shareButton.topAnchor, constant: -30.0).isActive = true
        // エフェクトの高さは30
        effectButton.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        // エフェクトのタイトル設定
        effectButton.setTitle("エフェクト", for: .normal)
        // エフェクトのタイトル色設定
        effectButton.setTitleColor(UIColor.white, for: .normal)
        // エフェクトの背景設定
        effectButton.backgroundColor = UIColor.blue
        // エフェクトをタップしたときにメソッド実行するように設定
        effectButton.addTarget(self, action: #selector(effectButtonAction(_:)), for: .touchUpInside)
        
        // シェアボタンの左端は、親ビューの左端から16ptの位置
        shareButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16.0).isActive = true
        // シェアボタンの右端は、親ビューの右端から16ptの位置
        shareButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16.0).isActive = true
        // シェアボタンの下端は、 閉じるボタンの上端から30ptの位置
        shareButton.bottomAnchor.constraint(equalTo: closeButton.topAnchor, constant: -30.0).isActive = true
        // シェアボタンの高さは30
        shareButton.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        // シェアボタンのタイトル設定
        shareButton.setTitle("シェア", for: .normal)
        // シェアボタンのタイトル色設定
        shareButton.setTitleColor(UIColor.white, for: .normal)
        // シェアボタンの背景設定
        shareButton.backgroundColor = UIColor.blue
        // シェアボタンをタップしたときにメソッド実行するように設定
        shareButton.addTarget(self, action: #selector(shareButtonAction(_:)), for: .touchUpInside)

        // 閉じるボタンの左端は、親ビューの左端から16ptの位置
        closeButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16.0).isActive = true
        // 閉じるボタンの右端は、親ビューの右端から16ptの位置
        closeButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16.0).isActive = true
        // 閉じるボタンの下端は、 親ビューの下端から30ptの位置
        closeButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30.0).isActive = true
        // 閉じるボタンの高さは30
        closeButton.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        // 閉じるボタンのタイトル設定
        closeButton.setTitle("閉じる", for: .normal)
        // 閉じるボタンのタイトル色設定
        closeButton.setTitleColor(UIColor.white, for: .normal)
        // 閉じるボタンの背景設定
        closeButton.backgroundColor = UIColor.blue
        // 閉じるボタンをタップしたときにメソッド実行するように設定
        closeButton.addTarget(self, action: #selector(closeButtonAction(_:)), for: .touchUpInside)
        
        // 画面遷移時に元の画像を表示
        effectImage.image = originalImage
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var effectImage: UIImageView!
    var effectButton: UIButton!
    var shareButton: UIButton!
    var closeButton: UIButton!
    
    // エフェクト前画像
    // 前の画面より画像を設定
    var originalImage : UIImage?
    
    @IBAction func effectButtonAction(_ sender: Any) {
        // エフェクト前画像をアンラップしてエフェクト用画像として取り出す
        if let image = originalImage {
            // フィルター名を指定
            let filterName = "CIPhotoEffectMono"
            
            // 元々の画像の回転角度を取得
            let rotate = image.imageOrientation
            
            // UIImage形式の画像をCIImage形式の画像に変換
            let inputImage = CIImage(image: image)
            
            // フィルターの種類を引数で指定された種類を指定してCIFilterのインスタンスを取得
            guard let effectFilter = CIFilter(name: filterName) else {
                return
            }
            
            // エフェクトのパラメータを初期化
            effectFilter.setDefaults()
            
            // インスタンスにエフェクトする元画像を設定
            effectFilter.setValue(inputImage, forKey: kCIInputImageKey)
            
            // エフェクト後のCIImage形式の画像を取り出す
            guard let outputImage = effectFilter.outputImage else {
                return
            }
            
            // CIContextのインスタンスを取得
            let ciContext = CIContext(options: nil)
            
            // エフェクト後の画像をCIContext上に描画し、結果をcgImageとしてCGImage形式の画像を取得
            guard let cgImage = ciContext.createCGImage(outputImage, from: outputImage.extent) else {
                return
            }
            // エフェクト後の画像をCGImage形式からUIImage形式に変更。その際に回転角度を指定。そして、ImageViewに表示
            effectImage.image = UIImage(cgImage: cgImage, scale: 1.0, orientation: rotate)
        }
    }
    
    @objc func shareButtonAction(_ sender: Any) {
        // 表示画像をアンラップしてシェア画像として取り出す
        if let shareImage = effectImage.image {
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
    
    @objc func closeButtonAction(_ sender: Any) {
        // 画面を閉じて前の画面に戻る
        dismiss(animated: true, completion: nil)
    }
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
