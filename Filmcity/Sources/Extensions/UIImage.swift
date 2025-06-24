//
//  UIImage.swift
//  Filmcity
//
//  Created by Mateus Henrique Coelho de Paulo on 23/06/25.
//
import UIKit

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        self.draw(in: CGRect(origin: .zero, size: size))
        let result = UIGraphicsGetImageFromCurrentImageContext() ?? self
        UIGraphicsEndImageContext()
        return result.withRenderingMode(self.renderingMode)
    }
}
