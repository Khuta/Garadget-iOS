//
//  VolpisSettingsViewController.swift
//  Garadget
//
//  Created by Volpis on 10.12.16.
//  Copyright © 2016 Volpis. All rights reserved.
//

import UIKit
import Spark_SDK
import MBProgressHUD

class VolpisSettingsViewController: UIViewController {
    
    @IBOutlet weak var settingsTableView: UITableView!
    
    
    var currentDoor: DoorModel = DoorModel()
    var settings: [[[String:AnyObject]]] = [[[String:AnyObject]]]()
    
    var dropDowbVC: VolpisDropDownViewController = VolpisDropDownViewController()
    
    enum CellTypes {
        case cellA
        case cellB
        case cellC
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareData()
        self.prepareNavigationBar()
    }
    
    func prepareNavigationBar() {
        let newBackButton = UIBarButtonItem(image: UIImage(named: "backArrow"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(VolpisSettingsViewController.back(sender:)))
        self.navigationItem.title = InternalHelper.DefaultStrings.settings.rawValue
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    func prepareData() {
        var tempArr: [[String:AnyObject]] = [[String:AnyObject]]()
        self.settings.removeAll()
        //Device->id
        tempArr.append(self.didCreateCellItem(key: "ID", value: self.currentDoor.device.id as AnyObject, subValues: "" as AnyObject, cellType: .cellA, particleKey: ""))
        //Device->name
        tempArr.append(self.didCreateCellItem(key: "Name", value: self.currentDoor.getDoorName() as AnyObject, subValues: "" as AnyObject, cellType: .cellB, particleKey: ""))
        //Device->status
        if self.currentDoor.device.connected {
            tempArr.append(self.didCreateCellItem(key: "Status", value: InternalHelper.DoorStatusConstants.open.rawValue as AnyObject, subValues: "" as AnyObject, cellType: .cellA, particleKey: ""))
        } else {
            tempArr.append(self.didCreateCellItem(key: "Status", value: InternalHelper.DoorStatusConstants.normal.rawValue as AnyObject, subValues: "" as AnyObject, cellType: .cellA, particleKey: ""))
        }
        //Device->last connect
        tempArr.append(self.didCreateCellItem(key: "Last Contact", value: "\(self.currentDoor.getLastContactMillis() / 1000) sec ago" as AnyObject, subValues: "" as AnyObject, cellType: .cellA, particleKey: ""))
        
        if self.currentDoor.device.connected {
            //Device->version
            tempArr.append(self.didCreateCellItem(key: "Firmware Version", value: self.currentDoor.doorConfig.version as AnyObject, subValues: "" as AnyObject, cellType: .cellA, particleKey: ""))
            self.settings.append(tempArr)
            tempArr.removeAll()
            
            //WiFi Radio->ssid
            tempArr.append(self.didCreateCellItem(key: "WiFi SSID", value: self.currentDoor.netConfig.ssid as AnyObject, subValues: "" as AnyObject, cellType: .cellA, particleKey: ""))
            //WiFi Radio->signal strength
            tempArr.append(self.didCreateCellItem(key: "Signal Strength", value: self.currentDoor.doorStatus.signalStrength as AnyObject, subValues: "" as AnyObject, cellType: .cellA, particleKey: ""))
            //WiFi Radio->ip
            tempArr.append(self.didCreateCellItem(key: "IP", value: self.currentDoor.netConfig.ipAddress as AnyObject, subValues: "" as AnyObject, cellType: .cellA, particleKey: ""))
            //WiFi Radio->geteway
            tempArr.append(self.didCreateCellItem(key: "Gateway", value: self.currentDoor.netConfig.gateway as AnyObject, subValues: "" as AnyObject, cellType: .cellA, particleKey: ""))
            //WiFi Radio->ip mask
            tempArr.append(self.didCreateCellItem(key: "IP Mask", value: self.currentDoor.netConfig.subnet as AnyObject, subValues: "" as AnyObject, cellType: .cellA, particleKey: ""))
            //WiFi Radio->mac
            tempArr.append(self.didCreateCellItem(key: "MAC", value: self.currentDoor.netConfig.macAddress as AnyObject, subValues: "" as AnyObject, cellType: .cellA, particleKey: ""))
            self.settings.append(tempArr)
            
            tempArr.removeAll()
            //Sensor->reflection
            tempArr.append(self.didCreateCellItem(key: "Reflection", value: self.currentDoor.doorStatus.reflectionRate as AnyObject, subValues: "" as AnyObject, cellType: .cellA, particleKey: ""))
            //Sensor->scan period
            tempArr.append(self.didCreateCellItem(key: "Scan Period", value: InternalHelper().getNormalValueInArr(by: self.currentDoor.doorConfig.sensorScanInterval as AnyObject, and: SettingsData().scanPeriods) as AnyObject, subValues: SettingsData().scanPeriods as AnyObject, cellType: .cellC, particleKey: DoorConfigModel.DoorConfigVariables.rdt.rawValue))
            //Sensor->sensor reads
            tempArr.append(self.didCreateCellItem(key: "Sensor Reads", value: InternalHelper().getNormalValueInArr(by: self.currentDoor.doorConfig.sensorReadsAmount as AnyObject, and: SettingsData().sensorReads) as AnyObject, subValues: SettingsData().sensorReads as AnyObject, cellType: .cellC, particleKey: DoorConfigModel.DoorConfigVariables.srr.rawValue))
            //Sensor->sensor threshold
            tempArr.append(self.didCreateCellItem(key: "Sensor Threshold", value: InternalHelper().getNormalValueInArr(by: self.currentDoor.doorConfig.reflectionThreshold as AnyObject, and: SettingsData().sensorThresholds) as AnyObject, subValues: SettingsData().sensorThresholds as AnyObject, cellType: .cellC, particleKey: DoorConfigModel.DoorConfigVariables.srt.rawValue))
            self.settings.append(tempArr)
            
            tempArr.removeAll()
            //Door->door motion time
            tempArr.append(self.didCreateCellItem(key: "Door Motion Time", value: InternalHelper().getNormalValueInArr(by: self.currentDoor.doorConfig.doorMovingTime as AnyObject, and: SettingsData().doorMotionTimes) as AnyObject, subValues: SettingsData().doorMotionTimes as AnyObject, cellType: .cellC, particleKey: DoorConfigModel.DoorConfigVariables.mtt.rawValue))
            //Door->relay on time
            tempArr.append(self.didCreateCellItem(key: "Relay On Time", value: InternalHelper().getNormalValueInArr(by: self.currentDoor.doorConfig.buttonPressTime as AnyObject, and: SettingsData().relayOnTimes) as AnyObject, subValues: SettingsData().relayOnTimes as AnyObject, cellType: .cellC, particleKey: DoorConfigModel.DoorConfigVariables.rlt.rawValue))
            //Door->relay off time
            tempArr.append(self.didCreateCellItem(key: "Relay Off Time", value: InternalHelper().getNormalValueInArr(by: self.currentDoor.doorConfig.buttonPressesDelay as AnyObject, and: SettingsData().relayOffTimes) as AnyObject, subValues: SettingsData().relayOffTimes as AnyObject, cellType: .cellC, particleKey: DoorConfigModel.DoorConfigVariables.rlp.rawValue))
            self.settings.append(tempArr)
        } else {
            self.settings.append(tempArr)
        }
        self.settingsTableView.reloadData()
    }
    
    func didCreateCellItem(key: String, value: AnyObject, subValues: AnyObject, cellType: CellTypes, particleKey: String) -> [String:AnyObject] {
        var item: [String:AnyObject] = [String: AnyObject]()
        item = [
            "key" : key as AnyObject,
            "value" : value,
            "subValues": subValues,
            "cellType": cellType as AnyObject,
            "particleKey": particleKey as AnyObject
        ]
        return item
    }
    
    func didCloseDropDownVC() {
        UIView.animate(withDuration: 0.5, animations: {
            self.dropDowbVC.view.frame = CGRect(x: 0, y: self.view.frame.size.height, width: self.view.frame.size.width, height: self.view.frame.size.height*0.3)
        }) { (success) in
            self.dropDowbVC.view.removeFromSuperview()
            self.dropDowbVC.removeFromParentViewController()
        }
    }

    // MARK: - Navigation
    func back(sender: UIBarButtonItem) {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers 
        
        for aViewController in viewControllers {
            if(aViewController is VolpisAllDorsViewController) {
                let destinationVC = aViewController as! VolpisAllDorsViewController
                destinationVC.needUpdateData = true
                destinationVC.selectedDoor = self.currentDoor
                self.navigationController!.popToViewController(destinationVC, animated: true)
            }
        }
    }
    
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
        settingsCell.delegate = self
        settingsCell.currentIndexPath = indexPath
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

extension VolpisSettingsViewController: SettingsCellProtocol {
    func didAskForDataPicker(for indexPath: IndexPath) {
        let currentItem = self.settings[indexPath.section][indexPath.row]
        
        self.dropDowbVC = InternalHelper.StoryboardType.settings.getStoryboard().instantiateViewController(withIdentifier: "DropDownVC") as! VolpisDropDownViewController
        self.dropDowbVC.delegate = self
        self.dropDowbVC.currentParticleKey = currentItem["particleKey"] as!String
        self.dropDowbVC.selectedValue = "\(currentItem["value"]!)"
        self.dropDowbVC.currentData = currentItem["subValues"] as! [String]
        self.dropDowbVC.view.frame = CGRect(x: 0, y: self.view.frame.size.height, width: self.view.frame.size.width, height: self.view.frame.size.height*0.3)
        self.view.addSubview(self.dropDowbVC.view)
        self.addChildViewController(self.dropDowbVC)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.dropDowbVC.view.frame = CGRect(x: 0, y: self.view.frame.size.height - self.view.frame.size.height*0.3, width: self.view.frame.size.width, height: self.view.frame.size.height*0.3)
        }) { (success) in
        }
    }
    
    func didAskForNameChanging(newNameValue: String) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        SparkCloud.sharedInstance().getDevice(self.currentDoor.device.id) { (device, error) in
            if error == nil {
                device?.rename(newNameValue, completion: { (error) in
                    if error == nil {
                        device?.callFunction(InternalHelper.CallbackFunctions.updateConfig.rawValue, withArguments: ["nme=\(newNameValue)"], completion: { (resultCode, error) in
                            if error == nil {
                                self.currentDoor.updateDoorData(value: "nme=\(newNameValue)")
                                MBProgressHUD.hide(for: self.view, animated: true)
                            }
                        })
                    }
                })
            }
        }
    }
}

extension VolpisSettingsViewController: DropDownProtocol {
    func didAskUpdateData(value: String) {
        self.didCloseDropDownVC()
        let funcArgs = [value]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        SparkCloud.sharedInstance().getDevice(self.currentDoor.device.id) { (device, error) in
            if error == nil {
                device?.callFunction(InternalHelper.CallbackFunctions.updateConfig.rawValue, withArguments: funcArgs, completion: { (resultCode, error) in
                    if error == nil {
                        self.currentDoor.updateDoorData(value: value)
                        self.prepareData()
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                })
            }
        }
    }
    
    func didAskCloseVC() {
        self.didCloseDropDownVC()
    }
}
