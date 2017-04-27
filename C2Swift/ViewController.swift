//
//  ViewController.swift
//  C2Swift
//
//  Created by Andrey Volodin on 27.04.17.
//  Copyright © 2017 s1ddok. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        C2Wrapper.runMPSTests()
    }

}

