//
//  LoginPageViewController.swift
//  Emoda
//
//  Created by Piano on 2020/03/23.
//  Copyright © 2020 Piano. All rights reserved.
//

import UIKit

class LoginPageViewController: UIViewController, MySQLForLoginPageModelProtocol {
    
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldNickname: UITextField!
    
    @IBOutlet weak var btnEmailCheck: UIButton!
    @IBOutlet weak var btnNicknameCheck: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    
    let mysqlforloginpagemodel = MySQLForLoginPageModel()
    
    var userInfo_Email = ""
    var userInfo_Nickname = ""
    var resultOfEmail = 0
    var resultOfNickname = 0
    var resultOfDuplication = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 버튼 라운드 처리
        btnEmailCheck.layer.cornerRadius = 4
        btnNicknameCheck.layer.cornerRadius = 4
        btnSignUp.layer.cornerRadius = 4
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnCheckEmail(_ sender: UIButton) {
        resultOfEmail = 0
        userInfo_Email = textFieldEmail.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        mysqlforloginpagemodel.delegate = self
        mysqlforloginpagemodel.downloadEmail(userInfo_Email: userInfo_Email)
    }
    
    @IBAction func btnCheckNickname(_ sender: UIButton) {
        resultOfNickname = 0
        userInfo_Nickname = textFieldNickname.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        mysqlforloginpagemodel.delegate = self
        mysqlforloginpagemodel.downloadNickname(userInfo_Nickname: userInfo_Nickname)
    }
    
    @IBAction func btnSignupAction(_ sender: UIButton) {
        resultOfDuplication = 0
        resultOfDuplication = resultOfEmail + resultOfNickname
        
        let sqliteforloginpage = SQLiteForLoginPage(userInfo_Email: userInfo_Email, userInfo_Nickname: userInfo_Nickname)
        
        var loginOfResult = true
        
        if resultOfDuplication >= 1 || userInfo_Email.isEmpty || userInfo_Nickname.isEmpty {
            let Alert = UIAlertController(title: "Notice", message: "Please do check your email or nickname", preferredStyle: UIAlertController.Style.alert)
            let Action = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
            Alert.addAction(Action)
            present(Alert, animated: true, completion: nil)
        }else {
            let Alert = UIAlertController(title: "Notice", message: "Welcome \(userInfo_Nickname)", preferredStyle: UIAlertController.Style.alert)
            let Action = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {ACTION in
                loginOfResult = self.mysqlforloginpagemodel.Sign_Up(userInfo_Email: self.userInfo_Email, userInfo_Nickname: self.userInfo_Nickname)
                sqliteforloginpage.sqlSet()
                sqliteforloginpage.Sign_Up()
                self.dismiss(animated: true, completion: nil)
            })
            Alert.addAction(Action)
            present(Alert, animated: true, completion: nil)
        }
        
        // 로그인 실패 시
        if !loginOfResult {
            let Alert = UIAlertController(title: "Notice", message: "Please check your internet connection", preferredStyle: UIAlertController.Style.alert)
            let Action = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {ACTION in
                self.textFieldEmail.text = ""
                self.textFieldNickname.text = ""
                self.userInfo_Email = ""
                self.userInfo_Nickname = ""
            })
            Alert.addAction(Action)
            present(Alert, animated: true, completion: nil)
        }
        
    }
    
    func isExitEmail(count: Int) {
        resultOfEmail = resultOfEmail + count
        
        if resultOfEmail == 1 || userInfo_Email.isEmpty {
            let Alert = UIAlertController(title: "Notice", message: "Please do input other email", preferredStyle: UIAlertController.Style.alert)
            let Action = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {ACTION in
                self.textFieldEmail.text = ""
                self.userInfo_Email = ""
            })
            Alert.addAction(Action)
            present(Alert, animated: true, completion: nil)
            
        }else {
            let Alert = UIAlertController(title: "Notice", message: "Good", preferredStyle: UIAlertController.Style.alert)
            let Action = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
            Alert.addAction(Action)
            present(Alert, animated: true, completion: nil)
        }
        
    }
    
    func isExitNickname(count: Int) {
        resultOfNickname = resultOfNickname + count
        
        if resultOfNickname == 1 || userInfo_Nickname.isEmpty{
            let Alert = UIAlertController(title: "Notice", message: "Please do input other nickname", preferredStyle: UIAlertController.Style.alert)
            let Action = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {ACTION in
                self.textFieldNickname.text = ""
                self.userInfo_Nickname = ""
            })
            Alert.addAction(Action)
            present(Alert, animated: true, completion: nil)
        }else {
            let Alert = UIAlertController(title: "Notice", message: "Good", preferredStyle: UIAlertController.Style.alert)
            let Action = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
            Alert.addAction(Action)
            present(Alert, animated: true, completion: nil)
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
