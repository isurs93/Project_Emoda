//
//  MySQLForMapPage.swift
//  Emoda
//
//  Created by Piano on 2020/03/20.
//  Copyright © 2020 Piano. All rights reserved.
//

import Foundation

protocol MySQLForMapPageModelProtocol: class {
    func itemDownloaded(items:NSArray)
}

class MySQLForMapPageModel: NSObject{
    var delegate: MySQLForMapPageModelProtocol!
    let urlPath = "\(coreIP)diaryQuery_UserInfoSelect.jsp"
    
    func downloadItems(){
//        print("MySQLForMapPageModel IP : \(urlPath)")
        let url: URL = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        let task = defaultSession.dataTask(with: url){(data, response, error) in
            if error != nil{
                print("Failed to download data")
            }else{
//                print("MySQLForMapPageModel의 parseJSON() 입장")
                self.parseJSON(data!)
//                print("Data is downloaded")
            }
        }
//        print("MySQLForMapPageModel의 downloadItems() 출구")
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
            let query = DBForMapPage()
            
            if let userInfo_Email = jsonElement["userInfo_Email"] as? String,
                let userInfo_Nickname = jsonElement["userInfo_Nickname"] as? String,
                let userInfo_Latitude = jsonElement["userInfo_Latitude"] as? String,
                let userInfo_Longtitude = jsonElement["userInfo_Longtitude"] as? String{
                
                query.userInfo_Email = String(userInfo_Email)
                query.userInfo_Nickname = String(userInfo_Nickname)
                query.userInfo_Latitude = Double(userInfo_Latitude)!
                query.userInfo_Longtitude = Double(userInfo_Longtitude)!
                
            }
        
            locations.add(query)
            
        }
        
        DispatchQueue.main.async(execute: {() -> Void in
//            print("MySQLForMapPageModel의 parseJSON 출구")
            self.delegate.itemDownloaded(items: locations)
        })
    }
    
    func updataLocation(userInfo_Email: String, userInfo_Latitude: Double, userInfo_Longitude: Double) {
        var urlPath = "\(coreIP)diaryQuery_UpdateLocationInsert.jsp?userInfo_Email=\(userInfo_Email)&userInfo_Latitude=\(userInfo_Latitude)&userInfo_Longtitude=\(userInfo_Longitude)"
        
        // 한글 인코딩
        urlPath = urlPath.addingPercentEncoding(withAllowedCharacters:CharacterSet.urlQueryAllowed)!
        let url: URL = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSession.dataTask(with: url){(data,response, error) in
            if error != nil{
                print("Failed to insert location data")
            }else{
//                print("Location is inserted")
            }
        }
        task.resume()
    }

}
