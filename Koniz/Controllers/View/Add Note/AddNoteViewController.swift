//
//  AddNoteViewController.swift
//  Koniz
//
//  Created by Mostafa Mahmoud on 6/13/21.
//

import UIKit

class AddNoteViewController: UIViewController {
  
 
    // MARK: - outlets

    var emptyView: EmptyView?
    
    // MARK: - main functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - get instance from storyboard to push from other view controller
    class func instantiate() -> AddNoteViewController {
        let storyboard : UIStoryboard = UIStoryboard(name: "Notes", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! AddNoteViewController
    }

}
