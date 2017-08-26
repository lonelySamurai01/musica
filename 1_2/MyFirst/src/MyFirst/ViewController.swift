//
//  ViewController.swift
//  MyFirst
//
//  Created by Swift-Beginners on 2017/08/19.
//  Copyright © 2017年 Swift-Beginners. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.

    // (1)  ラベルに文字を入れる
    outputLabel.text = "Hello Swift!"
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBOutlet weak var outputLabel: UILabel!
  
}

