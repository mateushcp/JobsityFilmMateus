//
//  Colors.swift
//  Filmcity
//
//  Created by Mateus Henrique Coelho de Paulo on 19/06/25.
//

import UIKit

enum Colors {
    static let purpleBase = UIColor(hex: "#892CCD")
    static let purpleLight = UIColor(hex: "#A85FDD")
    
    static let gray100 = UIColor(hex: "#0F0F1A")
    static let gray200 = UIColor(hex: "#131320")
    static let gray300 = UIColor(hex: "#1A1B2D")
    static let gray400 = UIColor(hex: "#45455F")
    static let gray500 = UIColor(hex: "#7A7B9F")
    static let gray600 = UIColor(hex: "#B5B6C9")
    static let gray700 = UIColor(hex: "#E4E5EC")
    static let white = UIColor(hex: "#FFFFFF")
}

private extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1) {
        var hexClean = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexClean = hexClean.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        Scanner(string: hexClean).scanHexInt64(&rgb)
        let r = CGFloat((rgb & 0xFF0000) >> 16)/255
        let g = CGFloat((rgb & 0x00FF00) >> 8)/255
        let b = CGFloat( rgb & 0x0000FF       )/255
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}
