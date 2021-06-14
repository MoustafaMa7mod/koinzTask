//
//  UIViewController.swift
//  Koniz
//
//  Created by Mostafa Mahmoud on 6/15/21.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showAlertView(withMessage message: String, handlerOk: ((UIAlertAction) -> Void)? = nil){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: handlerOk))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
