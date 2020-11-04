//
//  UIColor+AskNot.swift
//  AskNot
//
//  Created by Elliot Schrock on 8/13/17.
//  Copyright © 2017 billygoatsgruff. All rights reserved.
//

import LUX

extension UIColor {
    public static func primary() -> UIColor {
        return UIColor(hex: 0x25677b)
    }
    
    public static func primaryDark() -> UIColor {
        return UIColor(hex: 0x15576b)
    }
    
    public static func accent() -> UIColor {
        return UIColor(hex: 0xED2359)
    }
    
    public static func reverse() -> UIColor {
        return UIColor.white
    }
}
