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
import SparkSetup
import UICircularProgressRing
import MBProgressHUD

private let doorCellIdentifier = "DoorCell"

class VolpisAllDorsViewController: DefaultGaradgetViewController {
    
    
    @IBOutlet weak var allDoorsView: UIView!
    @IBOutlet weak var allDoorsCollectionView: UICollectionView!
    @IBOutlet weak var doorImageView: UIImageView!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var doorNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var circleProgressBar: UICircularProgressRingView!
    
    var needUpdateData: Bool = false
    
    var allDoors: NSMutableArray = NSMutableArray()
    var selectedDoor: DoorModel = DoorModel()
    
    enum DeviceVariables: String {
        case doorConfig = "doorConfig"
        case doorStatus = "doorStatus"
        case netConfig = "netConfig"
    }
    
    enum SegueIdentifiers: String {
        case toSettings = "FromAllDoorsToSettings"
        case toAlerts = "FromAllDoorsToAlerts"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareSWRevealView()
        self.prepareNavigationController()
        self.prepareRefresh()
        self.prepareData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if needUpdateData {
            needUpdateData = false
            self.didUpdateCurrentDoorData()
        }
    }
    
    func prepareRefresh() {
        let refreshGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer()
        refreshGesture.addTarget(self, action: #selector(VolpisAllDorsViewController.swiped(_:)))
        refreshGesture.direction = .down
        self.view.addGestureRecognizer(refreshGesture)
    }
    
    func swiped(_ gesture: UIGestureRecognizer) {
        self.prepareData()
    }
    
    func prepareSWRevealView() {
        let menuButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "settingsIcon"), style: UIBarButtonItemStyle.plain, target: self.revealViewController(), action:#selector(self.revealViewController().revealToggle(_:)))
        menuButton.tintColor = UIColor.white
        
        self.navigationItem.leftBarButtonItem = menuButton
    }
    
    func prepareNavigationController() {
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = InternalHelper.GaradgetColors.green.getColor()
        self.navigationItem.title = InternalHelper.DefaultStrings.allDoorsNavTitle.rawValue
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
    
    func prepareData() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.allDoors.removeAllObjects()
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
                                                        MBProgressHUD.hide(for: self.view, animated: true)
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
                                MBProgressHUD.hide(for: self.view, animated: true)
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueIdentifier = segue.identifier {
            if segueIdentifier == SegueIdentifiers.toSettings.rawValue {
                let destinationVC = segue.destination as! VolpisSettingsViewController
                destinationVC.currentDoor = self.selectedDoor
            } else if segueIdentifier == SegueIdentifiers.toAlerts.rawValue {
                let destinationVC = segue.destination as! VolpisAlertsViewController
                destinationVC.currentDoor = self.selectedDoor
            }
        }
    }
    
    // MARK: - Load spark vc
    func didLoadSparkVC() {
        if let setupController = SparkSetupMainController(setupOnly : true) {
            
            let customizationVC = SparkSetupCustomization.sharedInstance()
            customizationVC?.pageBackgroundColor = UIColor.gray
            customizationVC?.brandName = InternalHelper.DefaultStrings.brand.rawValue
            customizationVC?.brandImage = UIImage(named: "header_icon_black")
            customizationVC?.brandImageBackgroundColor = UIColor.clear
            customizationVC?.productImage = UIImage(named: "garadget_device")
            customizationVC?.elementBackgroundColor = UIColor(colorLiteralRed: 0.0/255.0, green: 102.0/255.0, blue: 1.0/255.0, alpha: 1.0)
            customizationVC?.linkTextColor = UIColor.black
            setupController.delegate = self
            self.present(setupController, animated: true, completion: nil)
        }
    }

    // MARK: - Actions
    @IBAction func didPressUpdateDoorButton(_ sender: Any) {
        
        if self.selectedDoor.device.connected {
            var newStatus = ""
            var animateImages: [UIImage] = [UIImage]()
            if self.selectedDoor.doorStatus.status == InternalHelper.DoorStatusConstants.open.rawValue {
                newStatus = InternalHelper.DoorStatusConstants.closed.rawValue
                animateImages = DoorData().dorImages.reversed()
            } else if self.selectedDoor.doorStatus.status == InternalHelper.DoorStatusConstants.stopped.rawValue {
                newStatus = InternalHelper.DoorStatusConstants.closed.rawValue
                animateImages = DoorData().dorStopedImages.reversed()
            } else {
                newStatus = InternalHelper.DoorStatusConstants.open.rawValue
                animateImages = DoorData().dorImages
            }
            self.doorImageView.image = animateImages.last
            self.doorImageView.animationImages = animateImages
            self.doorImageView.animationDuration = TimeInterval(self.selectedDoor.doorConfig.doorMovingTime / 1000)
            self.doorImageView.animationRepeatCount = 1
            self.doorImageView.startAnimating()
            
            self.circleProgressBar.fontColor = UIColor.white
            self.circleProgressBar.isHidden = false
            self.circleProgressBar.setProgress(value: 100, animationDuration: TimeInterval(self.selectedDoor.doorConfig.doorMovingTime / 1000)) {
                self.circleProgressBar.isHidden = true
                self.circleProgressBar.setProgress(value: 0, animationDuration: 1.0, completion: nil)
                
            }
            
            SparkCloud.sharedInstance().getDevice(self.selectedDoor.device.id) { (device, error) in
                if error == nil {
                    device?.callFunction(InternalHelper.CallbackFunctions.setState.rawValue, withArguments: [newStatus], completion: { (resultCode, error) in
                        if error == nil {
                            self.selectedDoor.updateDoorData(value: "\(DoorStatusModel.DoorStatusVariables.status.rawValue)=\(newStatus)")
                        }
                    })
                }
            }
        } else {
            self.showAlert(with: InternalHelper.DefaultStrings.brand.rawValue, and: "Device with name \(self.selectedDoor.getDoorName()) is offline")
        }
    }
    
    @IBAction func didPressSettingsButton(_ sender: Any) {
        self.performSegue(withIdentifier: SegueIdentifiers.toSettings.rawValue, sender: self)
    }
    
    @IBAction func didPressAlertsButton(_ sender: Any) {
        if self.selectedDoor.device.connected {
            self.performSegue(withIdentifier: SegueIdentifiers.toAlerts.rawValue, sender: self)
        } else {
            self.showAlert(with: InternalHelper.DefaultStrings.brand.rawValue, and: "Device with name \(self.selectedDoor.getDoorName()) is offline")
        }
        
    }
    
    @IBAction func didPressAddDoorButton(_ sender: Any) {
        self.didLoadSparkVC()
    }
    
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

extension VolpisAllDorsViewController: SparkSetupMainControllerDelegate {
    func sparkSetupViewController(_ controller: SparkSetupMainController!, didNotSucceeedWithDeviceID deviceID: String!) {
        
    }
    
    func sparkSetupViewController(_ controller: SparkSetupMainController!, didFinishWith result: SparkSetupMainControllerResult, device: SparkDevice!) {
        controller.delegate = nil
    }
}
