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
        guard let realm = realm else { return }
        try? realm.write {
            realm.add(object)
        }
    }
    
    func incrementaID() -> Int {
        let id = (realm?.objects(NoteObject.self).sorted(byKeyPath: "id" , ascending: true).max(ofProperty: "id") as Int? ?? 0) + 1
        return id
    }
    
    func fetchFromRealm() -> Results<NoteObject>?{
        guard let realm = realm else { return nil }
        let object = realm.objects(NoteObject.self)
        return object
    }
    
    
    func updateIntoDatabase(object: NoteObject , closure:()->Void){
        guard let realm = realm else { return }
        try? realm.write {
            closure()
            realm.create(NoteObject.self, value: object, update: .modified)
        }
    }
    
    func deleteFromDatabase(_ object: NoteObject) {
        guard let realm = realm else { return }
        try? realm.write {
            realm.delete(object)
        }
    }
    
    
}
