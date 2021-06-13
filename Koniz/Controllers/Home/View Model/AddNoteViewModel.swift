//
//  AddNoteViewModel.swift
//  Koniz
//
//  Created by Mostafa Mahmoud on 6/14/21.
//

import Foundation
import CoreLocation


class AddNoteViewModel {
    
    func getCurrentDate() -> String{
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let result = formatter.string(from: date)

        return result
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
                    print("\(placemark.locality!), \(placemark.administrativeArea!), \(placemark.country!)")
                    completion(true)
                }
            }
            
       
        }
    }
    
}
