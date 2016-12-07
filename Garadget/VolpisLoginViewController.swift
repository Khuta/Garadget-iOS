//
//  ViewController.swift
//  Garadget
//
//  Created by Volpis on 07.12.16.
//  Copyright © 2016 Volpis. All rights reserved.
//

import UIKit

import SparkSetup
import Spark_SDK

class VolpisLoginViewController: UIViewController, SparkSetupMainControllerDelegate {
    
    let setupController = SparkSetupMainController()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if SparkCloud.sharedInstance().isAuthenticated {
            SparkCloud.sharedInstance().logout()
        } else {
            self.didLoadSparkVC()
        }
    }
    
    func didLoadSparkVC() {
        if let setupController = SparkSetupMainController(authenticationOnly: true) {
            
            let customizationVC = SparkSetupCustomization.sharedInstance()
            customizationVC?.pageBackgroundColor = UIColor.white
            customizationVC?.brandName = "Garadget"
            customizationVC?.brandImage = UIImage(named: "header_icon_black")
            customizationVC?.brandImageBackgroundColor = UIColor.white
            
            setupController.delegate = self
            self.present(setupController, animated: false, completion: nil)
        }
    }

    func sparkSetupViewController(_ controller: SparkSetupMainController!, didNotSucceeedWithDeviceID deviceID: String!) {
        
    }
    
    func sparkSetupViewController(_ controller: SparkSetupMainController!, didFinishWith result: SparkSetupMainControllerResult, device: SparkDevice!) {
        controller.delegate = nil
    }
    
    

}

