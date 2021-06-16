//
//  AddNoteViewController.swift
//  Koniz
//
//  Created by Mostafa Mahmoud on 6/13/21.
//

import UIKit
import RealmSwift
import CoreLocation
import RxCocoa
import RxSwift
import Photos

enum OperationType {
    case edit
    case add
}

class AddNoteViewController: UIViewController {
   
    // MARK: - outlets
    @IBOutlet weak var noteTitleTextField: UITextField!
    @IBOutlet weak var noteBodyTextField: UITextViewPlaceHolder!
    @IBOutlet weak var addLocationView: UIView!
    @IBOutlet weak var addImageView: UIView!
    @IBOutlet weak var notedImage: UIImageView!
    @IBOutlet weak var noteLocationLabel: UILabel!
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var addPhotoLabel: UILabel!
    // MARK:- variables
    lazy var imagePickerController: UIImagePickerController = {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .savedPhotosAlbum
        controller.allowsEditing = false
        return controller
    }()
    
    let locationManager = CLLocationManager()
    var viewModel = AddNoteViewModel()
    var latitudeValue = BehaviorRelay<Double>(value: 0.0)
    var longitudeValue = BehaviorRelay<Double>(value: 0.0)
    var imagePathValue = BehaviorRelay<String>(value: "")
    var noteObject: NoteObject?
    var operationType: OperationType = .add
    var disposed = DisposeBag()

    
    // MARK: - main functions
    override func viewDidLoad() {
        super.viewDidLoad()
        addGesterImage()
        addGesterLocation()
        navigationConfig()
        configure(with: viewModel)
        showDataWhenEditNote(viewModel: viewModel)
    }
    
    // MARK:- navigation setting
    private func navigationConfig(){
        title = "Add Note"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "left-arrow"), style: .plain, target: self, action: #selector(addTapped))

    }
    // MARK: - get instance from storyboard to push from other view controller
    class func instantiate() -> AddNoteViewController {
        let storyboard : UIStoryboard = UIStoryboard(name: "Notes", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! AddNoteViewController
    }

    // MARK:- config RX to bind data
    func configure(with viewModel: AddNoteViewModel) {
        self.noteTitleTextField.rx.text.map { $0 ?? "" }.bind(to: viewModel.noteTitle).disposed(by: disposed)
        self.noteBodyTextField.rx.text.map { $0 ?? "" }.bind(to: viewModel.noteBody).disposed(by: disposed)
        self.latitudeValue.bind(to: viewModel.noteLatitude).disposed(by: disposed)
        self.longitudeValue.bind(to: viewModel.noteLongitude).disposed(by: disposed)
        self.imagePathValue.bind(to: viewModel.noteImagePath).disposed(by: self.disposed)
    }
    
    func showDataWhenEditNote(viewModel: AddNoteViewModel){
        if operationType == .edit {
            viewModel.loadDataFromRealm(noteObject ?? NoteObject())
        }
        viewModel.reloadView = { [weak self] in
            guard let self = self else {return}
            self.noteTitleTextField.text = viewModel.noteTitle.value
            self.noteBodyTextField.text = viewModel.noteBody.value
            self.latitudeValue.accept(viewModel.noteLatitude.value)
            self.longitudeValue.accept(viewModel.noteLongitude.value)

            if viewModel.notePlace.value == "" {
                if self.latitudeValue.value != 0.0 &&  self.longitudeValue.value != 0.0{
                    self.noteLocationLabel.text = viewModel.showLocationDetails()
                }
            }else{
                self.noteLocationLabel.text = viewModel.notePlace.value
            }
            self.imagePathValue.accept(viewModel.noteImagePath.value)

            if let image = UIImage().renderImageFromDocs(imageName: viewModel.noteImagePath.value) {
                self.notedImage.isHidden = false
                self.imageViewHeight.constant = 140
                self.addPhotoLabel.isHidden = true
                self.notedImage.image = image
            }else{
                self.notedImage.isHidden = true
                self.imageViewHeight.constant = 60
                self.addPhotoLabel.isHidden = false

            }
            self.configure(with: viewModel)
        }
        
     
    }
    
    // MARK:- add gester view to upload image
    private func addGesterImage(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(uploadPhoto(tapGestureRecognizer:)))
        addImageView.isUserInteractionEnabled = true
        addImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // MARK:- add gester view to get current location
    private func addGesterLocation(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(getCurrentUserLocation(tapGestureRecognizer:)))
        addLocationView.isUserInteractionEnabled = true
        addLocationView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    // MARK: - Actions
    @objc func uploadPhoto(tapGestureRecognizer: UITapGestureRecognizer){
        self.checkPhotoLibraryPermission()
    }
    
    @objc func getCurrentUserLocation(tapGestureRecognizer: UITapGestureRecognizer){
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    @objc func addTapped(){
        guard  self.noteTitleTextField.text != "" else {
            self.showAlertView(withMessage: "Please add note title.") { action in
                self.navigationController?.popViewController(animated: true)
            }
            return
        }
        if operationType == .add {
            viewModel.insertNote()
        }else{
            viewModel.updateNote()
        }
        self.navigationController?.popViewController(animated: true)
    }
}
