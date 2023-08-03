//
//  SCIColor+Hex.swift
//  SCIVisualiser
//
//  Created by Anup D'Souza on 03/08/23.
//

import Foundation
import UIKit
import SwiftUI

extension UIColor {
    class func colorWithRGBHex(_ hex: UInt32) -> UIColor {
        let r = CGFloat((hex >> 16) & 0xFF)
        let g = CGFloat((hex >> 8) & 0xFF)
        let b = CGFloat(hex & 0xFF)
        
        return UIColor(
            red: r / 255.0,
            green: g / 255.0,
            blue: b / 255.0,
            alpha: 1.0
        )
    }
    
    class func colorWithHexString(_ hexString: String) -> UIColor? {
        var hexNum: UInt32 = 0
        var scanner: Scanner?
        
        var sanitizedHexString = hexString
        if sanitizedHexString.hasPrefix("#") {
            sanitizedHexString.removeFirst()
        }
        
        scanner = Scanner(string: sanitizedHexString)
        if let scanner = scanner, scanner.scanHexInt32(&hexNum) {
            return UIColor.colorWithRGBHex(hexNum)
        }
        
        return nil
    }
}

extension Color {
    static func colorWithRGBHex(_ hex: UInt32) -> Color {
        let uiColor = UIColor.colorWithRGBHex(hex)
        return Color(uiColor)
    }
    
    static func colorWithHexString(_ hexString: String) -> Color? {
        guard let uiColor = UIColor.colorWithHexString(hexString) else {
            return nil
        }
        return Color(uiColor)
    }
}
