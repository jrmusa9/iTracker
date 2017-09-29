//
//  ConsoleLogViewController.swift
//  iTrackU
//
//  Created by Juan Riveros on 9/28/17.
//  Copyright © 2017 Juan Riveros. All rights reserved.
//

import UIKit

class ConsoleLogViewController: UIViewController {

    var delegate: ConsoleLogDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBOutlet weak var consoleLogLabel: UILabel!
    

}
