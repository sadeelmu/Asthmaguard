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
    private var dbPointer: OpaquePointer?

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
            CreationDate TEXT,
            AppleID TEXT
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

    func addUserAndPatient(userName: String, password: String, email: String) {
        // Print user data
        print("Adding User:")
        print("Username: \(userName)")
        print("Password: \(password)")
        print("Email: \(email)")

        let userSQL = """
        INSERT INTO Users (Username, Password, Email)
        VALUES ('\(userName)', '\(password)', '\(email)');
        """

        do {
            let userID = try database.executeQuery(sql: userSQL)
            print("User added successfully with UserID = \(userID).")

            // Print patient data
            let name = userName
            let dob = "2024-04-24" // Replace with actual input
            let gender = "1" // Replace with actual input
            let height = "170" // Replace with actual input
            let weight = "70" // Replace with actual input

            print("\nAdding Patient:")
            print("User ID: \(userID)")
            print("Name: \(name)")
            print("Date of Birth: \(dob)")
            print("Gender: \(gender)")
            print("Height: \(height)")
            print("Weight: \(weight)")

            let patientSQL = """
            INSERT INTO PatientInformation (UserID, Name, DateOfBirth, Gender, Height, Weight)
            VALUES (\(userID), '\(name)', '\(dob)', \(gender), \(height), \(weight));
            """
            try database.executeQuery(sql: patientSQL)
            print("Patient added successfully.")
        } catch {
            print("Error: \(error)")
        }
    }

}
