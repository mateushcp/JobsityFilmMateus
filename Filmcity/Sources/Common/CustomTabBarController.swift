//
//  CustomTabBarController.swift
//  Filmcity
//
//  Created by Mateus Henrique Coelho de Paulo on 19/06/25.
//

import UIKit

final class CustomTabBarController: UITabBarController {

  override func viewDidLoad() {
    super.viewDidLoad()
    configureAppearance()
  }

  private func configureAppearance() {
    let appearance = UITabBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = Colors.gray300
    
    appearance.shadowImage = nil
    appearance.shadowColor = nil

    let normalItem = appearance.stackedLayoutAppearance.normal
    normalItem.iconColor = Colors.gray400
    normalItem.titleTextAttributes = [
      .font: Typography.bodyXS,
      .foregroundColor: Colors.gray400
    ]

    let selectedItem = appearance.stackedLayoutAppearance.selected
    selectedItem.iconColor = Colors.purpleBase
    selectedItem.titleTextAttributes = [
      .font: Typography.bodyXS,
      .foregroundColor: Colors.purpleBase
    ]

    tabBar.standardAppearance = appearance
    if #available(iOS 15.0, *) {
      tabBar.scrollEdgeAppearance = appearance
    }

    tabBar.tintColor = Colors.purpleBase
    tabBar.unselectedItemTintColor = Colors.gray400

    tabBar.items?.forEach { item in
      item.imageInsets = UIEdgeInsets(top: 12, left: 0, bottom: -6, right: 0)
    }
  }
}
