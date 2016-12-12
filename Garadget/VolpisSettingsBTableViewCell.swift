//
//  VolpisSettingsBTableViewCell.swift
//  Garadget
//
//  Created by Volpis on 10.12.16.
//  Copyright © 2016 Volpis. All rights reserved.
//

import UIKit

class VolpisSettingsBTableViewCell: VolpisDefaultSettingsTableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var titleKeyLabel: UILabel!
    @IBOutlet weak var valueTextField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func updateContentData() {
        self.titleKeyLabel.text = self.currentSettingItem["key"] as! String?
        self.valueTextField.text = "\(self.currentSettingItem["value"]!)"
        self.valueTextField.addTarget(self, action: #selector(VolpisSettingsBTableViewCell.textFieldDidChangeValue), for: UIControlEvents.editingChanged)
    }
    
    // MARK: - UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    // MARK: - Actions
    func textFieldDidChangeValue() {
        self.delegate?.didAskForNameChanging(newNameValue: self.valueTextField.text!)
    }

}
