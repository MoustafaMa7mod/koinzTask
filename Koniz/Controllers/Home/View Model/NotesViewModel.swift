//
//  NotesViewModel.swift
//  Koniz
//
//  Created by Mostafa Mahmoud on 6/14/21.
//

import Foundation
import RealmSwift
import CoreLocation

class NotesViewModel {
    
    var notes: Results<NoteObject>?
    var notesArray = [NoteObject]()
    var notificationToken: NotificationToken?
    var currentLocation = CLLocation()
    var realm = RealmManager()

    
    func getData(completion: @escaping(Bool)->Void) {
        do {
            let noteList = try realm.fetchFromRealm()
            notes = noteList
            notesArray = Array(noteList)
            notesArray = noteList.sorted(by: {self.convertDateToString($0.created).compare(self.convertDateToString($1.created)) == .orderedDescending})
            guard let nerbeyLocation = getNearbyLocation() else {
                completion(false)
                return
            }
            notesArray = [nerbeyLocation] + notesArray.filter({$0 != nerbeyLocation})
            completion(true)
        } catch RuntimeError.NoRealmSet {
            print("No realm database was set")
        } catch {
            print("Unexpected error \(error)")
        }
     
    }
    
    func updateCurrentData( notesUpdated: Results<NoteObject>? ,completion: @escaping(Bool)->Void) {
        if let noteList = notesUpdated {
            notes = notesUpdated
            notesArray = Array(noteList)
            notesArray = noteList.sorted(by: {self.convertDateToString($0.created).compare(self.convertDateToString($1.created)) == .orderedDescending})
            guard let nerbeyLocation = getNearbyLocation() else {
                completion(false)
                return
            }
            notesArray = [nerbeyLocation] + notesArray.filter({$0 != nerbeyLocation})
            completion(true)
        }
    }
    
    func deleteNote(withIndex index: Int ,completion: @escaping(Bool)->Void){
        do {
            let object = self.getEachNotes(index)
            try realm.deleteFromDatabase(object)
            completion(true)
        } catch RuntimeError.NoRealmSet {
            print("No realm database was set")
        } catch {
            print("Unexpected error \(error)")
        }
        
    }
    
    func getCountOfNotes() -> Int{
        return notesArray.count
    }
    
    func getEachNotes(_ index: Int) -> NoteObject{
        return notesArray[index]
    }
    
    func convertDateToString(_ date: String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let date = dateFormatter.date(from: date)
        guard let dateValue = date else {
            return Date()
        }
        return dateValue

    }
    
    func getNearbyLocation() -> NoteObject?{
        let initialNoteObject = NoteObject()
        if self.notesArray.count != 0 {
            return self.notesArray.reduce(initialNoteObject) {
                guard $0 != initialNoteObject else { return $1 }
                let locationOne = CLLocation(latitude: $0.noteLatitude, longitude: $0.noteLongitude)
                let locationTwo = CLLocation(latitude: $1.noteLatitude , longitude: $1.noteLongitude)
                let distanceOne = currentLocation.distance(from: locationOne)
                let distanceTwo = currentLocation.distance(from: locationTwo)
                
                return distanceOne > distanceTwo ? $1:$0
            }
        }
        
        return nil
        
    }
    
}


