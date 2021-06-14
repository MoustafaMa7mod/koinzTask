//
//  ViewController.swift
//  Koniz
//
//  Created by Mostafa Mahmoud on 6/13/21.
//

import UIKit
import RealmSwift

class NotesViewController: UIViewController {

    // MARK: - outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK:- variables
    let notesViewModel = NotesViewModel()
    var notificationToken: NotificationToken?

    // MARK: - main functions
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationConfig()
        tableViewConfig()
        addObserver()
        loadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObserver()
    }
    
    // MARK: - observe realm when add and delete and update
    func addObserver() {
        notificationToken = self.notesViewModel.notes?.observe() { [weak self] (changes) in
            guard let self = self else {return}
            
            switch changes {
            case .initial(let notes):
                print("Initial case \(notes.count)")
            case .update( _, let deletions, let insertions, let modifications):
                print(deletions)
                print(modifications)
                print(insertions)
                self.loadData()
            case .error(let error):
                print(error.localizedDescription)
            }
        }
        
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

