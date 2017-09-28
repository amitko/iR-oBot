//
//  ControlManager.swift
//  iR-oBot Control
//
//  Created by Maksim Dimitrov on 8/20/17.
//  Copyright © 2017 Maksim Dimitrov. All rights reserved.
//

import Foundation

enum Command : String {
    case FORWARD = "forward.php"
    case BACKWARD = "backward.php"
    case LEFT_TURN = "left_turn.php"
    case RIGHT_TURN = "right_turn.php"
    case STOP = "stop.php"
}

class ControlManager {
    
    static var lastSpeed = 0
    
    class func executeCommand(_ command: Command, speed: Int) {
        let urlString = "http://172.20.10.11/moto/\(command.rawValue)?speed=\(speed)"
        guard let url = URL(string: urlString) else {
            print("Invalid url")
            return
        }
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                print(responseString)
            }
        }
        task.resume()
        
    }
}
