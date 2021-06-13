//
//  UITableView+Extensions.swift
//  Koniz
//
//  Created by Mostafa Mahmoud on 6/13/21.
//

import UIKit
extension UITableView {
    
    func registerCellNib<Cell: UITableViewCell>(cellClass: Cell.Type){
        self.register(UINib(nibName: String(describing: Cell.self), bundle: nil), forCellReuseIdentifier: String(describing: Cell.self))
    }


    func dequeue<Cell: UITableViewCell>() -> Cell{
        let identifier = String(describing: Cell.self)
        
        guard let cell = self.dequeueReusableCell(withIdentifier: identifier) as? Cell else {
            fatalError("Error in cell")
        }
        
        return cell
    }
    
    func setEmptyView() {
        let bundle = Bundle(for: EmptyView.self)
        let nib = bundle.loadNibNamed("EmptyView", owner: self, options: nil)
        if let emptyView = nib?.first as? EmptyView {
            self.backgroundView = emptyView
        }
    }

    func restore() {
        self.backgroundView = nil
    }
        
}

