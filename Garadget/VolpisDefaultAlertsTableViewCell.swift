//
//  VolpisDefaultAlertsTableViewCell.swift
//  Garadget
//
//  Created by Volpis on 12.12.16.
//  Copyright © 2016 Volpis. All rights reserved.
//

import UIKit

protocol AlertsProtocol {
    func didAskForChangingEventsAlert(for position: Int, and value: String, and indexPath: IndexPath)
    func didAskForChangingTimeOutAlert(with value: String, and indexPath: IndexPath)
    func didAskForDataPicker(for indexPath: IndexPath)
}

class VolpisDefaultAlertsTableViewCell: UITableViewCell {
    
    var currentAlertItem: [String:AnyObject] = [String: AnyObject]()
    var currentIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    
    var delegate: AlertsProtocol? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateContentData() {
        
    }

}
