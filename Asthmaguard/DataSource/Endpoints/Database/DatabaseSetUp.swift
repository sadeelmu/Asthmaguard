//
//  DatabaseSetUp.swift
//  Asthmaguard
//
//  Created by Sadeel Muwahed on 24/04/2024.
//

import Foundation
import UIKit
import SQLite3

class SQLiteDatabase {
    var dbPointer: OpaquePointer?

    private init(dbPointer: OpaquePointer?) {
        self.dbPointer = dbPointer
    }

    deinit {
        if dbPointer != nil {
            sqlite3_close(dbPointer)
        }
    }

    static func open(path: String) throws -> SQLiteDatabase {
        var db: OpaquePointer?
        if sqlite3_open(path, &db) == SQLITE_OK {
            return SQLiteDatabase(dbPointer: db)
        } else {
            defer {
                if db != nil {
                    sqlite3_close(db)
                }
            }
            if let errorPointer = sqlite3_errmsg(db) {
                let message = String(cString: errorPointer)
                throw NSError(domain: "SQLiteError", code: 1, userInfo: [NSLocalizedDescriptionKey: message])
            } else {
                throw NSError(domain: "SQLiteError", code: 1, userInfo: nil)
            }
        }
    }

    func createTable(sql: String) throws {
        var errMsg: UnsafeMutablePointer<Int8>?
        if sqlite3_exec(dbPointer, sql, nil, nil, &errMsg) != SQLITE_OK {
            if let errMsg = errMsg {
                let message = String(cString: errMsg)
                sqlite3_free(errMsg)
                throw NSError(domain: "SQLiteError", code: 1, userInfo: [NSLocalizedDescriptionKey: message])
            }
        }
    }

    func executeQuery(sql: String) throws -> Int {
        var queryStatement: OpaquePointer?
        if sqlite3_prepare_v2(dbPointer, sql, -1, &queryStatement, nil) == SQLITE_OK {
            if sqlite3_step(queryStatement) == SQLITE_DONE {
                let lastId = Int(sqlite3_last_insert_rowid(dbPointer))
                sqlite3_finalize(queryStatement)
                return lastId
            } else {
                throw NSError(domain: "SQLiteError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Execution failed"])
            }
        } else {
            throw NSError(domain: "SQLiteError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Query preparation fail"])
        }
    }
}

class DatabaseManager {
    static let shared = DatabaseManager()
    private var database: SQLiteDatabase

    private init() {
        let dbPath = try! FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("YourDatabaseName.sqlite").path

        database = try! SQLiteDatabase.open(path: dbPath)
        try! createTables()
    }

    private func createTables() throws {
        let createUsersTableSQL = """
        CREATE TABLE IF NOT EXISTS Users (
            UserID INTEGER PRIMARY KEY AUTOINCREMENT,
            Username TEXT,
            Password TEXT,
            Email TEXT,
            CreationDate TEXT
        );
        """

        let createPatientInformationTableSQL = """
        CREATE TABLE IF NOT EXISTS PatientInformation (
            PatientID INTEGER PRIMARY KEY AUTOINCREMENT,
            UserID INTEGER,
            Name VARCHAR,
            DateOfBirth DATE,
            Gender BOOL,
            Height INTEGER,
            Weight INTEGER,
            FOREIGN KEY (UserID) REFERENCES Users(UserID)
        );
        """
        try database.createTable(sql: createUsersTableSQL)
        try database.createTable(sql: createPatientInformationTableSQL)
    }

    func addUser(username: String, password: String, email: String) -> Int? {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let creationDate = dateFormatter.string(from: currentDate)

        let userSQL = """
        INSERT INTO Users (Username, Password, Email, CreationDate)
        VALUES ('\(username)', '\(password)', '\(email)', '\(creationDate)');
        """
        do {
            let userID = try database.executeQuery(sql: userSQL)
            print("User added successfully with UserID = \(userID).")
            return userID
        } catch {
            print("Error adding user: \(error)")
            return nil
        }
    }

    func fetchUsers() {
        let querySQL = "SELECT UserID, Username, Password, Email, CreationDate, AppleID FROM Users;"
        do {
            var queryStatement: OpaquePointer? = nil
            if sqlite3_prepare_v2(database.dbPointer, querySQL, -1, &queryStatement, nil) == SQLITE_OK {
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                    let userID = sqlite3_column_int(queryStatement, 0)
                    guard let usernameQueryResult = sqlite3_column_text(queryStatement, 1) else { continue }
                    let username = String(cString: usernameQueryResult)
                    guard let passwordQueryResult = sqlite3_column_text(queryStatement, 2) else { continue }
                    let password = String(cString: passwordQueryResult)
                    guard let emailQueryResult = sqlite3_column_text(queryStatement, 3) else { continue }
                    let email = String(cString: emailQueryResult)
                    guard let creationDateQueryResult = sqlite3_column_text(queryStatement, 4) else { continue }
                    let creationDate = String(cString: creationDateQueryResult)
                    guard let appleIDQueryResult = sqlite3_column_text(queryStatement, 5) else { continue }
                    let appleID = String(cString: appleIDQueryResult)
                    print("User ID: \(userID), Username: \(username), Password: \(password), Email: \(email), Creation Date: \(creationDate), Apple ID: \(appleID)")
                }
                sqlite3_finalize(queryStatement)
            } else {
                let errmsg = String(cString: sqlite3_errmsg(database.dbPointer))
                print("Error preparing select statement: \(errmsg)")
            }
        } catch {
            print("Error fetching users: \(error)")
        }
    }


    func addPatient(name: String, dob: Date, gender: Bool, height: Float, weight: Float, userID: Int) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dobString = dateFormatter.string(from: dob)
        
        let patientSQL = """
        INSERT INTO PatientInformation (UserID, Name, DateOfBirth, Gender, Height, Weight)
        VALUES (\(userID), '\(name)', '\(dobString)', \(gender ? 1 : 0), \(height), \(weight));
        """
        do {
            try database.executeQuery(sql: patientSQL)
            print("Patient added successfully.")
        } catch {
            print("Error adding patient: \(error)")
        }
    }

}
