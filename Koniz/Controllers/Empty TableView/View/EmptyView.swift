//
//  EmptyView.swift
//  Koniz
//
//  Created by Mostafa Mahmoud on 6/13/21.
//

import UIKit

class EmptyView: UIView {
 
    @IBAction func addFirstNoteAction(_ sender: Any) {
        if let parent = self.parentViewController{
            let viewController = AddNoteViewController.instantiate()
            parent.navigationController?.pushViewController(viewController, animated: true)
         }
    }
    
}
