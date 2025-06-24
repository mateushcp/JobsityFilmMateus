//
//  Icons.swift
//  Filmcity
//
//  Created by Mateus Henrique Coelho de Paulo on 19/06/25.
//

import UIKit

enum Icons {
    private static let fallback = UIImage(systemName: "exclamationmark.triangle.fill")!

    static var close : UIImage { UIImage(named: "XCircle-Fill") ?? fallback }
    static var favorite : UIImage { UIImage(named: "Star-Fill") ?? fallback }
    static var slate : UIImage { UIImage(named: "FilmSlate-Regular") ?? fallback }
    static var search : UIImage { UIImage(named: "MagnifyingGlass-Regular") ?? fallback }
    static var back : UIImage { UIImage(named: "ArrowLeft-Regular") ?? fallback }
    static var youtube : UIImage { UIImage(named: "YoutubeLogo-Regular") ?? fallback }
    static var bookmark : UIImage { UIImage(named: "BookmarkSimple-Fill") ?? fallback }
    static var list : UIImage { UIImage(named: "ListBullets-Regular") ?? fallback }
    static var trash : UIImage { UIImage(named: "TrashSimple-Regular") ?? fallback }
}
