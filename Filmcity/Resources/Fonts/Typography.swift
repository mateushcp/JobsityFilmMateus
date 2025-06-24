//
//  Typography.swift
//  Filmcity
//
//  Created by Mateus Henrique Coelho de Paulo on 19/06/25.
//

import UIKit

enum Typography {
    
    static var display: UIFont {
        UIFont(name: "RammettoOne-Regular", size: 20)
        ?? UIFont.systemFont(ofSize: 20, weight: .regular)
    }
    
    static var titleXL: UIFont {
        UIFont(name: "Rajdhani-Bold", size: 24)
        ?? UIFont.systemFont(ofSize: 24, weight: .bold)
    }
    
    static var titleLG: UIFont {
        UIFont(name: "Rajdhani-Bold", size: 28)
        ?? UIFont.systemFont(ofSize: 28, weight: .bold)
    }
    
    static var titleMD: UIFont {
        UIFont(name: "Rajdhani-Bold", size: 16)
        ?? UIFont.systemFont(ofSize: 16, weight: .bold)
    }
    
    static var bodyMD: UIFont {
        UIFont(name: "NunitoSans-Regular", size: 16)
        ?? UIFont.systemFont(ofSize: 16, weight: .regular)
    }
    
    static var bodySM: UIFont {
        UIFont(name: "NunitoSans-Regular", size: 14)
        ?? UIFont.systemFont(ofSize: 14, weight: .regular)
    }
    
    static var bodyXS: UIFont {
        UIFont(name: "NunitoSans-Regular", size: 12)
        ?? UIFont.systemFont(ofSize: 12, weight: .regular)
    }
    
    static var bodyMDBold: UIFont {
        UIFont(name: "NunitoSans-Bold", size: 16)
        ?? UIFont.systemFont(ofSize: 16, weight: .bold)
    }
    
    static var bodySMBold: UIFont {
        UIFont(name: "NunitoSans-Bold", size: 14)
        ?? UIFont.systemFont(ofSize: 14, weight: .bold)
    }
    
    static var bodyXSBold: UIFont {
        UIFont(name: "NunitoSans-Bold", size: 12)
        ?? UIFont.systemFont(ofSize: 12, weight: .bold)
    }
}
