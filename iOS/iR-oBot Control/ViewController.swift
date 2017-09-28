//
//  ViewController.swift
//  iR-oBot Control
//
//  Created by Maksim Dimitrov on 5/29/17.
//  Copyright © 2017 Maksim Dimitrov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let MAX_SPEED: Float = 255
    
    @IBOutlet weak var cameraView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraView.layer.shadowColor = UIColor.black.cgColor
        cameraView.layer.shadowOffset = CGSize(width: 1, height: 1)
        cameraView.layer.shadowOpacity = 0.2
        cameraView.layer.borderWidth = 1
        cameraView.layer.borderColor = UIColor.darkGray.cgColor
        
    }

    
    @IBAction func throttleChanged(_ sender: UISlider) {
        print("Throttle Value: \t\(sender.value)")
        let speed = Int(MAX_SPEED * sender.value)
        ControlManager.executeCommand(.LEFT_TURN, speed: speed)
    }
    
    @IBAction func rotationChanged(_ sender: UISlider) {
        print("Rotation Value: \t\(sender.value)")
    }
    
    @IBAction func rotationSliderReleased(_ sender: UISlider) {
        UIView.animate(withDuration: 0.2) {
            sender.setValue(0, animated: true)
            sender.sendActions(for: .valueChanged)
        }
    }
    
}

