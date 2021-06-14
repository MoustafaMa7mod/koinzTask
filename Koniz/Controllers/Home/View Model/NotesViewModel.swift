//
//  NotesViewModel.swift
//  Koniz
//
//  Created by Mostafa Mahmoud on 6/14/21.
//

import Foundation
import RealmSwift

class NotesViewModel {
    
    var notesArray = [NoteObject]()
    
    func getData(completion: @escaping(Bool)->Void) {
        notesArray = Array(RealmManager.shared.fetchFromRealm())
        notesArray.sort(by: {self.convertDateToString($0.created).compare(self.convertDateToString($1.created)) == .orderedDescending})
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
