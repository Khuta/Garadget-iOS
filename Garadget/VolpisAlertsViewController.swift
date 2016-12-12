//
//  VolpisAlertsViewController.swift
//  Garadget
//
//  Created by Volpis on 12.12.16.
//  Copyright © 2016 Volpis. All rights reserved.
//

import UIKit
import Spark_SDK

class VolpisAlertsViewController: UIViewController {
    
    
    @IBOutlet weak var alertsListTableView: UITableView!

    var currentDoor: DoorModel = DoorModel()
    var alerts: [[[String:AnyObject]]] = [[[String:AnyObject]]]()
    var binaryArr: NSMutableArray = NSMutableArray()
    
    var dropDowbVC: VolpisDropDownViewController = VolpisDropDownViewController()
    
    enum CellTypes {
        case cellA
        case cellB
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareData()
        self.prepareNavigationBar()
    }
    
    func prepareNavigationBar() {
        let newBackButton = UIBarButtonItem(image: UIImage(named: "backArrow"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(VolpisAlertsViewController.back(sender:)))
        self.navigationItem.title = InternalHelper.DefaultStrings.alerts.rawValue
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    func prepareData() {
        var binaryStr = self.pad(string: String(self.currentDoor.doorConfig.statusAlerts, radix: 2), toSize: 8)
        binaryStr = String(binaryStr.characters.reversed())
        self.binaryArr.removeAllObjects()
        for ch in binaryStr.characters {
            self.binaryArr.add(String(ch))
        }
        var tempArr: [[String:AnyObject]] = [[String:AnyObject]]()
        self.alerts.removeAll()
        
        //Events alert
        tempArr.append(self.didCreateCellItem(key: "Reboot:", value: self.binaryArr[5] as AnyObject, subValues: "" as AnyObject, cellType: CellTypes.cellA, particleKey: DoorConfigModel.DoorConfigVariables.aev.rawValue, position: 5))
        tempArr.append(self.didCreateCellItem(key: "Online:", value: self.binaryArr[6] as AnyObject, subValues: "" as AnyObject, cellType: CellTypes.cellA, particleKey: DoorConfigModel.DoorConfigVariables.aev.rawValue, position: 6))
        tempArr.append(self.didCreateCellItem(key: "Open:", value: self.binaryArr[3] as AnyObject, subValues: "" as AnyObject, cellType: CellTypes.cellA, particleKey: DoorConfigModel.DoorConfigVariables.aev.rawValue, position: 3))
        tempArr.append(self.didCreateCellItem(key: "Closed:", value: self.binaryArr[0] as AnyObject, subValues: "" as AnyObject, cellType: CellTypes.cellA, particleKey: DoorConfigModel.DoorConfigVariables.aev.rawValue, position: 0))
        tempArr.append(self.didCreateCellItem(key: "Stopped:", value: self.binaryArr[4] as AnyObject, subValues: "" as AnyObject, cellType: CellTypes.cellA, particleKey: DoorConfigModel.DoorConfigVariables.aev.rawValue, position: 4))
        tempArr.append(self.didCreateCellItem(key: "Offline:", value: self.binaryArr[7] as AnyObject, subValues: "" as AnyObject, cellType: CellTypes.cellA, particleKey: DoorConfigModel.DoorConfigVariables.aev.rawValue, position: 7))
        self.alerts.append(tempArr)
        
        //Timeout alerts
        tempArr.removeAll()
        tempArr.append(self.didCreateCellItem(key: "Enabled", value: self.currentDoor.doorConfig.openTimeout as AnyObject, subValues: AlertsData().alertTimeoutTimes as AnyObject, cellType: CellTypes.cellB, particleKey: DoorConfigModel.DoorConfigVariables.aot.rawValue, position: 0))
        self.alerts.append(tempArr)
        
        self.alertsListTableView.reloadData()
    }
    
    func pad(string : String, toSize: Int) -> String {
        var padded = string
        for _ in 0..<(toSize - string.characters.count) {
            padded = "0" + padded
        }
        return padded
    }
    
    func didCreateCellItem(key: String, value: AnyObject, subValues: AnyObject, cellType: CellTypes, particleKey: String, position: Int) -> [String:AnyObject] {
        var item: [String:AnyObject] = [String: AnyObject]()
        item = [
            "key" : key as AnyObject,
            "value" : value,
            "subValues": subValues,
            "cellType": cellType as AnyObject,
            "position": position as AnyObject,
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
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }

}

extension VolpisAlertsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.alerts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.alerts[section]).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentItem = self.alerts[indexPath.section][indexPath.row]
        let alertCell = tableView.dequeueReusableCell(withIdentifier: InternalHelper.sharedInstance.getAlertsCellIdentifier(by: currentItem["cellType"] as! CellTypes), for: indexPath) as! VolpisDefaultAlertsTableViewCell
        alertCell.delegate = self
        alertCell.currentIndexPath = indexPath
        alertCell.currentAlertItem = currentItem
        alertCell.updateContentData()
        return alertCell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "EVENT ALERTS"
        case 1:
            return "TIMEOUT ALERTS"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let currentItem = self.alerts[indexPath.section][indexPath.row]
        switch currentItem["cellType"] as! CellTypes {
        case .cellA:
            return 40.0
        case .cellB:
            if "\(currentItem["value"]!)" == "0" {
                return 40.0
            } else {
                return 80.0
            }
        }
        
    }
}

extension VolpisAlertsViewController: AlertsProtocol {
    func didAskForDataPicker(for indexPath: IndexPath) {
        let currentItem = self.alerts[indexPath.section][indexPath.row]
        
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
    
    func didUpdateCongigs(with newValue: String) {
        self.currentDoor.updateDoorData(value: newValue)
        self.prepareData()
        SparkCloud.sharedInstance().getDevice(self.currentDoor.device.id) { (device, error) in
            if error == nil {
                device?.callFunction(InternalHelper.CallbackFunctions.updateConfig.rawValue, withArguments: [newValue], completion: { (resultCode, error) in
                    if error == nil {
                        
                    }
                })
            }
        }
    }
    
    func didAskForChangingEventsAlert(for pisition: Int, and value: String, and indexPath: IndexPath) {
        self.binaryArr.replaceObject(at: pisition, with: value)
        var str: String = ""
        for ch in self.binaryArr {
            str = "\(str)\(ch)"
        }
        str = String(str.characters.reversed())
        let currentItem = self.alerts[indexPath.section][indexPath.row]
        if let number = Int(str, radix: 2) {
            self.didUpdateCongigs(with: "\(currentItem["particleKey"] as! String)=\(number)")
        }
    }
    
    func didAskForChangingTimeOutAlert(with value: String, and indexPath: IndexPath) {
        let currentItem = self.alerts[indexPath.section][indexPath.row]
        self.didUpdateCongigs(with: "\(currentItem["particleKey"] as! String)=\(value)")
    }
}

extension VolpisAlertsViewController: DropDownProtocol {
    func didAskUpdateData(value: String) {
        self.didCloseDropDownVC()
        let funcArgs = [value]
        
        SparkCloud.sharedInstance().getDevice(self.currentDoor.device.id) { (device, error) in
            if error == nil {
                device?.callFunction(InternalHelper.CallbackFunctions.updateConfig.rawValue, withArguments: funcArgs, completion: { (resultCode, error) in
                    if error == nil {
                        self.currentDoor.updateDoorData(value: value)
                        self.prepareData()
                    }
                })
            }
        }
    }
    
    func didAskCloseVC() {
        self.didCloseDropDownVC()
    }
}
