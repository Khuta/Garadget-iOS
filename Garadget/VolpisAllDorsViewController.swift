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

private let doorCellIdentifier = "DoorCell"

class VolpisAllDorsViewController: DefaultGaradgetViewController {
    
    
    @IBOutlet weak var allDoorsView: UIView!
    @IBOutlet weak var allDoorsCollectionView: UICollectionView!
    @IBOutlet weak var doorImageView: UIImageView!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var doorNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    
    var allDoors: NSMutableArray = NSMutableArray()
    var selectedDoor: DoorModel = DoorModel()
    
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
                    
                    var index = 0
                    
                    for device in sparkDevices as! [SparkDevice] {
                        
                        var doorConfigString = ""
                        var doorStatusString = ""
                        var netConfigString = ""
                        
                        if device.connected {
                            print("1")
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
                                                    
                                                    self.allDoors.add(door)
                                                    index = index + 1
                                                    
                                                    if index == (sparkDevices?.count)! {
                                                        self.selectedDoor = self.allDoors[0] as! DoorModel
                                                        self.allDoors.removeObject(at: 0)
                                                        self.allDoorsCollectionView.reloadData()
                                                        self.didUpdateCurrentDoorData()
                                                        
                                                    }
                                                }
                                            })
                                        }
                                    })
                                }
                            })
                        } else {
                            let door = DoorModel(doorConfig: DoorConfigModel(), doorStatus: DoorStatusModel(), netConfig: NetConfigModel(), device: device)
                            self.allDoors.add(door)
                            index = index + 1
                            
                            if index == (sparkDevices?.count)! {
                                self.selectedDoor = self.allDoors[0] as! DoorModel
                                self.allDoors.removeObject(at: 0)
                                self.allDoorsCollectionView.reloadData()
                                self.didUpdateCurrentDoorData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func didUpdateCurrentDoorData() {
        self.doorImageView.image = self.selectedDoor.getDoorImage()
        self.statusImageView.image = self.selectedDoor.getSignalImage()
        
        self.doorNameLabel.text = self.selectedDoor.getDoorName()
        
        if self.selectedDoor.device.connected {
            self.timeLabel.text = "\(InternalHelper.DoorStatusConstants.open.rawValue) \(self.selectedDoor.doorStatus.time)"
        } else {
            self.timeLabel.text = "\(InternalHelper.DoorStatusConstants.offline.rawValue) \(self.selectedDoor.getFormattedTime())"
        }
    }

    // MARK: - Navigation
}

extension VolpisAllDorsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.allDoors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let doorCell = collectionView.dequeueReusableCell(withReuseIdentifier: doorCellIdentifier, for: indexPath) as! VolpisDoorCollectionViewCell
        doorCell.currentDoor = self.allDoors[indexPath.row] as! DoorModel
        doorCell.updateContentData()
        return doorCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tempDoor: DoorModel = self.allDoors[indexPath.row] as! DoorModel
        self.allDoors.replaceObject(at: indexPath.row, with: self.selectedDoor)
        self.selectedDoor = tempDoor
        self.allDoorsCollectionView.reloadItems(at: [IndexPath(item: indexPath.row, section: 0)])
        self.didUpdateCurrentDoorData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath:IndexPath) -> CGSize {
        return CGSize(width: self.allDoorsView.frame.size.height * 0.8, height: self.allDoorsView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width - (self.allDoorsView.frame.size.height * 0.8 * CGFloat(self.allDoors.count)), bottom: 0, right: 0)
    }
}
