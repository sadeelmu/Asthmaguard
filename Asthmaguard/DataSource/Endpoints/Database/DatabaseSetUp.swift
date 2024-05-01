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
        
        let createAsthmaPredictionTableSQL = """
        CREATE TABLE IF NOT EXISTS AsthmaPrediction (
            Serial INTEGER PRIMARY KEY,
            PatientID INTEGER,
            Timestamp DATETIME,
            AsthmaPredictionValue INTEGER,
            FOREIGN KEY (PatientID) REFERENCES PatientInformation(PatientID)
        );
        """


         let createTreatmentsTableSQL = """
        CREATE TABLE IF NOT EXISTS Treatments (
            TreatmentID INTEGER PRIMARY KEY,
            TreatmentDescription VARCHAR
        );
        """


       try database.createTable(sql: createAsthmaPredictionTableSQL)
       try database.createTable(sql: createTreatmentsTableSQL)
        
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
        
        print("Adding User:")
        print("Username: \(username)")
        print("Password: \(password)")
        print("Email: \(email)")
        
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
    
    func updateUser(userID: Int, newUsername: String, newPassword: String, newEmail: String) {
        let updateSQL = "UPDATE Users SET Username = ?, Password = ?, Email = ? WHERE UserID = ?;"
        
        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(database.dbPointer, updateSQL, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(updateStatement, 1, (newUsername as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 2, (newPassword as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 3, (newEmail as NSString).utf8String, -1, nil)
            sqlite3_bind_int(updateStatement, 4, Int32(userID))
            
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated user.")
            } else {
                let errmsg = String(cString: sqlite3_errmsg(database.dbPointer))
                print("Failed to update user: \(errmsg)")
            }
            
            // Finalize the statement to release resources
            sqlite3_finalize(updateStatement)
        } else {
            let errmsg = String(cString: sqlite3_errmsg(database.dbPointer))
            print("Error preparing update statement for Users: \(errmsg)")
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
