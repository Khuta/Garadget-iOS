//
//  VolpisAlertATableViewCell.swift
//  Garadget
//
//  Created by Volpis on 12.12.16.
//  Copyright © 2016 Volpis. All rights reserved.
//

import UIKit

class VolpisAlertATableViewCell: VolpisDefaultAlertsTableViewCell {

    @IBOutlet weak var keyTitleLabel: UILabel!
    @IBOutlet weak var alertSwitch: UISwitch!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func updateContentData() {
        self.keyTitleLabel.text = self.currentAlertItem["key"] as! String?
        if self.currentAlertItem["value"] as! String == "1" {
            self.alertSwitch.setOn(true, animated: true)
        } else {
            self.alertSwitch.setOn(false, animated: true)
        }
    }
    
    // MARK: - Actions
    @IBAction func didChangeSwitchValue(_ sender: Any) {
        if alertSwitch.isOn {
            self.delegate?.didAskForChangingEventsAlert(for: self.currentAlertItem["position"] as! Int, and: "1", and: self.currentIndexPath)
        } else {
            self.delegate?.didAskForChangingEventsAlert(for: self.currentAlertItem["position"] as! Int, and: "0", and: self.currentIndexPath)
        }
    }
}
