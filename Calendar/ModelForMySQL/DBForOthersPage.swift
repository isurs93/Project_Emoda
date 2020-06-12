//
//  DBForOthersPage.swift
//  Emoda
//
//  Created by Piano on 2020/03/22.
//  Copyright © 2020 Piano. All rights reserved.
//

import Foundation

class DBForOthersPage: NSObject{
    // Properties
    var diary_Seq: Int?
    var userInfo_Email: String?
    var diary_Emotion: Int?
    var diary_Title: String?
    var diary_Contents: String?
    var diary_Date: String?
    
    // 빈 생성자
    override init() {

    }

    init(diary_Seq: Int, userInfo_Email: String, diary_Emotion: Int, diary_Title: String, diary_Contents: String, diary_Date: String){
        self.diary_Seq = diary_Seq
        self.userInfo_Email = userInfo_Email
        self.diary_Emotion = diary_Emotion
        self.diary_Title = diary_Title
        self.diary_Contents = diary_Contents
        self.diary_Date = diary_Date
    }
}
