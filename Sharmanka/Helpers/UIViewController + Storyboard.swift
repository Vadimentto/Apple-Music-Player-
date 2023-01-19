//
//  UIViewController + Storyboard.swift
//  Sharmanka
//
//  Created by Vadym Potapov on 12.01.2023.
//

import UIKit

extension UIViewController {
    
    // если в проекте есть файл с одинаковым названием для view controller то в этом случае, компелятор будет подгружать в первую очередь файл storyboard
    
    class func loadFromStoryboard<T: UIViewController> () -> T {
        
        let name = String(describing: T.self)
        let storyboard = UIStoryboard(name: name, bundle: nil)
        if let viewController = storyboard.instantiateInitialViewController() as? T {
            return viewController
        } else {
            fatalError("Error: no initial view controller in \(name) storyboard!")
        }
    }
}
