//
//  VolpisSettingsCTableViewCell.swift
//  Garadget
//
//  Created by Volpis on 10.12.16.
//  Copyright © 2016 Volpis. All rights reserved.
//

import UIKit

class VolpisSettingsCTableViewCell: VolpisDefaultSettingsTableViewCell {
    
    @IBOutlet weak var titleKeyLabel: UILabel!
    @IBOutlet weak var valueTextField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func updateContentData() {
        self.titleKeyLabel.text = self.currentSettingItem["key"] as! String?
        self.valueTextField.text = "\(self.currentSettingItem["value"]!)"
    }
}
