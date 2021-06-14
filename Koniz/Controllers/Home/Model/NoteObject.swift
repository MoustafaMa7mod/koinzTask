//
//  NoteObject.swift
//  Koniz
//
//  Created by Mostafa Mahmoud on 6/13/21.
//

import Foundation
import RealmSwift

class NoteObject: Object {
    @objc dynamic var id = 0
    @objc dynamic var noteTitle = ""
    @objc dynamic var noteBody = ""
    @objc dynamic var notePhoto: String = ""
    @objc dynamic var noteLatitude = 0.0
    @objc dynamic var noteLongitude = 0.0
    @objc dynamic var notePlaceName = ""
    @objc dynamic var created: String = ""

    //increment auto id
//       Roteiro_Add.id = Roteiro_Add.IncrementaID()

    
    override static func primaryKey() -> String? {
        return "id"
    }
    
  
}
