//
//  SQLiteForLoginPage.swift
//  Emoda
//
//  Created by Piano on 2020/03/23.
//  Copyright © 2020 Piano. All rights reserved.
//

import Foundation
import SQLite3 // ******

class SQLiteForLoginPage{
    
    var db: OpaquePointer?
    
    var userInfo_Email: String?
    var userInfo_Nickname: String?
    
    init(userInfo_Email: String, userInfo_Nickname: String) {
        self.userInfo_Email = userInfo_Email
        self.userInfo_Nickname = userInfo_Nickname
    }
    
    func sqlSet() {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("Emoda.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK{
            print("error opening database")
        }
    }
    
    func Sign_Up() {
        var stmt: OpaquePointer?
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        
        let queryString = "INSERT INTO UserInfo (userInfo_Email, userInfo_Nickname) VALUES (?, ?)"
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert : \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(stmt, 1, userInfo_Email!, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding email : \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(stmt, 2, userInfo_Nickname!, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding nickname : \(errmsg)")
            return
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting data : \(errmsg)")
            return
        }

    }

}
