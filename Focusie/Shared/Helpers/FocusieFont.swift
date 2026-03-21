//
//  FocusieFont.swift
//  Focusie
//
//  Created by Anastasia Mousa on 10/3/26.
//

import SwiftUI

enum FocusieFont {
    
    static func regular(size: CGFloat) -> Font {
        .custom("DMSans-Regular", size: size)
    }
    
    static func medium(size: CGFloat) -> Font {
        .custom("DMSans-Medium", size: size)
    }
    
    static func semiBold(size: CGFloat) -> Font {
        .custom("DMSans-SemiBold", size: size)
    }
    
    static func light(size: CGFloat) -> Font {
        .custom("DMSans-Light", size: size)
    }
    
}
