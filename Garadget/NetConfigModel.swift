//
//  NetConfigModel.swift
//  Garadget
//
//  Created by Volpis on 09.12.16.
//  Copyright © 2016 Volpis. All rights reserved.
//

import UIKit

class NetConfigModel: NSObject {
    
    enum NetConfigVariables: String {
        case ip = "ip"
        case snet = "snet"
        case gway = "gway"
        case mac = "mac"
        case ssid = "ssid"
    }
    
    var ipAddress: String //ip
    var subnet: String //snet
    var gateway: String //gway
    var macAddress: String //mac
    var ssid: String //ssid
    
    override init() {
        self.ipAddress = ""
        self.subnet = ""
        self.gateway = ""
        self.macAddress = ""
        self.ssid = ""
    }
    
    
    init(netConfigString : String) {
        self.ipAddress = ""
        self.subnet = ""
        self.gateway = ""
        self.macAddress = ""
        self.ssid = ""
        
        let variablesArr = netConfigString.components(separatedBy: "|")
        
        for variableItem in variablesArr {
            let nextVariable = variableItem.components(separatedBy: "=")
            
            switch nextVariable[0] {
            case NetConfigVariables.ip.rawValue:
                self.ipAddress = nextVariable[1]
            case NetConfigVariables.snet.rawValue:
                self.subnet = nextVariable[1]
            case NetConfigVariables.gway.rawValue:
                self.gateway = nextVariable[1]
            case NetConfigVariables.mac.rawValue:
                self.macAddress = nextVariable[1]
            case NetConfigVariables.ssid.rawValue:
                self.ssid = nextVariable[1]
            default:
                break
            }
        }
    }

}
