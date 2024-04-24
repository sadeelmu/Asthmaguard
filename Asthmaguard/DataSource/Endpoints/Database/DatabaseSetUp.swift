//
//  DatabaseSetUp.swift
//  Asthmaguard
//
//  Created by Sadeel Muwahed on 24/04/2024.
//

import Foundation
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

    func executeInsert(sql: String) throws -> Int {
        var errMsg: UnsafeMutablePointer<Int8>?
        if sqlite3_exec(dbPointer, sql, nil, nil, &errMsg) != SQLITE_OK {
            if let errMsg = errMsg {
                let message = String(cString: errMsg)
                sqlite3_free(errMsg)
                throw NSError(domain: "SQLiteError", code: 1, userInfo: [NSLocalizedDescriptionKey: message])
            }
        }
        return Int(sqlite3_last_insert_rowid(dbPointer))
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

        let createAsthmaTriggersTableSQL = """
        CREATE TABLE IF NOT EXISTS AsthmaTriggers (
            TriggerID INTEGER PRIMARY KEY,
            PatientID INTEGER,
            Grade INTEGER,
            FOREIGN KEY (PatientID) REFERENCES PatientInformation(PatientID)
        );
        """

        let createTriggersTableSQL = """
        CREATE TABLE IF NOT EXISTS Triggers (
            TriggerID INTEGER PRIMARY KEY,
            TriggerName TEXT
        );
        """

        let createBiometricDataTableSQL = """
        CREATE TABLE IF NOT EXISTS BiometricData (
            Serial INTEGER PRIMARY KEY,
            TriggerID INTEGER,
            Value INTEGER,
            FOREIGN KEY (TriggerID) REFERENCES Triggers(TriggerID)
        );
        """

        let createAsthmaTreatmentsTableSQL = """
        CREATE TABLE IF NOT EXISTS AsthmaTreatments (
            PatientID INTEGER,
            TreatmentID INTEGER PRIMARY KEY,
            TreatmentDescription TEXT,
            Dosage INTEGER,
            Frequency TEXT,
            FOREIGN KEY (PatientID) REFERENCES PatientInformation(PatientID)
        );
        """

        try database.createTable(sql: createUsersTableSQL)
        try database.createTable(sql: createPatientInformationTableSQL)
        try database.createTable(sql: createAsthmaTriggersTableSQL)
        try database.createTable(sql: createTriggersTableSQL)
        try database.createTable(sql: createBiometricDataTableSQL)
        try database.createTable(sql: createAsthmaTreatmentsTableSQL)
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
            let userID = try database.executeInsert(sql: userSQL)
            print("User added successfully with UserID = \(userID).")
            return userID
        } catch {
            print("Error adding user: \(error)")
            return nil
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
            try database.executeInsert(sql: patientSQL)
            print("Patient added successfully.")
        } catch {
            print("Error adding patient: \(error)")
        }
    }

    func insertTrigger(triggerID: Int, triggerName: String) {
        let triggerSQL = """
        INSERT INTO Triggers (TriggerID, TriggerName)
        VALUES (\(triggerID), '\(triggerName)');
        """
        do {
            try database.executeInsert(sql: triggerSQL)
            print("Trigger added successfully.")
        } catch {
            print("Error adding trigger: \(error)")
        }
    }

    func insertAsthmaTrigger(triggerID: Int, patientID: Int, grade: Int) {
        let asthmaTriggerSQL = """
        INSERT INTO AsthmaTriggers (TriggerID, PatientID, Grade)
        VALUES (\(triggerID), \(patientID), \(grade));
        """
        do {
            try database.executeInsert(sql: asthmaTriggerSQL)
            print("Asthma Trigger added successfully.")
        } catch {
            print("Error adding asthma trigger: \(error)")
        }
    }

    func insertBiometricData(serial: Int, triggerID: Int, value: Int) {
        let biometricDataSQL = """
        INSERT INTO BiometricData (Serial, TriggerID, Value)
        VALUES (\(serial), \(triggerID), \(value));
        """
        do {
            try database.executeInsert(sql: biometricDataSQL)
            print("Biometric Data added successfully.")
        } catch {
            print("Error adding biometric data: \(error)")
        }
    }

    func insertAsthmaTreatment(patientID: Int, treatmentID: Int, treatmentDescription: String, dosage: Int, frequency: String) {
        let asthmaTreatmentSQL = """
        INSERT INTO AsthmaTreatments (PatientID, TreatmentID, TreatmentDescription, Dosage, Frequency)
        VALUES (\(patientID), \(treatmentID), '\(treatmentDescription)', \(dosage), '\(frequency)');
        """
        do {
            try database.executeInsert(sql: asthmaTreatmentSQL)
            print("Asthma Treatment added successfully.")
        } catch {
            print("Error adding asthma treatment: \(error)")
        }
    }
}
