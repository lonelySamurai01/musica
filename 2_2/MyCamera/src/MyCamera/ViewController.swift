//
//  ViewController.swift
//  MyCamera
//
//  Created by Swift-Beginners on 2017/08/13.
//  Copyright © 2017年 Swift-Beginners. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UINavigationControllerDelegate , UIImagePickerControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var pictureImage: UIImageView!
    
    // カメラを起動するボタンをタップすると実行
    @IBAction func cameraButtonAction(_ sender: Any) {
        // カメラが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            print("カメラは利用できます")
            // (1)UIImagePickerControllerのインスタンスを作成
            let imagePickerController = UIImagePickerController()
            // (2)sourceTypeにCameraを設定
            imagePickerController.sourceType = .camera
            // (3)delegate設置
            imagePickerController.delegate = self
            // (4)モーダルビューで表示
            present(imagePickerController, animated: true, completion: nil)
        }else{
            print("カメラが利用できません")
        }
    }
    
    // SNSに投稿するボタンをタップすると実行
    @IBAction func SNSButtonAction(_ sender: Any) {
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

