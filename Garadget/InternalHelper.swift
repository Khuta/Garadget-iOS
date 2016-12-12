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
    
    enum AlertCellIdentifiers: String {
        case cellAIdentifier = "AlertCellTypeA"
        case cellBIdentifier = "AlertCellTypeB"
    }
    
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
        case settings = "Settings"
        case alerts = "Alerts"
        case brand = "Garadget"
    }
    
    enum CallbackFunctions: String {
        case setState = "setState"
        case updateConfig = "setConfig"
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
        case alerts
        
        /*
         Function that based on the storyboard type returns an instance of the storyboard file
         */
        func getStoryboard() -> UIStoryboard {
            switch self {
            case .main:
                return UIStoryboard(name: "Main", bundle: nil)
            case.settings:
                return UIStoryboard(name: "SettingsStoryboard", bundle: nil)
            case .alerts:
                return UIStoryboard(name: "AlertsStoryboard", bundle: nil)
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
    
    func getAlertsCellIdentifier(by type: VolpisAlertsViewController.CellTypes) -> String {
        switch type {
        case .cellA:
            return AlertCellIdentifiers.cellAIdentifier.rawValue
        case .cellB:
            return AlertCellIdentifiers.cellBIdentifier.rawValue
        }
    }
    
    func getNormalValueInArr(by str: AnyObject, and arr: [String]) -> String {
        for item in arr {
            let newArr = item.components(separatedBy: "|")
            if newArr[1] == "\(str)" {
                return newArr[0]
            }
        }
        return ""
    }
    
}
