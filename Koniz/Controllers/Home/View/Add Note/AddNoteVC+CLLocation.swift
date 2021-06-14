//
//  AddNoteVC+CLLocation.swift
//  Koniz
//
//  Created by Mostafa Mahmoud on 6/14/21.
//

import Foundation
import CoreLocation

extension AddNoteViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        self.viewModel.setLatitudeAndLongitudeIntoModel(locValue.latitude, locValue.longitude)
        let userLocation :CLLocation = locations[0] as CLLocation
        self.getDetailsOfLocation(userLocation: userLocation)
    }
    
    private func getDetailsOfLocation(userLocation: CLLocation){
        viewModel.getDetailsOfLocationFromGeocoder(userLocation: userLocation) { loadData , placeName in
            if loadData {
                print("Done")
                self.noteLocationLabel.text = placeName
            }
        }
    }
    
    
}
