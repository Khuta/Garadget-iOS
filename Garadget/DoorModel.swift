//
//  DoorModel.swift
//  Garadget
//
//  Created by Volpis on 09.12.16.
//  Copyright © 2016 Volpis. All rights reserved.
//

import UIKit
import Spark_SDK

class DoorModel: NSObject {

    var doorConfig: DoorConfigModel
    var doorStatus: DoorStatusModel
    var netConfig: NetConfigModel
    var device: SparkDevice
    
    
    
    override init() {
        self.doorConfig = DoorConfigModel()
        self.doorStatus = DoorStatusModel()
        self.netConfig = NetConfigModel()
        self.device = SparkDevice(params: ["": ""])!
    }
    
    init(doorConfig: DoorConfigModel, doorStatus: DoorStatusModel, netConfig: NetConfigModel, device: SparkDevice) {
        self.doorConfig = doorConfig
        self.doorStatus = doorStatus
        self.netConfig = netConfig
        self.device = device
    }
    
    func getDoorName() -> String {
        if self.doorConfig.name != "" {
            return self.doorConfig.name
        } else {
            return self.device.name!
        }
    }
    
    func getDoorImage() -> UIImage {
        if self.doorStatus.status == InternalHelper.DoorStatusConstants.open.rawValue {
            return UIImage(named: "ic_anim_garage_15")!
        } else if self.doorStatus.status == InternalHelper.DoorStatusConstants.stopped.rawValue {
            return UIImage(named: "ic_anim_garage_09")!
        } else {
            return UIImage(named: "ic_anim_garage_01")!
        }
    }
    
    func getSignalImage() -> UIImage {
        if self.doorStatus.signalStrength == -1 {
            return UIImage(named: "ic_signal_01_small")!
        } else if self.doorStatus.signalStrength < -99 {
            return UIImage(named: "ic_signal_02_small")!
        } else if self.doorStatus.signalStrength < -84 {
            return UIImage(named: "ic_signal_03_small")!
        } else if self.doorStatus.signalStrength < -75 {
            return UIImage(named: "ic_signal_04_small")!
        } else if self.doorStatus.signalStrength < -59 {
            return UIImage(named: "ic_signal_05_small")!
        } else {
            return UIImage(named: "ic_signal_06_small")!
        }
    }
    
    func getLastContactMillis() -> Int64 {
        return Int64((NSDate().timeIntervalSince1970 * 1000).rounded()) - Int64((self.device.lastHeard!.timeIntervalSince1970 * 1000).rounded())
    }
    
    func getFormattedTime() -> String {
        let time = self.getLastContactMillis()
        
        if time <= 120 * 1000 {
            return "\(Int(time / 1000)) s"
        } else if time <= 120 * 60 * 1000 {
            return "\(Int(time / 1000 / 60)) m"
        } else if time <= 48 * 60 * 60 * 1000 {
            return "\(Int(time / 1000 / 60 / 60)) h"
        } else {
            return "\(Int(time / 1000 / 60 / 60 / 24)) d"
        }
        
    }
    
    func updateDoorData(value: String) {
        let ketValueArr = value.components(separatedBy: "=")
        
        switch ketValueArr[0] {
        case DoorConfigModel.DoorConfigVariables.rlp.rawValue:
            self.doorConfig.buttonPressesDelay =  Int(ketValueArr[1])!
        case DoorConfigModel.DoorConfigVariables.rlt.rawValue:
            self.doorConfig.buttonPressTime =  Int(ketValueArr[1])!
        case DoorConfigModel.DoorConfigVariables.mtt.rawValue:
            self.doorConfig.doorMovingTime =  Int(ketValueArr[1])!
        case DoorConfigModel.DoorConfigVariables.srt.rawValue:
            self.doorConfig.reflectionThreshold =  Int(ketValueArr[1])!
        case DoorConfigModel.DoorConfigVariables.srr.rawValue:
            self.doorConfig.sensorReadsAmount =  Int(ketValueArr[1])!
        case DoorConfigModel.DoorConfigVariables.rdt.rawValue:
            self.doorConfig.sensorScanInterval =  Int(ketValueArr[1])!
        case DoorConfigModel.DoorConfigVariables.aot.rawValue:
            self.doorConfig.openTimeout =  Int(ketValueArr[1])!
        case DoorConfigModel.DoorConfigVariables.aev.rawValue:
            self.doorConfig.statusAlerts =  Int(ketValueArr[1])!
        case DoorConfigModel.DoorConfigVariables.nme.rawValue:
            self.doorConfig.name =  ketValueArr[1]
        case DoorStatusModel.DoorStatusVariables.status.rawValue:
            self.doorStatus.status =  ketValueArr[1]
        default:
            break
        }
    }
    
}
