//
//  SessionManager.swift
//  Asthmaguard
//
//  Created by Sadeel Muwahed on 27/05/2024.
//

class SessionManager {
    static let shared = SessionManager()
    
    private var currentToken: Int?
    
    private init() { }
    
    func login(token: Int) {
        self.currentToken = token
    }
    
    func logout() {
        self.currentToken = nil
    }
    
    func getCurrentToken() -> Int? {
        return self.currentToken
    }
}
