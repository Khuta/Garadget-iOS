//
//  VolpisDoorCollectionViewCell.swift
//  Garadget
//
//  Created by Volpis on 09.12.16.
//  Copyright © 2016 Volpis. All rights reserved.
//

import UIKit

class VolpisDoorCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var doorImageView: UIImageView!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var doorNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var currentDoor: DoorModel = DoorModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func updateContentData() {
        self.doorImageView.image = self.currentDoor.getDoorImage()
        self.statusImageView.image = self.currentDoor.getSignalImage()
        
        self.doorNameLabel.text = self.currentDoor.getDoorName()
        
        if self.currentDoor.device.connected {
            self.timeLabel.text = "\(InternalHelper.DoorStatusConstants.open.rawValue) \(self.currentDoor.doorStatus.time)"
        } else {
            self.timeLabel.text = "\(InternalHelper.DoorStatusConstants.offline.rawValue) \(self.currentDoor.getFormattedTime())"
        }
    }
    
}
