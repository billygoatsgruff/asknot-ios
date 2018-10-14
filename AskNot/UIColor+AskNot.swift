//
//  UIColor+AskNot.swift
//  AskNot
//
//  Created by Elliot Schrock on 8/13/17.
//  Copyright © 2017 billygoatsgruff. All rights reserved.
//

import UIKit

extension UIColor {
    open static func primary() -> UIColor {
        return uicolorFromHex(rgbValue: 0x25677b)
    }
    
    open static func accent() -> UIColor {
        return uicolorFromHex(rgbValue: 0xED2359)
    }
    
    static func uicolorFromHex(rgbValue: UInt32) -> UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
}
