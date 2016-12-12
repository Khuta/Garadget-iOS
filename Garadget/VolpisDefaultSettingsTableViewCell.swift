//
//  VolpisDefaultSettingsTableViewCell.swift
//  Garadget
//
//  Created by Volpis on 10.12.16.
//  Copyright © 2016 Volpis. All rights reserved.
//

import UIKit

protocol SettingsCellProtocol {
    func didAskForDataPicker(for indexPath: IndexPath)
    func didAskForNameChanging(newNameValue: String)
}

class VolpisDefaultSettingsTableViewCell: UITableViewCell {

    var currentSettingItem: [String:AnyObject] = [String: AnyObject]()
    var currentIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    var delegate: SettingsCellProtocol? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateContentData() {
        
    }
}
