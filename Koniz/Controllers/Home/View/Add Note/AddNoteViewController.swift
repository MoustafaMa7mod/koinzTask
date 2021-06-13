//
//  AddNoteViewController.swift
//  Koniz
//
//  Created by Mostafa Mahmoud on 6/13/21.
//

import UIKit
import RealmSwift


class AddNoteViewController: UIViewController {
  
 
    // MARK: - outlets
    @IBOutlet weak var noteTitleTextField: UITextField!
    @IBOutlet weak var noteBodyTextField: UITextViewPlaceHolder!
    @IBOutlet weak var addLocationView: UIView!
    @IBOutlet weak var addImageView: UIView!
    @IBOutlet weak var notedImage: UIImageView!
    
    lazy var imagePickerController: UIImagePickerController = {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .photoLibrary
        return controller
    }()
    
    // MARK: - main functions
    override func viewDidLoad() {
        super.viewDidLoad()
        addGesterImage()
        addGesterLocation()
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
    
    // MARK: - get instance from storyboard to push from other view controller
    class func instantiate() -> AddNoteViewController {
        let storyboard : UIStoryboard = UIStoryboard(name: "Notes", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! AddNoteViewController
    }

    func getCurrentDate() -> String{
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let result = formatter.string(from: date)

        return result
    }
    
    @objc func uploadPhoto(tapGestureRecognizer: UITapGestureRecognizer){
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc func getCurrentUserLocation(tapGestureRecognizer: UITapGestureRecognizer){
        let realm = try! Realm()
        let object = NoteObject()
        if let image = UIImage().readImageFromDocs(imageName: "noteImage") {
            object.notePhoto = image
            
            try! realm.write{
                realm.add(object)
            }
            
            UIImage().deleteImageFromDocs(imageName: "noteImage")
            print(image)
        }
        
    }
}

extension AddNoteViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.originalImage] as? UIImage
        self.notedImage.image = selectedImage
        print(self.getCurrentDate())
        self.notedImage.image?.writeImageToDocs(imageName: "noteImage")
        self.dismiss(animated: true, completion: nil)
    }
    
}
