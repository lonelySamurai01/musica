//
//  ViewController.swift
//  MyMusic
//
//  Created by Swift-Beginners.
//  Copyright © 2016年 Swift-Beginners. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // シンバルの音源ファイルを指定
  let cymbalPath = Bundle.main.bundleURL.appendingPathComponent("cymbal.mp3")
  
  // シンバル用のプレイヤーインスタンスを作成
  var cymbalPlayer = AVAudioPlayer()

  // ギターの音源ファイルを指定
  let guitarPath = Bundle.main.bundleURL.appendingPathComponent("guitar.mp3")
  
  // ギター用のプレイヤーインスタンスを作成
  var guitarPlayer = AVAudioPlayer()

  // バックミュージックの音源ファイルを指定
  let backmusicPath = Bundle.main.bundleURL.appendingPathComponent("backmusic.mp3")
  
  // バックミュージック用のプレイヤーインスタンスを作成
  var backmusicPlayer = AVAudioPlayer()
  
  // シンバルがタップされた時の処理
  @IBAction func cymbal(_ sender: AnyObject) {
    soundPlayer(&cymbalPlayer ,path:cymbalPath, count: 0)
  }
  
  // ギターがタップされた時の処理
  @IBAction func guitar(_ sender: AnyObject) {
    soundPlayer(&guitarPlayer ,path:guitarPath, count: 0)
  }
  
  // Playボタンがタップされた時の処理
  @IBAction func play(_ sender: AnyObject) {
    soundPlayer(&backmusicPlayer ,path:backmusicPath, count: -1)
  }
  
  // Stopボタンがタップされた時の処理
  @IBAction func stop(_ sender: AnyObject) {
    // バックミュージック停止
    backmusicPlayer.stop()
  }
  
  // 共通のプレイヤー再生処理
  fileprivate func soundPlayer(_ player:inout AVAudioPlayer, path: URL, count: Int) {
    do {
      player = try AVAudioPlayer(contentsOf: path, fileTypeHint: nil)
      player.numberOfLoops = count
      player.play()
    } catch {
      print("エラーが発生しました！")
    }
  }
  
}

