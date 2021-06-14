//
//  AddNoteViewModel.swift
//  Koniz
//
//  Created by Mostafa Mahmoud on 6/14/21.
//

import Foundation
import CoreLocation
import RxCocoa
import RxSwift

class AddNoteViewModel {
    
    var noteObject = NoteObject()
    var imageLocalName = "\(RealmManager.shared.incrementaID())-noteImage.png"
    let noteTitle =  BehaviorRelay<String>(value: "")
    let noteBody = BehaviorRelay<String>(value: "")
    var noteImagePath = BehaviorRelay<String>(value: "")
    let noteAddDate = BehaviorRelay<String>(value: "")
    var notePlace = BehaviorRelay<String>(value: "")
    let noteLatitude = BehaviorRelay<Double>(value: 0.0)
    let noteLongitude = BehaviorRelay<Double>(value: 0.0)
    var disposed = DisposeBag()

    func getCurrentDate(){
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let result = formatter.string(from: date)
        self.noteObject.created = result
        
    }
    
    func parseDataFromView() {
        self.noteObject.noteTitle = noteTitle.value
        self.noteObject.noteBody = noteBody.value
        self.noteObject.noteLatitude = noteLatitude.value
        self.noteObject.noteLongitude = noteLongitude.value
        self.noteObject.notePhoto = noteImagePath.value
        self.noteObject.notePlaceName = notePlace.value
    }
    
    func setLatitudeAndLongitudeIntoModel(_ lat:Double , _ long: Double){
        self.noteObject.noteLatitude = lat
        self.noteObject.noteLongitude = long
    }
    
    func setImagePath(_ imagePath:String){
        self.noteObject.notePhoto = imagePath
    }
    
    func insertNote() {
        parseDataFromView()
        getCurrentDate()
        noteObject.id = RealmManager.shared.incrementaID()
        RealmManager.shared.insertIntoDatabase(self.noteObject)
    }
    
    func getDetailsOfLocationFromGeocoder(userLocation: CLLocation , completion:@escaping(Bool)->Void){
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if (error != nil){
                print("error in reverseGeocode")
                completion(false)
            }
            if let placemarks = placemarks {
                let placemark = placemarks as [CLPlacemark]
                if placemark.count>0{
                    let placemark = placemarks[0]
                    self.notePlace.accept("\(placemark.locality!), \(placemark.administrativeArea!), \(placemark.country!)")
                    completion(true)
                }
            }
            
       
        }
    }
    
}