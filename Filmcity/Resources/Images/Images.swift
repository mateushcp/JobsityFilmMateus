//
//  Images.swift
//  Filmcity
//
//  Created by Mateus Henrique Coelho de Paulo on 19/06/25.
//

import UIKit

enum Images {
    private static let fallback = UIImage(systemName: "photo")!

    static var splashTriangle: UIImage { UIImage(named: "animatedSplashTriangle") ?? fallback }

    static var mainLogo: UIImage { UIImage(named: "mainLogo") ?? fallback }

    static var backgroundPattern: UIImage { UIImage(named: "suaBackgroundPattern") ?? fallback }
}
