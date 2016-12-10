//
//  VolpisSettingsATableViewCell.swift
//  Garadget
//
//  Created by Volpis on 10.12.16.
//  Copyright © 2016 Volpis. All rights reserved.
//

import UIKit

class VolpisSettingsATableViewCell: VolpisDefaultSettingsTableViewCell {
    
    @IBOutlet weak var titleKeyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func updateContentData() {
        self.titleKeyLabel.text = self.currentSettingItem["key"] as! String?
        self.valueLabel.text = "\(self.currentSettingItem["value"]!)"
    }

}
