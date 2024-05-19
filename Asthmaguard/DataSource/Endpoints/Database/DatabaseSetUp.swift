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
    
    init(dbPointer: OpaquePointer?) {
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
    var database: SQLiteDatabase
    
    init() {
        let dbPath = try! FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("YourDatabaseName.sqlite").path
        
        database = try! SQLiteDatabase.open(path: dbPath)
        try! createTables()
    }
    
    //MARK: CREATE TABLES
    
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
    
}

// MARK: - Insert Functions

extension DatabaseManager {
    
    // MARK: - Insert Trigger
    
    func insertTrigger(triggerID: Int, triggerName: String) {
        let triggerSQL = """
        INSERT INTO Triggers (TriggerID, TriggerName)
        VALUES (\(triggerID), '\(triggerName)');
        """
        executeInsert(sql: triggerSQL)
    }
    
    // MARK: - Insert Asthma Trigger
    
    func insertAsthmaTrigger(triggerID: Int, patientID: Int, grade: Int) {
        let asthmaTriggerSQL = """
        INSERT INTO AsthmaTriggers (TriggerID, PatientID, Grade)
        VALUES (\(triggerID), \(patientID), \(grade));
        """
        executeInsert(sql: asthmaTriggerSQL)
    }
    
    // MARK: - Insert Initial Triggers
    
    func insertInitialTriggers(db: OpaquePointer?) {
        let triggers = [
            (1, "repository rate"),
            (2, "blood oxygen"),
            (3, "heart rate"),
            (4, "fine particals"),
            (5, "pollen"),
            (6, "pollution")
        ]
        let insertStatementString = "INSERT INTO Triggers (TriggerID, TriggerName) VALUES (?, ?);"
        var insertStatement: OpaquePointer?
        
        for trigger in triggers {
            if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
                sqlite3_bind_int(insertStatement, 1, Int32(trigger.0))
                sqlite3_bind_text(insertStatement, 2, (trigger.1 as NSString).utf8String, -1, nil)
                
                if sqlite3_step(insertStatement) == SQLITE_DONE {
                    print("Successfully inserted trigger: \(trigger.1)")
                } else {
                    let errmsg = String(cString: sqlite3_errmsg(db))
                    print("Could not insert trigger: \(trigger.1). Error: \(errmsg)")
                }
                // Reset the statement to be reused
                sqlite3_reset(insertStatement)
            } else {
                let errmsg = String(cString: sqlite3_errmsg(db))
                print("INSERT statement could not be prepared. Error: \(errmsg)")
            }
        }
        sqlite3_finalize(insertStatement)
    }
    
    // MARK: - Insert Biometric Data
    
    func insertBiometricData(serial: Int, triggerID: Int, value: Int) {
        let biometricDataSQL = """
        INSERT INTO BiometricData (Serial, TriggerID, Value)
        VALUES (\(serial), \(triggerID), \(value));
        """
        executeInsert(sql: biometricDataSQL)
    }
    
    // MARK: - Insert Asthma Treatment
    
    func insertAsthmaTreatment(patientID: Int, treatmentID: Int, treatmentDescription: String, dosage: Int, frequency: String) {
        let asthmaTreatmentSQL = """
        INSERT INTO AsthmaTreatments (PatientID, TreatmentID, TreatmentDescription, Dosage, Frequency)
        VALUES (\(patientID), \(treatmentID), '\(treatmentDescription)', \(dosage), '\(frequency)');
        """
        executeInsert(sql: asthmaTreatmentSQL)
    }
    
    private func executeInsert(sql: String) {
        do {
            try database.executeInsert(sql: sql)
            print("Insertion Successful.")
        } catch {
            print("Error inserting data: \(error)")
        }
    }
}

extension DatabaseManager {
    // MARK: - Update Patient Information
    
    func updatePatientInformation(patientID: Int, newName: String, newDateOfBirth: String, newGender: Bool, newHeight: Int, newWeight: Int) {
        let updateSQL = """
        UPDATE PatientInformation
        SET Name = ?, DateOfBirth = ?, Gender = ?, Height = ?, Weight = ?
        WHERE PatientID = ?;
        """
        
        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(database.dbPointer, updateSQL, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(updateStatement, 1, newName, -1, nil)
            sqlite3_bind_text(updateStatement, 2, newDateOfBirth, -1, nil)
            sqlite3_bind_int(updateStatement, 3, newGender ? 1 : 0)
            sqlite3_bind_int(updateStatement, 4, Int32(newHeight))
            sqlite3_bind_int(updateStatement, 5, Int32(newWeight))
            sqlite3_bind_int(updateStatement, 6, Int32(patientID))
            
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated patient information.")
            } else {
                let errmsg = String(cString: sqlite3_errmsg(database.dbPointer))
                print("Failed to update patient information: \(errmsg)")
            }
            sqlite3_finalize(updateStatement)
        } else {
            let errmsg = String(cString: sqlite3_errmsg(database.dbPointer))
            print("Error preparing update statement for PatientInformation: \(errmsg)")
        }
    }
    
    // MARK: - Update Asthma Trigger
    
    func updateAsthmaTrigger(triggerID: Int, patientID: Int, newGrade: Int) {
        let updateSQL = """
        UPDATE AsthmaTriggers
        SET Grade = ?
        WHERE TriggerID = ? AND PatientID = ?;
        """
        
        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(database.dbPointer, updateSQL, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(updateStatement, 1, Int32(newGrade))
            sqlite3_bind_int(updateStatement, 2, Int32(triggerID))
            sqlite3_bind_int(updateStatement, 3, Int32(patientID))
            
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated asthma trigger.")
            } else {
                let errmsg = String(cString: sqlite3_errmsg(database.dbPointer))
                print("Failed to update asthma trigger: \(errmsg)")
            }
            sqlite3_finalize(updateStatement)
        } else {
            let errmsg = String(cString: sqlite3_errmsg(database.dbPointer))
            print("Error preparing update statement for AsthmaTriggers: \(errmsg)")
        }
    }
    
    // MARK: - Update Trigger
    
    func updateTrigger(triggerID: Int, newTriggerName: String) {
        let updateSQL = """
        UPDATE Triggers
        SET TriggerName = ?
        WHERE TriggerID = ?;
        """
        
        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(database.dbPointer, updateSQL, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(updateStatement, 1, newTriggerName, -1, nil)
            sqlite3_bind_int(updateStatement, 2, Int32(triggerID))
            
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated trigger.")
            } else {
                let errmsg = String(cString: sqlite3_errmsg(database.dbPointer))
                print("Failed to update trigger: \(errmsg)")
            }
            sqlite3_finalize(updateStatement)
        } else {
            let errmsg = String(cString: sqlite3_errmsg(database.dbPointer))
            print("Error preparing update statement for Triggers: \(errmsg)")
        }
    }
    
    // MARK: - Update Biometric Data
    
    func updateBiometricData(serial: Int, newTriggerID: Int, newValue: Int) {
        let updateSQL = """
        UPDATE BiometricData
        SET TriggerID = ?, Value = ?
        WHERE Serial = ?;
        """
        
        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(database.dbPointer, updateSQL, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(updateStatement, 1, Int32(newTriggerID))
            sqlite3_bind_int(updateStatement, 2, Int32(newValue))
            sqlite3_bind_int(updateStatement, 3, Int32(serial))
            
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated biometric data.")
            } else {
                let errmsg = String(cString: sqlite3_errmsg(database.dbPointer))
                print("Failed to update biometric data: \(errmsg)")
            }
            sqlite3_finalize(updateStatement)
        } else {
            let errmsg = String(cString: sqlite3_errmsg(database.dbPointer))
            print("Error preparing update statement for BiometricData: \(errmsg)")
        }
    }
    
    // MARK: - Update Asthma Treatment
    
    func updateAsthmaTreatment(treatmentID: Int, newTreatmentName: String, newDosage: String, newFrequency: String, newStartDate: String, newEndDate: String, newDoctorName: String) {
        let updateSQL = """
        UPDATE AsthmaTreatments
        SET TreatmentName = ?, Dosage = ?, Frequency = ?, StartDate = ?, EndDate = ?, DoctorName = ?
        WHERE TreatmentID = ?;
        """
        
        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(database.dbPointer, updateSQL, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(updateStatement, 1, newTreatmentName, -1, nil)
            sqlite3_bind_text(updateStatement, 2, newDosage, -1, nil)
            sqlite3_bind_text(updateStatement, 3, newFrequency, -1, nil)
            sqlite3_bind_text(updateStatement, 4, newStartDate, -1, nil)
            sqlite3_bind_text(updateStatement, 5, newEndDate, -1, nil)
            sqlite3_bind_text(updateStatement, 6, newDoctorName, -1, nil)
            sqlite3_bind_int(updateStatement, 7, Int32(treatmentID))
            
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated asthma treatment.")
            } else {
                let errmsg = String(cString: sqlite3_errmsg(database.dbPointer))
                print("Failed to update asthma treatment: \(errmsg)")
            }
            sqlite3_finalize(updateStatement)
        } else {
            let errmsg = String(cString: sqlite3_errmsg(database.dbPointer))
            print("Error preparing update statement for AsthmaTreatments: \(errmsg)")
        }
    }
}



// MARK: - Fetch Functions

extension DatabaseManager {
    
    // MARK: - Fetch Users
    
    func fetchUsers() {
        let querySQL = "SELECT UserID, Username, Password, Email, CreationDate FROM Users;"
        executeFetch(querySQL: querySQL, handleRow: { (statement) in
            let userID = sqlite3_column_int(statement, 0)
            guard let usernameCString = sqlite3_column_text(statement, 1),
                  let passwordCString = sqlite3_column_text(statement, 2),
                  let emailCString = sqlite3_column_text(statement, 3),
                  let creationDateCString = sqlite3_column_text(statement, 4) else {
                return
            }
            
            let username = String(cString: usernameCString)
            let password = String(cString: passwordCString)
            let email = String(cString: emailCString)
            let creationDate = String(cString: creationDateCString)
            
            print("User ID: \(userID), Username: \(username), Password: \(password), Email: \(email), Creation Date: \(creationDate)")
        })
    }
    
    // MARK: - Fetch Patients
    
    func fetchPatient(userID: Int) {
        let querySQL = "SELECT PatientID, Name, DateOfBirth, Gender, Height, Weight FROM PatientInformation WHERE UserID = \(userID);"
        executeFetch(querySQL: querySQL, handleRow: { (statement) in
            let patientID = sqlite3_column_int(statement, 0)
            guard let nameCString = sqlite3_column_text(statement, 1),
                  let dobCString = sqlite3_column_text(statement, 2) else {
                return
            }
            let gender = sqlite3_column_int(statement, 3) == 1 ? "Male" : "Female"
            let height = sqlite3_column_int(statement, 4)
            let weight = sqlite3_column_int(statement, 5)
            
            let name = String(cString: nameCString)
            let dob = String(cString: dobCString)
            
            print("Patient ID: \(patientID), Name: \(name), Date of Birth: \(dob), Gender: \(gender), Height: \(height), Weight: \(weight)")
        })
    }
    
    // MARK: - Fetch Triggers
    
    func fetchTriggers() {
        let querySQL = "SELECT TriggerID, TriggerName FROM Triggers;"
        executeFetch(querySQL: querySQL, handleRow: { (statement) in
            let triggerID = sqlite3_column_int(statement, 0)
            guard let triggerNameCString = sqlite3_column_text(statement, 1) else {
                return
            }
            let triggerName = String(cString: triggerNameCString)
            
            print("Trigger ID: \(triggerID), Trigger Name: \(triggerName)")
        })
    }
    
    // MARK: - Fetch Asthma Triggers
    
    func fetchAsthmaTriggers(forUserID userID: Int, completion: @escaping ([Int]) -> Void) {
         let querySQL = "SELECT Grade FROM AsthmaTriggers WHERE PatientID = ? ORDER BY TriggerID;"
         var queryStatement: OpaquePointer? = nil
         var grades: [Int] = []

         if sqlite3_prepare_v2(database.dbPointer, querySQL, -1, &queryStatement, nil) == SQLITE_OK {
             sqlite3_bind_int(queryStatement, 1, Int32(userID))

             while sqlite3_step(queryStatement) == SQLITE_ROW {
                 let grade = sqlite3_column_int(queryStatement, 0)
                 grades.append(Int(grade))
             }

             sqlite3_finalize(queryStatement)
         } else {
             let errmsg = String(cString: sqlite3_errmsg(database.dbPointer))
             print("Error preparing select statement: \(errmsg)")
         }

         completion(grades)
     }
    
    // MARK: - Fetch Biometric Data
    
    func fetchBiometricData() {
        let querySQL = "SELECT Serial, TriggerID, Value FROM BiometricData;"
        executeFetch(querySQL: querySQL, handleRow: { (statement) in
            let serial = sqlite3_column_int(statement, 0)
            let triggerID = sqlite3_column_int(statement, 1)
            let value = sqlite3_column_int(statement, 2)
            
            print("Serial: \(serial), Trigger ID: \(triggerID), Value: \(value)")
        })
    }
    
    // MARK: - Fetch Biometric Value by Trigger ID

    func fetchBiometricValueByTriggerID(triggerID: Int32) -> Int32? {
        let querySQL = "SELECT Value FROM BiometricData WHERE TriggerID = ?;"
        var queryStatement: OpaquePointer? = nil
        var value: Int32?
        
        if sqlite3_prepare_v2(database.dbPointer, querySQL, -1, &queryStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(queryStatement, 1, triggerID)
            
            if sqlite3_step(queryStatement) == SQLITE_ROW {
                value = sqlite3_column_int(queryStatement, 0)  // Assuming Value is the first and only column retrieved
            }
            
            sqlite3_finalize(queryStatement)
        } else {
            let errmsg = String(cString: sqlite3_errmsg(database.dbPointer))
            print("Error preparing select statement: \(errmsg)")
        }
        
        return value
    }
    
    // MARK: - Fetch Asthma Treatments
    
    func fetchAsthmaTreatments() {
        let querySQL = """
        SELECT TreatmentID, PatientID, TreatmentDescription, Dosage, Frequency, StartDate, EndDate, DoctorName
        FROM AsthmaTreatments;
        """
        executeFetch(querySQL: querySQL, handleRow: { (statement) in
            let treatmentID = sqlite3_column_int(statement, 0)
            let patientID = sqlite3_column_int(statement, 1)
            guard let descriptionCString = sqlite3_column_text(statement, 2),
                  let dosageCString = sqlite3_column_text(statement, 3),
                  let frequencyCString = sqlite3_column_text(statement, 4),
                  let startDateCString = sqlite3_column_text(statement, 5),
                  let endDateCString = sqlite3_column_text(statement, 6),
                  let doctorNameCString = sqlite3_column_text(statement, 7) else {
                return
            }
            let description = String(cString: descriptionCString)
            let dosage = String(cString: dosageCString)
            let frequency = String(cString: frequencyCString)
            let startDate = String(cString: startDateCString)
            let endDate = String(cString: endDateCString)
            let doctorName = String(cString: doctorNameCString)
            
            print("Treatment ID: \(treatmentID), Patient ID: \(patientID), Description: \(description), Dosage: \(dosage), Frequency: \(frequency), Start Date: \(startDate), End Date: \(endDate), Doctor Name: \(doctorName)")
        })
    }
    
    private func executeFetch(querySQL: String, handleRow: (OpaquePointer) -> Void) {
        var queryStatement: OpaquePointer?
        if sqlite3_prepare_v2(database.dbPointer, querySQL, -1, &queryStatement, nil) == SQLITE_OK {
            defer {
                sqlite3_finalize(queryStatement)
            }
            
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                handleRow(queryStatement!)
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(database.dbPointer))
            print("Error preparing select statement: \(errmsg)")
        }
    }
}

