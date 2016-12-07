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
        
        /*
         Function that based on the storyboard type returns an instance of the storyboard file
         */
        func getStoryboard() -> UIStoryboard {
            switch self {
            case .main:
                return UIStoryboard(name: "Main", bundle: nil)
            }
        }
        
        func getViewControllerIdentifier()->String {
            return ""
        }
    }
    
    //MARK:- Shared Instance Implementation
    static let sharedInstance: InternalHelper = InternalHelper()
    
}
