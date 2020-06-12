//
//  MySQLForLoginPage.swift
//  Emoda
//
//  Created by Piano on 2020/03/23.
//  Copyright © 2020 Piano. All rights reserved.
//

import Foundation

protocol MySQLForLoginPageModelProtocol: class {
    func isExitEmail(count : Int)
    func isExitNickname(count : Int)
}

class MySQLForLoginPageModel: NSObject{
    
    var delegate: MySQLForLoginPageModelProtocol!

    func downloadEmail(userInfo_Email: String){
        var urlPath = "\(coreIP)diaryQuery_UserInfoDuplicationOfEmailSelect.jsp?userInfo_Email=\(userInfo_Email)"
        // 한글 url encoding (2byte문자를 1byte문자로 변환)
        urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let url: URL = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        let task = defaultSession.dataTask(with: url){(data, response, error) in
            if error != nil{
                print("Failed to check data")
            }else{
                self.parseEmail(data!)
//                print("Data is checked!")
            }
        }
        task.resume()
    }
    
    func downloadNickname(userInfo_Nickname: String){
        var urlPath = "\(coreIP)diaryQuery_UserInfoDuplicationOfNicknameSelect.jsp?userInfo_Nickname=\(userInfo_Nickname)"
        // 한글 url encoding (2byte문자를 1byte문자로 변환)
        urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let url: URL = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        let task = defaultSession.dataTask(with: url){(data, response, error) in
            if error != nil{
                print("Failed to check data")
            }else{
                self.parseNickname(data!)
//                print("Data is checked!")
            }
        }
        task.resume()
    }

    func parseEmail(_ data: Data){
        var jsonResult = NSArray()
        
        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
        }catch let error as NSError{
            print(error)
        }
        
        var jsonElement = NSDictionary()
        var resultOfSearch: Int = 0
        
        for i in 0..<jsonResult.count{
            jsonElement = jsonResult[i] as! NSDictionary
            if let count = jsonElement["count"] as? String{
                resultOfSearch = Int(count)!
            }
        }
        
        DispatchQueue.main.async(execute: {() -> Void in
            self.delegate.isExitEmail(count: resultOfSearch)
        })
    }
    
    func parseNickname(_ data: Data){
        var jsonResult = NSArray()
        
        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
        }catch let error as NSError{
            print(error)
        }
        
        var jsonElement = NSDictionary()
        var resultOfSearch: Int = 0
        
        for i in 0..<jsonResult.count{
            jsonElement = jsonResult[i] as! NSDictionary
            if let count = jsonElement["count"] as? String{
                resultOfSearch = Int(count)!
            }
        }
        
        DispatchQueue.main.async(execute: {() -> Void in
            self.delegate.isExitNickname(count: resultOfSearch)
        })
    }
    
    func Sign_Up(userInfo_Email: String, userInfo_Nickname: String) -> Bool{
        var result: Bool = true
        var urlPath = "\(coreIP)diaryQuery_SignUpInsert.jsp?userInfo_Email=\(userInfo_Email)&userInfo_Nickname=\(userInfo_Nickname)"
        
        // 한글 url encoding (2byte문자를 1byte문자로 변환)
        urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        let url = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        let task = defaultSession.dataTask(with: url){(data, response, error) in
            if error != nil{
                print("Failed to insert data")
                result = false
            }else{
//                print("Data is inserted")
                result = true
            }
        }
        task.resume()
        return result
    }

}
