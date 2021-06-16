//
//  RealmManagerTest.swift
//  KonizTests
//
//  Created by Mostafa Mahmoud on 6/16/21.
//

import XCTest
@testable import Koniz
import RealmSwift

class RealmManagerTest: XCTestCase {
    
    var realmManager : RealmManager!
    let realm = try! Realm()
    
    override func setUpWithError() throws {
        realmManager = RealmManager()
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        realmManager.realm = realm
    }
    
    override func tearDownWithError() throws {
        realmManager = nil
        DispatchQueue.main.async {
            do{
                try self.clearDatabaseFromTestedData()
            }catch{
                print(error)
            }
        }
    }
    
    private func newNoteObject(_ title: String , _ body: String) -> NoteObject{
        let newNote = NoteObject()
        newNote.id = realmManager.incrementaID()
        newNote.noteTitle = title
        newNote.noteBody = body
        return newNote
    }
    
    private func clearDatabaseFromTestedData() throws{
        realm.beginWrite()
        realm.deleteAll()
        try realm.commitWrite()
    }
    
    func testSaveAndGetNote() {
        do {
            let note = self.newNoteObject("Note Title", "Note Body")
            try realmManager.insertIntoDatabase(note)
            let noteObject = try realmManager.fetchFromRealm()
            XCTAssertEqual(noteObject.count, 1)
            XCTAssertNotEqual(noteObject[0].id, 0)
        } catch RuntimeError.NoRealmSet {
            XCTAssert(false, "No realm database was set")
        } catch {
            XCTAssert(false, "Unexpected error \(error)")
        }
    }
    
    func testUpdateAndGetNote() {
        do {
            let note = self.newNoteObject("Note Title", "Note Body")
            try realmManager.insertIntoDatabase(note)
            let noteObject = try realmManager.fetchFromRealm()
            try realmManager.updateIntoDatabase(object: noteObject[0], closure: {
                noteObject[0].noteTitle = "Note Title Updated"
                noteObject[0].noteBody = "Note Body Updated"
            })
            
            XCTAssertEqual(noteObject[0].noteTitle, "Note Title Updated")
            
        } catch RuntimeError.NoRealmSet {
            XCTAssert(false, "No realm database was set")
        } catch {
            XCTAssert(false, "Unexpected error \(error)")
        }
    }
    
    func testDeleteAndGetNote() {
        do {
            let note = self.newNoteObject("Note Title", "Note Body")
            try realmManager.insertIntoDatabase(note)
            let noteObject = try realmManager.fetchFromRealm()
            try realmManager.deleteFromDatabase(noteObject[0])
            let noteDeletedObject = try realmManager.fetchFromRealm()
            
            XCTAssertEqual(noteDeletedObject.count, 0)
            
        } catch RuntimeError.NoRealmSet {
            XCTAssert(false, "No realm database was set")
        } catch {
            XCTAssert(false, "Unexpected error \(error)")
        }
    }
    
    
    
    
}
