//
//  NotesViewModel.swift
//  Koniz
//
//  Created by Mostafa Mahmoud on 6/14/21.
//

import Foundation
import RealmSwift

class NotesViewModel {
    
    var notes: Results<NoteObject>?
    var notesArray = [NoteObject]()
    var notificationToken: NotificationToken?

    
    func getData(completion: @escaping(Bool)->Void) {
        if let noteList = RealmManager.shared.fetchFromRealm() {
            notes = noteList
            notesArray = Array(noteList)
            notesArray = noteList.sorted(by: {self.convertDateToString($0.created).compare(self.convertDateToString($1.created)) == .orderedDescending})
            completion(true)
        }
    }
    
    func updateCurrentData( notesUpdated: Results<NoteObject>? ,completion: @escaping(Bool)->Void) {
        if let noteList = notesUpdated {
            notes = notesUpdated
            notesArray = Array(noteList)
            notesArray = noteList.sorted(by: {self.convertDateToString($0.created).compare(self.convertDateToString($1.created)) == .orderedDescending})
            completion(true)
        }
    }
    
    func deleteNote(withIndex index: Int ,completion: @escaping(Bool)->Void){
        let object = self.getEachNotes(index)
        RealmManager.shared.deleteFromDatabase(object)
        completion(true)
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
    
}
