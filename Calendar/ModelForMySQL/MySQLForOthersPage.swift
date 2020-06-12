//
//  MySQLForOthersPage.swift
//  Emoda
//
//  Created by Piano on 2020/03/22.
//  Copyright © 2020 Piano. All rights reserved.
//

import Foundation

protocol MySQLForOthersPageModelProtocol: class {
    func itemDownloaded(items:NSArray)
}

class MySQLForOthersPageModel: NSObject{
    var delegate: MySQLForOthersPageModelProtocol!
    let urlPath = "\(coreIP)diaryQuery_DiarySelect.jsp?userInfo_Email="
    
    func downloadItems(userInfo_Email: String){
        let url: URL = URL(string: "\(urlPath)\(userInfo_Email)")!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        let task = defaultSession.dataTask(with: url){(data, response, error) in
            if error != nil{
                print("Failed to download data")
            }else{
                self.parseJSON(data!)
//                print("Data is downloaded")
            }
        }
        task.resume()
    }
  
    func parseJSON(_ data: Data){
        var jsonResult = NSArray()
        
        do{ // JSON 필요한 항목 받아오는 것으로 try catch와 같음
            jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
        }catch let error as NSError{
            print(error)
        }
        
        var jsonElement = NSDictionary()
        let locations = NSMutableArray()
        
        for i in 0..<jsonResult.count{
            jsonElement = jsonResult[i] as! NSDictionary
            let query = DBForOthersPage()
            
            if let diary_Seq = jsonElement["diary_Seq"] as? String,
                let userInfo_Email = jsonElement["userInfo_Email"] as? String,
                let diary_Emotion = jsonElement["diary_Emotion"] as? String,
                let diary_Title = jsonElement["diary_Title"] as? String,
                let diary_Contents = jsonElement["diary_Contents"] as? String,
                let diary_Date = jsonElement["diary_Date"] as? String{
                
                query.diary_Seq = Int(diary_Seq)
                query.userInfo_Email = String(userInfo_Email)
                query.diary_Emotion = Int(diary_Emotion)
                query.diary_Title = String(diary_Title)
                query.diary_Contents = String(diary_Contents)
                query.diary_Date = String(diary_Date)
                
            }
        
            locations.add(query)
            
        }
        
        DispatchQueue.main.async(execute: {() -> Void in
            self.delegate.itemDownloaded(items: locations)
        })
    }
}
