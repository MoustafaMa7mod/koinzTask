//
//  AddNoteVC+CLLocation.swift
//  Koniz
//
//  Created by Mostafa Mahmoud on 6/14/21.
//

import Foundation
import CoreLocation
import RxCocoa
import RxSwift

extension AddNoteViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        self.latitudeValue.accept(locValue.latitude)
        self.longitudeValue.accept(locValue.longitude)
        self.configure(with: viewModel)
        let userLocation :CLLocation = locations[0] as CLLocation
        self.getDetailsOfLocation(userLocation: userLocation)
    }
    
    private func getDetailsOfLocation(userLocation: CLLocation){
        viewModel.getDetailsOfLocationFromGeocoder(userLocation: userLocation) { [weak self] loadData in
            if loadData {
                guard let self = self else {return}
                self.noteLocationLabel.text = self.viewModel.notePlace.value
            }
        }
    }
    
    
}
