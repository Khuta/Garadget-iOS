//
//  DoorStatusModel.swift
//  Garadget
//
//  Created by Volpis on 09.12.16.
//  Copyright © 2016 Volpis. All rights reserved.
//

import UIKit

class DoorStatusModel: NSObject {
    
    enum DoorStatusVariables: String {
        case status = "status"
        case time = "time"
        case sensor = "sensor"
        case signal = "signal"
    }
    
    var status: String //status
    var time: String //time
    var reflectionRate: Int //sensor
    var signalStrength: Int //signal
    
    override init() {
        self.status = ""
        self.time = ""
        self.reflectionRate = -1
        self.signalStrength = -1
    }
    
    
    init(doorStatusString : String) {
        self.status = ""
        self.time = ""
        self.reflectionRate = -1
        self.signalStrength = -1
        
        let variablesArr = doorStatusString.components(separatedBy: "|")
        
        for variableItem in variablesArr {
            let nextVariable = variableItem.components(separatedBy: "=")
            
            switch nextVariable[0] {
            case DoorStatusVariables.status.rawValue:
                self.status = nextVariable[1]
            case DoorStatusVariables.time.rawValue:
                self.time = nextVariable[1]
            case DoorStatusVariables.sensor.rawValue:
                self.reflectionRate = Int(nextVariable[1])!
            case DoorStatusVariables.signal.rawValue:
                self.signalStrength = Int(nextVariable[1])!
            default:
                break
            }
        }
    }
    
    func getSignalString() -> String {
        if self.signalStrength < -85 {
            return "poor ((\(self.signalStrength)db)"
        } else if self.signalStrength < -59 {
            return "good ((\(self.signalStrength)db)"
        } else {
            return "excellent ((\(self.signalStrength)db)"
        }
    }

}
