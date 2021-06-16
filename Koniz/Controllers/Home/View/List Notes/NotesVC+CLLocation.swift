//
//  NotesVC+CLLocation.swift
//  Koniz
//
//  Created by Mostafa Mahmoud on 6/16/21.
//

import Foundation
import CoreLocation

extension NotesViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        self.notesViewModel.currentLocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
    }
}


