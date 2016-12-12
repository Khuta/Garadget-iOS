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

class VolpisLoginViewController: UIViewController {
    
    let setupController = SparkSetupMainController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !SparkCloud.sharedInstance().isAuthenticated {
            self.didLoadSparkVC()
        }
    }
    
    // MARK: - Load spark vc
    func didLoadSparkVC() {
        if let setupController = SparkSetupMainController(authenticationOnly: true) {
            
            let customizationVC = SparkSetupCustomization.sharedInstance()
            customizationVC?.pageBackgroundColor = UIColor.white
            customizationVC?.brandName = "Garadget"
            customizationVC?.brandImage = UIImage(named: "header_icon_black")
            customizationVC?.brandImageBackgroundColor = UIColor.white
            customizationVC?.elementBackgroundColor = UIColor(colorLiteralRed: 0.0/255.0, green: 102.0/255.0, blue: 1.0/255.0, alpha: 1.0)
            setupController.delegate = self
            self.present(setupController, animated: true, completion: nil)
        }
    }
}

extension VolpisLoginViewController: SparkSetupMainControllerDelegate {
    func sparkSetupViewController(_ controller: SparkSetupMainController!, didNotSucceeedWithDeviceID deviceID: String!) {
        
    }
    
    func sparkSetupViewController(_ controller: SparkSetupMainController!, didFinishWith result: SparkSetupMainControllerResult, device: SparkDevice!) {
        controller.delegate = nil
        let swRevealVC = InternalHelper.StoryboardType.main.getStoryboard().instantiateViewController(withIdentifier: InternalHelper.ViewControllerIdentifier.swRevealVC.rawValue)
        self.present(swRevealVC, animated: true, completion: nil)
    }
}

