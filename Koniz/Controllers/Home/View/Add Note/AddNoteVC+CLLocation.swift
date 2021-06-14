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
        self.latitudeValue.accept(locValue.latitude)
        self.longitudeValue.accept(locValue.longitude)
        self.configure(with: viewModel)
        let userLocation :CLLocation = locations[0] as CLLocation
        self.getDetailsOfLocation(userLocation: userLocation)
    }
    
    private func getDetailsOfLocation(userLocation: CLLocation){
        viewModel.getDetailsOfLocationFromGeocoder(userLocation: userLocation) { [weak self] loadData in
            guard let self = self else {return}
            if loadData {
                self.noteLocationLabel.text = self.viewModel.notePlace.value
            }else{
                self.noteLocationLabel.text = self.viewModel.showLocationDetails()
            }
        }
    }
    
    
}
