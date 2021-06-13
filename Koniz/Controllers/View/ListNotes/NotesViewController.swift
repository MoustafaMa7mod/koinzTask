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
    
    let arra = ["dsgdfgdfkjghdfklgjfdhglkjdsfhgklsdjfhgsdkjfghsdkljghdsjfdskfsdlkfjghsdflkjghsdlkfgjshdflgkjsdhfgjksdhfglksdjhfgdskjfghsdlkjfghsdkfljghdskfjghsdfklghsdfkjgsd" , "dsfghdjfsdhfkjshfajfsaf" , "Mostafa"]
    
    // MARK: - main functions
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationConfig()
        tableViewConfig()
        
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
    }

    


}

