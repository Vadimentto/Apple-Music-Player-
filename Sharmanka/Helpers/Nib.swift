//
//  Nib.swift
//  Sharmanka
//
//  Created by Vadym Potapov on 15.01.2023.
//

import UIKit

extension UIView {
    
    class func loadFromNib<T: UIView>() -> T {
       
        
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil)![0] as! T
    }
}
