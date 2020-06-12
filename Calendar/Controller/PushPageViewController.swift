//
//  PushPageViewController.swift
//  Emoda
//
//  Created by Piano on 2020/03/24.
//  Copyright © 2020 Piano. All rights reserved.
//

import UIKit
import UserNotifications

/*
 1. viewDidLoad에서 권한 요청 한다
 2. datePicker()에서 선택한 시간을 별도의 시, 분 변수에 담아둔다
 3. btnPush()에서 UNMutableNotificationContent() 통해 전달할 메시지를 설정한다
 4. btnPush()에서 DateComponents() 시간 변수를 트리거로 묶어 알람 요청한다
 5. 그러면 트리거가 알아서 지정 시간에 알람을 보내준다
 6. extension을 통해 앱 내부에서도 알람을 받을 수 있다
 */

class PushPageViewController: UIViewController {
    
    @IBOutlet weak var btnPush: UIButton!
    
    var hour: String?
    var minute: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 버튼 라운드
        btnPush.layer.cornerRadius = 4

        // MARK: option에 원하는 옵션 / 마크 신기, 강조된다
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert], completionHandler: {(didAllow, Error) in
            print("Authorization : \(didAllow)") // 권한 여부
        })
        
        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func datePicker(_ sender: UIDatePicker) {
        let pickedDate = sender // 별도의 변수에 저장 받아야 하단부 기능이 정상 작동
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"

        let strTime = (formatter.string(from: pickedDate.date).split(separator: ":"))

        hour = String(strTime[0])
        minute = String(strTime[1])
        
    }
    
    @IBAction func btnPush(_ sender: UIButton) {
        // Setting content of the notification
        if hour != nil, minute !=  nil {
            let content = UNMutableNotificationContent()
            content.title = "Emoda"
            content.subtitle = "How was your day?"
            content.body = "Do write about your emotion!"

            // Setting time for notification trigger
            var dateComponents = DateComponents()
            dateComponents.hour = Int(hour!)
            dateComponents.minute = Int(minute!)
 
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
    /*
            Trigger의 두 유형에 대해 필요 시 조사
            1. Use UNCalendarNotificationTrigger // 이번에 사용한 방법
            2. Use TimeIntervalNotificationTrigger
        
            Apple은 블로그 내용에 따르면 총 4개의 트리거를 제공
    */
            // Adding Request
            // identifier는 알람이 많아질 경우 식별하기 위해 사용하는 것으로 보임
            let request = UNNotificationRequest(identifier: "done", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            
            let alert = UIAlertController(title: "알림", message: "알람이 설정되었습니다.", preferredStyle: UIAlertController.Style.alert)
            let alertAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: {ACTION in
                self.navigationController?.popViewController(animated: true)
            })
                       alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "알림", message: "시간을 설정해주세요.", preferredStyle: UIAlertController.Style.alert)
            let alertAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension MainPageViewController: UNUserNotificationCenterDelegate {
     // To display notifications when app is running inforeground
     // viewDidLoad()에 UNUserNotificationCenter.current().delegate = self 추가
     func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
         completionHandler([.alert])
     }
     
     func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
         let settingsViewController = UIViewController()
         settingsViewController.view.backgroundColor = .gray
         self.present(settingsViewController, animated: true, completion: nil)
     }
    
 }
