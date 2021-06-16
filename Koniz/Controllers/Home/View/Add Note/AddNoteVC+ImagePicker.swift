//
//  AddNoteVC+ImagePicker.swift
//  Koniz
//
//  Created by Mostafa Mahmoud on 6/16/21.
//

import Foundation
import UIKit
import Photos

extension AddNoteViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.originalImage] as? UIImage
        self.notedImage.isHidden = false
        self.imageViewHeight.constant = 140
        self.addPhotoLabel.isHidden = true
        self.notedImage.image = selectedImage
        if operationType == .edit {
            self.notedImage.image?.deleteImageFromDocs(imageName: viewModel.imageLocalName)
            self.notedImage.image?.writeImageToDocs(imageName: viewModel.imageLocalName )
        }else{
            self.notedImage.image?.writeImageToDocs(imageName: viewModel.imageLocalName )
        }
        
        self.imagePathValue.accept(viewModel.imageLocalName)
        self.configure(with: viewModel)
        self.dismiss(animated: true, completion: nil)
    }
    
    func checkPhotoLibraryPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            self.present(imagePickerController, animated: true, completion: nil)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({newStatus in
            DispatchQueue.main.async {
                if newStatus ==  PHAuthorizationStatus.authorized {
                     self.present(self.imagePickerController, animated: true, completion: nil)
                }else{
                    print("User denied")
                    if let bundleId = Bundle.main.bundleIdentifier,
                        let url = URL(string: "\(UIApplication.openSettingsURLString)&path=Photos/\(bundleId)"){
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            }})
            break
        case .restricted:
            print("restricted")
            break
        case .denied:
            print("denied")
            break
        case .limited:
            print("limited")
            break
        @unknown default:
            break
        }
        
    }
    
}
