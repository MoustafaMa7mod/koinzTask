//
//  ViewController.swift
//  Koniz
//
//  Created by Mostafa Mahmoud on 6/13/21.
//

import UIKit
import RealmSwift
import CoreLocation

class NotesViewController: UIViewController {

    // MARK: - outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK:- variables
    let notesViewModel = NotesViewModel()
    var notificationToken: NotificationToken?
    let locationManager = CLLocationManager()

    // MARK: - main functions
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationConfig()
        tableViewConfig()
        startTrackingUser()
        addObserver()
        loadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObserver()
        startTrackingUser()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        locationManager.stopUpdatingLocation()
    }
    

    // MARK:- navigation setting
    private func navigationConfig(){
        title = "Notes"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(AddNewNote))

    }
    
    
    // MARK:- table view setting
    private func tableViewConfig(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.registerCellNib(cellClass: NoteCell.self)
    }
    
    // MARK: - observe realm when add and delete and update
    func addObserver() {
        notificationToken = self.notesViewModel.notes?.observe() { [weak self] (changes) in
            guard let self = self else {return}
            switch changes {
            case .initial(let notes):
                print("Initial case \(notes.count)")
                self.updateDataInRealm(notes)
            case .update(let notes, _, _, _):
                self.updateDataInRealm(notes)
            case .error(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    // MARK: - start tracking location when user allow premission
    private func startTrackingUser(){
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    // MARK: - load data from realm
    private func loadData(){
        notesViewModel.getData { [weak self] loadTableView in
            guard let self = self else {return}
            self.tableView.reloadData()
        }
    }
    
    // MARK: - update realm data when change in note list
    private func updateDataInRealm(_ notesUpdated: Results<NoteObject>? ){
        self.notesViewModel.updateCurrentData(notesUpdated: notesUpdated) { [weak self] loadTableView in
            guard let self = self else {return}
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Action to add new note
    @objc func AddNewNote(){
        let viewController = AddNoteViewController.instantiate()
        viewController.operationType = .add
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}
