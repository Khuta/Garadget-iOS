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
    
    
    init(doorConfig: DoorConfigModel, doorStatus: DoorStatusModel, netConfig: NetConfigModel, device: SparkDevice) {
        self.doorConfig = doorConfig
        self.doorStatus = doorStatus
        self.netConfig = netConfig
        self.device = device
    }
    
}
