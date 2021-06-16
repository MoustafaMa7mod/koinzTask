//
//  RealmManager.swift
//  Koniz
//
//  Created by Mostafa Mahmoud on 6/14/21.
//

import Foundation
import RealmSwift

enum RuntimeError: Error {
    case NoRealmSet
}
class RealmManager{
    
    var realm: Realm?

    init(){
        realm = try! Realm()
    }
    
    func insertIntoDatabase(_ object: NoteObject) throws{
        guard let realm = realm else { throw RuntimeError.NoRealmSet }
        try? realm.write {
            realm.add(object)
        }
    }
    
    func incrementaID() -> Int {
        let id = (realm?.objects(NoteObject.self).sorted(byKeyPath: "id" , ascending: true).max(ofProperty: "id") as Int? ?? 0) + 1
        return id
    }
    
    func fetchFromRealm() throws -> Results<NoteObject>{
        guard let realm = realm else { throw RuntimeError.NoRealmSet }
        let object = realm.objects(NoteObject.self)
        return object
    }
    
    
    func updateIntoDatabase(object: NoteObject , closure:()->Void) throws{
        guard let realm = realm else { throw RuntimeError.NoRealmSet }
        try? realm.write {
            closure()
            realm.create(NoteObject.self, value: object, update: .modified)
        }
    }
    
    func deleteFromDatabase(_ object: NoteObject) throws{
        guard let realm = realm else { throw RuntimeError.NoRealmSet }
        try? realm.write {
            realm.delete(object)
        }
    }
    
    
}
