//
//  ViewController.swift
//  MyFirst
//
//  Created by Swift-Beginners on 2018/08/31.
//  Copyright © 2018年 Swift-Beginners. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        // （１）　ラベルに文字を入れる
        outputLabel.text = "Hello Swift!"
    }

    @IBOutlet weak var outputLabel: UILabel!
    
}

