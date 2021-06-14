//
//  ViewController.swift
//  Koniz
//
//  Created by Mostafa Mahmoud on 6/13/21.
//

import UIKit

class NotesViewController: UIViewController {

    // MARK: - outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK:- variables
    let notesViewModel = NotesViewModel()
    
    // MARK: - main functions
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationConfig()
        tableViewConfig()
        loadData()
    }
    
    // MARK:- table view setting
    private func tableViewConfig(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.registerCellNib(cellClass: NoteCell.self)
    }
    
    // MARK:- navigation setting
    private func navigationConfig(){
        title = "Notes"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(AddNewNote))

    }

    @objc func AddNewNote(){
        let viewController = AddNoteViewController.instantiate()
        viewController.operationType = .add
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func loadData(){
        notesViewModel.getData { [weak self] loadTableView in
            guard let self = self else {return}
            self.tableView.reloadData()
        }
    }

    


}

