//
//  ViewController.swift
//  MyMap
//
//  Created by Swift-Beginners.
//  Copyright © 2016年 Swift-Beginners. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController ,UITextFieldDelegate {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    // Text Fieldのdelegate通知先を設定
    inputText.delegate = self
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBOutlet weak var inputText: UITextField!
  
  @IBOutlet weak var dispMap: MKMapView!
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    // キーボードを閉る(1)
    textField.resignFirstResponder()
    
    // 入力された文字を取り出す(2)
    let searchKeyword = textField.text
    
    // 入力された文字をデバックエリアに表示(3)
    print(searchKeyword)
    
    // CLGeocoderインスタンスを取得(5)
    let geocoder = CLGeocoder()
    
    // 入力された文字から位置情報を取得(6)
    geocoder.geocodeAddressString(searchKeyword!, completionHandler: { (placemarks:[CLPlacemark]?, error:Error?) in
      
      // 位置情報が存在する場合１件目の位置情報をplacemarkに取り出す(7)
      if let placemark = placemarks?[0] {
        
        // 位置情報から緯度経度が存在する場合、緯度経度をtargetCoordinateに取り出す(8)
        if let targetCoordinate = placemark.location?.coordinate {
          
          // 緯度経度をデバックエリアに表示(9)
          print(targetCoordinate)
          
          // MKPointAnnotationインスタンスを取得し、ピンを生成(10)
          let pin = MKPointAnnotation()
          
          // ピンの置く場所に緯度経度を設定(11)
          pin.coordinate = targetCoordinate
          
          // ピンのタイトルを設定(12)
          pin.title = searchKeyword
          
          // ピンを地図に置く(13)
          self.dispMap.addAnnotation(pin)
          
          // 緯度経度を中心にして半径500mの範囲を表示(14)
          self.dispMap.region = MKCoordinateRegionMakeWithDistance(targetCoordinate, 500.0, 500.0)
        }
      }
    })
    
    //デフォルト動作を行うのでtrueを返す(4)
    return true
  }
  
  @IBAction func changeMapButtonAction(_ sender: AnyObject) {
    // mapTypeプロパティー値をトグル
    //  標準(.standard) → 航空写真(.satellite) → 航空写真+標準(.hybrid)
    //  → 3D Flyover(.satelliteFlyover) → 3D Flyover+標準(.hybridFlyover)
    if dispMap.mapType == .standard {
      dispMap.mapType = .satellite
    } else if dispMap.mapType == .satellite {
      dispMap.mapType = .hybrid
    } else if dispMap.mapType == .hybrid {
      dispMap.mapType = .satelliteFlyover
    } else if dispMap.mapType == .satelliteFlyover {
      dispMap.mapType = .hybridFlyover
    } else {
      dispMap.mapType = .standard
    }
  }
  
}

