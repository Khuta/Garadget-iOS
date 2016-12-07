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
    
    var allDevices: [SparkDevice] = [SparkDevice]()

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
                    self.allDevices = sparkDevices as! [SparkDevice]
                }
            }
        }
    }

    // MARK: - Navigation


}
