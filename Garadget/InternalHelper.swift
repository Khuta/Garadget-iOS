//
//  InternalHelper.swift
//  Garadget
//
//  Created by Volpis on 07.12.16.
//  Copyright © 2016 Volpis. All rights reserved.
//

import UIKit
import Foundation

class InternalHelper {
    
    enum SettigCellIdentifiers: String {
        case cellAIdentifier = "SettingsCellTypeA"
        case cellBIdentifier = "SettingsCellTypeB"
        case cellCIdentifier = "SettingsCellTypeC"
    }
    
    enum DoorStatusConstants: String {
        case open = "open"
        case closed = "closed"
        case closing = "closing"
        case opening = "opening"
        case stopped = "stopped"
        case offline = "offline"
        case normal = "normal"
    }
    
    enum ViewControllerIdentifier: String {
        case swRevealVC = "SWRevealVC"
        case allDorsVC = "AllDorsVC"
        case loginVC = "LoginVC"
    }
    
    enum DefaultStrings: String {
        case allDoorsNavTitle = "Doors"
    }
    
    enum GaradgetColors {
        case green
        
        func getColor() -> UIColor {
            switch self {
            case .green:
                return UIColor(red: 0.0/255.0, green: 102/255.0, blue: 0.0/255.0, alpha: 1.0)
            }
        }
    }
    
    enum StoryboardType {
        case main
        case settings
        
        /*
         Function that based on the storyboard type returns an instance of the storyboard file
         */
        func getStoryboard() -> UIStoryboard {
            switch self {
            case .main:
                return UIStoryboard(name: "Main", bundle: nil)
            case.settings:
                return UIStoryboard(name: "SettingsStoryboard", bundle: nil)
            }
        }
        
        func getViewControllerIdentifier()->String {
            return ""
        }
    }
    
    //MARK:- Shared Instance Implementation
    static let sharedInstance: InternalHelper = InternalHelper()
    
    func getSettingsCellIdentifier(by type: VolpisSettingsViewController.CellTypes) -> String {
        switch type {
        case .cellA:
            return SettigCellIdentifiers.cellAIdentifier.rawValue
        case .cellB:
            return SettigCellIdentifiers.cellBIdentifier.rawValue
        default:
            return SettigCellIdentifiers.cellCIdentifier.rawValue
        }
    }
    
}
