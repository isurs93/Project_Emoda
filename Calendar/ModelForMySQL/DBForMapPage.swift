//
//  DBForMapPage.swift
//  Emoda
//
//  Created by Piano on 2020/03/20.
//  Copyright © 2020 Piano. All rights reserved.
//

import Foundation

class DBForMapPage: NSObject{
    // Properties
    var userInfo_Email: String?
    var userInfo_Nickname: String?
    var userInfo_Latitude: Double?
    var userInfo_Longtitude: Double?
    
    // 빈 생성자
    override init() {

    }

    init(userInfo_Email: String, userInfo_Nickname: String, userInfo_Latitude: Double, userInfo_Longtitude: Double){
        self.userInfo_Email = userInfo_Email
        self.userInfo_Nickname = userInfo_Nickname
        self.userInfo_Latitude = userInfo_Latitude
        self.userInfo_Longtitude = userInfo_Longtitude
    }
}
