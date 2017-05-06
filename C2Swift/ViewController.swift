//
//  ViewController.swift
//  C2Swift
//
//  Created by Andrey Volodin on 27.04.17.
//  Copyright © 2017 s1ddok. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        C2Wrapper.runMPSTests()

        let start = Date()
        let label = C2Wrapper.predict(with: #imageLiteral(resourceName: "cat.jpg"))!
        let finish = Date()
        
        print("Prediction finished in time \(finish.timeIntervalSince(start)), with result: \(label)")
        
    }

}

