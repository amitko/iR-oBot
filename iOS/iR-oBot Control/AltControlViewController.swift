//
//  AltControlViewController.swift
//  iR-oBot Control
//
//  Created by Maksim Dimitrov on 8/20/17.
//  Copyright © 2017 Maksim Dimitrov. All rights reserved.
//

import UIKit

class AltControlViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func forwardTapped(_ sender: UIButton) {
        ControlManager.executeCommand(.FORWARD, speed: 150)
    }

    @IBAction func backwardTapped(_ sender: UIButton) {
        ControlManager.executeCommand(.BACKWARD, speed: 100)
    }
    
    @IBAction func turnLeftTapped(_ sender: UIButton) {
        ControlManager.executeCommand(.LEFT_TURN, speed: 100)
    }
    
    @IBAction func turnRightTapped(_ sender: UIButton) {
        ControlManager.executeCommand(.RIGHT_TURN, speed: 100)
    }
    
    @IBAction func stopTapped(_ sender: UIButton) {
        ControlManager.executeCommand(.STOP, speed: 0)
    }
}
