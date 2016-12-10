//
//  VolpisSettingsViewController.swift
//  Garadget
//
//  Created by Volpis on 10.12.16.
//  Copyright © 2016 Volpis. All rights reserved.
//

import UIKit

class VolpisSettingsViewController: UIViewController {
    
    @IBOutlet weak var settingsTableView: UITableView!
    
    
    var currentDoor: DoorModel = DoorModel()
    var settings: [[[String:AnyObject]]] = [[[String:AnyObject]]]()
    
    enum CellTypes {
        case cellA
        case cellB
        case cellC
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareData()
    }
    
    func prepareData() {
        var tempArr: [[String:AnyObject]] = [[String:AnyObject]]()
        
        //Device->id
        tempArr.append(self.didCreateCellItem(key: "ID", value: self.currentDoor.device.id as AnyObject, subValues: "" as AnyObject, cellType: .cellA))
        //Device->name
        tempArr.append(self.didCreateCellItem(key: "Name", value: self.currentDoor.getDoorName() as AnyObject, subValues: "" as AnyObject, cellType: .cellB))
        //Device->status
        if self.currentDoor.device.connected {
            tempArr.append(self.didCreateCellItem(key: "Status", value: InternalHelper.DoorStatusConstants.open.rawValue as AnyObject, subValues: "" as AnyObject, cellType: .cellA))
        } else {
            tempArr.append(self.didCreateCellItem(key: "Status", value: InternalHelper.DoorStatusConstants.normal.rawValue as AnyObject, subValues: "" as AnyObject, cellType: .cellA))
        }
        //Device->last connect
        tempArr.append(self.didCreateCellItem(key: "Last Contact", value: "\(self.currentDoor.getLastContactMillis() / 1000) sec ago" as AnyObject, subValues: "" as AnyObject, cellType: .cellA))
        
        if self.currentDoor.device.connected {
            //Device->version
            tempArr.append(self.didCreateCellItem(key: "Firmware Version", value: self.currentDoor.doorConfig.version as AnyObject, subValues: "" as AnyObject, cellType: .cellA))
            self.settings.append(tempArr)
            tempArr.removeAll()
            
            //WiFi Radio->ssid
            tempArr.append(self.didCreateCellItem(key: "WiFi SSID", value: self.currentDoor.netConfig.ssid as AnyObject, subValues: "" as AnyObject, cellType: .cellA))
            //WiFi Radio->signal strength
            tempArr.append(self.didCreateCellItem(key: "Signal Strength", value: self.currentDoor.doorStatus.signalStrength as AnyObject, subValues: "" as AnyObject, cellType: .cellA))
            //WiFi Radio->ip
            tempArr.append(self.didCreateCellItem(key: "IP", value: self.currentDoor.netConfig.ipAddress as AnyObject, subValues: "" as AnyObject, cellType: .cellA))
            //WiFi Radio->geteway
            tempArr.append(self.didCreateCellItem(key: "Gateway", value: self.currentDoor.netConfig.gateway as AnyObject, subValues: "" as AnyObject, cellType: .cellA))
            //WiFi Radio->ip mask
            tempArr.append(self.didCreateCellItem(key: "IP Mask", value: self.currentDoor.netConfig.subnet as AnyObject, subValues: "" as AnyObject, cellType: .cellA))
            //WiFi Radio->mac
            tempArr.append(self.didCreateCellItem(key: "MAC", value: self.currentDoor.netConfig.macAddress as AnyObject, subValues: "" as AnyObject, cellType: .cellA))
            self.settings.append(tempArr)
            
            tempArr.removeAll()
            //Sensor->reflection
            tempArr.append(self.didCreateCellItem(key: "Reflection", value: self.currentDoor.doorStatus.reflectionRate as AnyObject, subValues: "" as AnyObject, cellType: .cellA))
            //Sensor->scan period
            tempArr.append(self.didCreateCellItem(key: "Scan Period", value: "" as AnyObject, subValues: "" as AnyObject, cellType: .cellC))
            //Sensor->sensor reads
            tempArr.append(self.didCreateCellItem(key: "Sensor Reads", value: "" as AnyObject, subValues: "" as AnyObject, cellType: .cellC))
            //Sensor->sensor threshold
            tempArr.append(self.didCreateCellItem(key: "Sensor Threshold", value: "" as AnyObject, subValues: "" as AnyObject, cellType: .cellC))
            self.settings.append(tempArr)
            
            tempArr.removeAll()
            //Door->door motion time
            tempArr.append(self.didCreateCellItem(key: "Door Motion Time", value: "" as AnyObject, subValues: "" as AnyObject, cellType: .cellC))
            //Door->relay on time
            tempArr.append(self.didCreateCellItem(key: "Relay On Time", value: "" as AnyObject, subValues: "" as AnyObject, cellType: .cellC))
            //Door->relay off time
            tempArr.append(self.didCreateCellItem(key: "Relay Off Time", value: "" as AnyObject, subValues: "" as AnyObject, cellType: .cellC))
            self.settings.append(tempArr)
        } else {
            self.settings.append(tempArr)
        }
        self.settingsTableView.reloadData()
    }
    
    func didCreateCellItem(key: String, value: AnyObject, subValues: AnyObject, cellType: CellTypes) -> [String:AnyObject] {
        var item: [String:AnyObject] = [String: AnyObject]()
        item = [
            "key" : key as AnyObject,
            "value" : value,
            "subValues": subValues,
            "cellType": cellType as AnyObject
        ]
        return item
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }

}

extension VolpisSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.settings.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.settings[section]).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentItem = self.settings[indexPath.section][indexPath.row]
        let settingsCell = tableView.dequeueReusableCell(withIdentifier: InternalHelper.sharedInstance.getSettingsCellIdentifier(by: currentItem["cellType"] as! CellTypes), for: indexPath) as! VolpisDefaultSettingsTableViewCell
        settingsCell.currentSettingItem = currentItem
        settingsCell.updateContentData()
        return settingsCell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "DEVICE"
        case 1:
            return "WiFi RADIO"
        case 2:
            return "SENSOR"
        case 3:
            return "DOOR"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
}
