//
//  DoorConfigModel.swift
//  Garadget
//
//  Created by Volpis on 09.12.16.
//  Copyright © 2016 Volpis. All rights reserved.
//

import UIKit

class DoorConfigModel: NSObject {
    
    enum DoorConfigVariables: String {
        case ver = "ver"
        case cnt = "cnt"
        case rdt = "rdt"
        case mtt = "mtt"
        case mot = "mot"
        case rlt = "rlt"
        case rlp = "rlp"
        case srr = "srr"
        case srt = "srt"
        case aev = "aev"
        case aot = "aot"
        case ans = "ans"
        case ane = "ane"
        case tzo = "tzo"
        case nme = "nme"
    }
    
    var version: String //ver
    var cnt: Int //cnt
    var sensorScanInterval: Int //rdt
    var doorMovingTime: Int //mtt
    var mot: Int //mot
    var buttonPressTime: Int //rlt
    var buttonPressesDelay: Int //rlp
    var sensorReadsAmount: Int //srr
    var reflectionThreshold: Int //srt
    var statusAlerts: Int //aev
    var openTimeout: Int //aot
    var nightTimeStart: Int //ans
    var nightTimeEnd: Int //ane
    var tzo: String //tzo
    var name: String //nme
    
    override init() {
        self.version = ""
        self.cnt = -1
        self.sensorScanInterval = -1
        self.doorMovingTime = -1
        self.mot = -1
        self.buttonPressTime = -1
        self.buttonPressesDelay = -1
        self.sensorReadsAmount = -1
        self.reflectionThreshold = -1
        self.statusAlerts = -1
        self.openTimeout = -1
        self.nightTimeStart = -1
        self.nightTimeEnd = -1
        self.tzo = ""
        self.name = ""
    }

    init(doorConfigString: String) {
        
        self.version = ""
        self.cnt = -1
        self.sensorScanInterval = -1
        self.doorMovingTime = -1
        self.mot = -1
        self.buttonPressTime = -1
        self.buttonPressesDelay = -1
        self.sensorReadsAmount = -1
        self.reflectionThreshold = -1
        self.statusAlerts = -1
        self.openTimeout = -1
        self.nightTimeStart = -1
        self.nightTimeEnd = -1
        self.tzo = ""
        self.name = ""
        
        let variablesArr = doorConfigString.components(separatedBy: "|")
        
        for variableItem in variablesArr {
            let nextVariable = variableItem.components(separatedBy: "=")
            
            switch nextVariable[0] {
            case DoorConfigVariables.ver.rawValue:
                self.version = nextVariable[1]
            case DoorConfigVariables.cnt.rawValue:
                self.cnt = Int(nextVariable[1])!
            case DoorConfigVariables.rdt.rawValue:
                self.sensorScanInterval = Int(nextVariable[1])!
            case DoorConfigVariables.mtt.rawValue:
                self.doorMovingTime = Int(nextVariable[1])!
            case DoorConfigVariables.mot.rawValue:
                self.mot = Int(nextVariable[1])!
            case DoorConfigVariables.rlt.rawValue:
                self.buttonPressTime = Int(nextVariable[1])!
            case DoorConfigVariables.rlp.rawValue:
                self.buttonPressesDelay = Int(nextVariable[1])!
            case DoorConfigVariables.srr.rawValue:
                self.sensorReadsAmount = Int(nextVariable[1])!
            case DoorConfigVariables.srt.rawValue:
                self.reflectionThreshold = Int(nextVariable[1])!
            case DoorConfigVariables.aev.rawValue:
                self.statusAlerts = Int(nextVariable[1])!
            case DoorConfigVariables.aot.rawValue:
                self.openTimeout = Int(nextVariable[1])!
            case DoorConfigVariables.ans.rawValue:
                self.nightTimeStart = Int(nextVariable[1])!
            case DoorConfigVariables.ane.rawValue:
                self.nightTimeEnd = Int(nextVariable[1])!
            case DoorConfigVariables.tzo.rawValue:
                self.tzo = nextVariable[1]
            case DoorConfigVariables.nme.rawValue:
                self.name = nextVariable[1]
            default:
                break
            }
        }
    }
}
