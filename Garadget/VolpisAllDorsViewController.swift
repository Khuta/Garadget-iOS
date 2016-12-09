//
//  VolpisAllDorsViewController.swift
//  Garadget
//
//  Created by Volpis on 07.12.16.
//  Copyright © 2016 Volpis. All rights reserved.
//

import UIKit
import SWRevealViewController
import Spark_SDK

class VolpisAllDorsViewController: DefaultGaradgetViewController {
    
    var allDoors: [DoorModel] = [DoorModel]()
    
    enum DeviceVariables: String {
        case doorConfig = "doorConfig"
        case doorStatus = "doorStatus"
        case netConfig = "netConfig"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareSWRevealView()
        self.prepareNavigationController()
        self.prepareData()
    }
    
    func prepareSWRevealView() {
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        let menuButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_tab_settings"), style: UIBarButtonItemStyle.plain, target: self.revealViewController(), action:#selector(self.revealViewController().revealToggle(_:)))
        menuButton.tintColor = UIColor.white
        
        self.navigationItem.leftBarButtonItem = menuButton
    }
    
    func prepareNavigationController() {
        self.navigationController?.navigationBar.barTintColor = InternalHelper.GaradgetColors.green.getColor()
        self.navigationItem.title = InternalHelper.DefaultStrings.allDoorsNavTitle.rawValue
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
    
    func prepareData() {
        SparkCloud.sharedInstance().getDevices { (sparkDevices, error) in
            if (error != nil) {
                print(error.debugDescription)
            } else {
                if (sparkDevices as? [SparkDevice]) != nil {
                    
                    //Set Doors models
                    for device in sparkDevices as! [SparkDevice] {
                        
                        var doorConfigString = ""
                        var doorStatusString = ""
                        var netConfigString = ""
                        
                        if device.connected {
                            device.getVariable(DeviceVariables.doorConfig.rawValue, completion: { (result, error) in
                                if !(error != nil) {
                                    doorConfigString = result as! String
                                    
                                    device.getVariable(DeviceVariables.doorStatus.rawValue, completion: { (result, error) in
                                        if !(error != nil) {
                                            doorStatusString = result as! String
                                            
                                            device.getVariable(DeviceVariables.netConfig.rawValue, completion: { (result, error) in
                                                if !(error != nil) {
                                                    netConfigString = result as! String
                                                    
                                                    let doorConfig = DoorConfigModel(doorConfigString: doorConfigString)
                                                    let doorStatus = DoorStatusModel(doorStatusString: doorStatusString)
                                                    let netConfig = NetConfigModel(netConfigString: netConfigString)
                                                    
                                                    let door = DoorModel(doorConfig: doorConfig, doorStatus: doorStatus, netConfig: netConfig, device: device)
                                                    
                                                    self.allDoors.append(door)
                                                }
                                            })
                                        }
                                    })
                                }
                            })
                        }
                    }
                }
            }
        }
    }

    // MARK: - Navigation


}
