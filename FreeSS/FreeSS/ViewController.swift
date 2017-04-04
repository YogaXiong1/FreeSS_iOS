//
//  ViewController.swift
//  FreeSS
//
//  Created by YogaXiong on 2017/4/3.
//  Copyright © 2017年 YogaXiong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Creater.shared.makeLadder { (ladders, error) in
            for l in ladders {
                print(l.description)
            }
        }
    }


}

