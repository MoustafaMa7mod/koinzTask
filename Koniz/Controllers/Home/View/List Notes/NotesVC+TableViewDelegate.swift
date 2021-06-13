//
//  NotesVC+TableViewDelegate.swift
//  Koniz
//
//  Created by Mostafa Mahmoud on 6/13/21.
//

import Foundation
import UIKit


extension NotesViewController: UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arra.count == 0 {
            self.tableView.setEmptyView()
        } else {
            self.tableView.restore()
        }

        return arra.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as NoteCell
        cell.noteBodyLabel.text = arra[indexPath.row]
        return cell
    }

    
}

