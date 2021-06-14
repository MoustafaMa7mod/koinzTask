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
        if notesViewModel.getCountOfNotes() == 0 {
            self.tableView.setEmptyView()
        } else {
            self.tableView.restore()
        }

        return notesViewModel.getCountOfNotes()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as NoteCell
        let object = notesViewModel.getEachNotes(indexPath.row)
        cell.configCell(object)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = notesViewModel.getEachNotes(indexPath.row)
        let viewController = AddNoteViewController.instantiate()
        viewController.noteObject = object
        viewController.operationType = .edit
        self.navigationController?.pushViewController(viewController, animated: true)        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            self.notesViewModel.deleteNote(withIndex: indexPath.row) { deleted in
                print(deleted)
            }
        }
    }
    

    
}

