//
//  Services.swift
//  ColorPickerApp
//
//  Created by Valya on 6.02.22.
//

import UIKit

final class Services: UIViewController {
    
    static func rgbConvert(_ number: String?) -> Float {
        if let number = number {
            return (Float(number) ?? 0 > 1) ? 1 : Float(number) ?? 0
        }
        return 0
    }
    
}
