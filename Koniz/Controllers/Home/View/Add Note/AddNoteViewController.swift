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

class AddNoteViewController: UIViewController {
   
    // MARK: - outlets
    @IBOutlet weak var noteTitleTextField: UITextField!
    @IBOutlet weak var noteBodyTextField: UITextViewPlaceHolder!
    @IBOutlet weak var addLocationView: UIView!
    @IBOutlet weak var addImageView: UIView!
    @IBOutlet weak var notedImage: UIImageView!
    @IBOutlet weak var noteLocationLabel: UILabel!
    
    // MARK:- variables
    lazy var imagePickerController: UIImagePickerController = {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .photoLibrary
        return controller
    }()
    
    let locationManager = CLLocationManager()
    let viewModel = AddNoteViewModel()
    var disposed = DisposeBag()

    
    // MARK: - main functions
    override func viewDidLoad() {
        super.viewDidLoad()
        addGesterImage()
        addGesterLocation()
        configure(with: viewModel)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
//        guard let path = Realm.Configuration.defaultConfiguration.fileURL?.path else {
//            fatalError("no realm path")
//        }
//
//        do {
//            try FileManager().removeItem(atPath: path)
//        } catch {
//            fatalError("couldn't remove at path")
//        }
        print(Realm.Configuration.defaultConfiguration.fileURL)

    }
    
    // MARK: - get instance from storyboard to push from other view controller
    class func instantiate() -> AddNoteViewController {
        let storyboard : UIStoryboard = UIStoryboard(name: "Notes", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! AddNoteViewController
    }

    // MARK:- config RX
    func configure(with viewModel: AddNoteViewModel) {
        noteTitleTextField.rx.text.map { $0 ?? "" }.bind(to: viewModel.noteTitle).disposed(by: disposed)
        noteBodyTextField.rx.text.map { $0 ?? "" }.bind(to: viewModel.noteBody).disposed(by: disposed)
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
        self.present(imagePickerController, animated: true, completion: nil)
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
        self.viewModel.insertNote()
        self.navigationController?.popViewController(animated: true)
    }
}

extension AddNoteViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.originalImage] as? UIImage
        self.notedImage.image = selectedImage
        self.notedImage.image?.writeImageToDocs(imageName: self.viewModel.imageLocalName)
        self.dismiss(animated: true, completion: { [weak self] in
            guard let self = self else {return}
            if let image = UIImage().readImageFromDocs(imageName: self.viewModel.imageLocalName) {
                self.viewModel.setImagePath(image)
                UIImage().deleteImageFromDocs(imageName: self.viewModel.imageLocalName)
            }
        })
    }
    
}
