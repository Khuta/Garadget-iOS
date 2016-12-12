//
//  VolpisAlertBTableViewCell.swift
//  Garadget
//
//  Created by Volpis on 12.12.16.
//  Copyright © 2016 Volpis. All rights reserved.
//

import UIKit

class VolpisAlertBTableViewCell: VolpisDefaultAlertsTableViewCell {
    
    @IBOutlet weak var keyTitleLabel: UILabel!
    @IBOutlet weak var alertSwitch: UISwitch!
    @IBOutlet weak var valueTextField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    override func updateContentData() {
        self.keyTitleLabel.text = self.currentAlertItem["key"] as! String?
        if "\(self.currentAlertItem["value"]!)" == "0" {
            self.alertSwitch.setOn(false, animated: true)
        } else {
            self.alertSwitch.setOn(true, animated: true)
        }
        
        self.valueTextField.text = InternalHelper().getNormalValueInArr(by: self.currentAlertItem["value"]! as AnyObject, and: AlertsData().alertTimeoutTimes)
    }
    
    // MARK: - Actions
    @IBAction func didChangeSwitchValue(_ sender: Any) {
        if alertSwitch.isOn {
            self.delegate?.didAskForChangingTimeOutAlert(with: "30", and: self.currentIndexPath)
        } else {
            self.delegate?.didAskForChangingTimeOutAlert(with: "0", and: self.currentIndexPath)
        }
    }
    
    @IBAction func didPressTextFieldButton(_ sender: Any) {
        self.delegate?.didAskForDataPicker(for: self.currentIndexPath)
    }
}
