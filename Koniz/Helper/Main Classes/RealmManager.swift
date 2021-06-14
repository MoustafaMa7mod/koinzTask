//
//  RealmManager.swift
//  Koniz
//
//  Created by Mostafa Mahmoud on 6/14/21.
//

import Foundation
import RealmSwift

class RealmManager{
    
    static var shared = RealmManager()
    let realm = try? Realm()

    func insertIntoDatabase(_ object: NoteObject){
        try? realm?.write {
            realm?.add(object)
        }
    }
    
    func incrementaID() -> Int {
        let id = (realm?.objects(NoteObject.self).sorted(byKeyPath: "id" , ascending: true).max(ofProperty: "id") as Int? ?? 0) + 1
        return id
    }
    
    func fetchFromRealm() -> Results<NoteObject>?{
        let object = realm?.objects(NoteObject.self)
        guard let noteObject = object else {
            return nil
        }
        return noteObject
    }
    
    func updateIntoDatabase(obect: NoteObject , closure:()->Void){
        try? realm?.write {
            closure()
            realm?.create(NoteObject.self, value: obect, update: .modified)
        }
    }
    
    
}
