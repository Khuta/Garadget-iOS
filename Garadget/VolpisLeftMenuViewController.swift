//
//  VolpisLeftMenuViewController.swift
//  Garadget
//
//  Created by Volpis on 08.12.16.
//  Copyright © 2016 Volpis. All rights reserved.
//

import UIKit
import Spark_SDK

class VolpisLeftMenuViewController: UIViewController {

    @IBOutlet weak var userEmailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.prepareData()
    }
    
    func prepareData() {
        self.userEmailLabel.text = SparkCloud.sharedInstance().loggedInUsername
    }
    
    // MARK: - Actions
    @IBAction func didPressLogoutButton(_ sender: Any) {
        SparkCloud.sharedInstance().logout()
        
        (UIApplication.shared.delegate as! AppDelegate).moveToRootVC()
        
    }

}
