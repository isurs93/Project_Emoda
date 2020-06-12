//
//  MapPageViewController.swift
//  Emoda
//
//  Created by Piano on 2020/03/18.
//  Copyright © 2020 Piano. All rights reserved.
//

import UIKit
import MapKit // MapKit 사용하려면 필요
import CoreLocation // 자신의 위치를 조회하기 위해서 필요

// 지도 추가 관련 초기 설정 ReadMe 참조
class MapPageViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, MySQLForMapPageModelProtocol {
    // 빠른 구현을 위해 서브 팝업 창을 활용하지 않고 맵 킷 하단부 공간활용 함 추후 활용하기 위해 주석 처리
    // =========================== Map Extra Popup Page Setting =========================== //
    // =========================== Map Extra Popup Page Setting =========================== //
    // =========================== Map Extra Popup Page Setting =========================== //
    // =========================== Map Extra Popup Page Setting =========================== //
    // =========================== Map Extra Popup Page Setting =========================== //
/*
    // 대박 enum 뭔지는 모르겠지만 열리고 닫힘을 알려주는 것인가 보다
    enum CardState {
        case expanded
        case collapsed
    }

    var cardViewController:CardViewController!
    var visualEffectView:UIVisualEffectView!

    let cardHeight:CGFloat = 200 // 카드 본체의 높이
    let cardHandleAreaHeight:CGFloat = 40 // 핸들러의 높이

    var cardVisible = false // 카드 접혀있는 상태 조건에 따라 하단 반전
    var nextState:CardState {
        return cardVisible ? .collapsed : .expanded
    }

    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted:CGFloat = 0 // 확인 안해봄
*/
    // =========================== Map Extra Popup Page Setting =========================== //
    // =========================== Map Extra Popup Page Setting =========================== //
    // =========================== Map Extra Popup Page Setting =========================== //
    // =========================== Map Extra Popup Page Setting =========================== //
    // =========================== Map Extra Popup Page Setting =========================== //
    
    // 실제 활용될 클래스 내부 기능은 이곳 필드부터
    var feedItem: NSArray = NSArray()
    var dbformappage = [DBForMapPage]()
    var userInfo_Email = ""
    
    let locationManager = CLLocationManager() // Location 관련 기능을 담은 클래스 받아오기
    
    @IBOutlet weak var mapViewForDiary: MKMapView!
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var labelLogin: UILabel!
    @IBOutlet weak var btnMore: UIButton!
    
    var timer = Timer()
    let timeSelector: Selector = #selector(MapPageViewController.updateMyLocation)
    var interval = 180.0
    
//    var strLog = "mapViewForDiary"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 버튼 둥굴게
        btnMore.layer.cornerRadius = 4
        
//        strLog += " > viewDidLoad"
//        print(strLog)
        
        timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: timeSelector, userInfo: nil, repeats: true)
        
        // 지도 관련 권한 및 초기 세팅
        locationManager.delegate = self // delegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // 지도의 정확도를 최고로 설정
        locationManager.requestWhenInUseAuthorization() // 위치 데이터를 확인하기 위해 권한 요청

        // 초기 이메일 값은 자신의 ID
        userInfo_Email = userInfo[0].userInfo_Email!
        
        // 내 위치 실시간 업로드
        updateMyLocation()
        
        // MySQL userInfo 조회
        let mysqlformappagemodel = MySQLForMapPageModel()
        mysqlformappagemodel.delegate = self
        mysqlformappagemodel.downloadItems()

        // 서브 팝업 뷰 만들어주는 기능의 시작
        //setupCard()
        
        // Do any additional setup after loading the view.
    }
 
    func itemDownloaded(items: NSArray) {
        
//        strLog += " > itemDownloaded"
//        print(strLog)
        
        feedItem = items
        
        // 유저 위치 표시
        printPin()
        
        // 나의 위치 표시
        locationManager.startUpdatingLocation() // 위치 업데이트 시작
        mapViewForDiary.showsUserLocation = true // 자신의 위치를 포인팅
        
        // 라벨 초기 세팅
        labelName.text = "\(userInfo[0].userInfo_Nickname!)"
        labelLogin.text = "\(feedItem.count)"
    }
    
    // 재 조회
    override func viewWillAppear(_ animated: Bool) {
        
//        strLog += " > viewWillAppear"
//        print(strLog)
        
        let mysqlformappagemodel = MySQLForMapPageModel()
        mysqlformappagemodel.delegate = self
        mysqlformappagemodel.downloadItems()
    }
    
    // MapKit의 Function 지도 상의 Location 클릭 시 did Select 작동
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // mapView 사용 방법
        // locationManager.location?.coordinate // 사용자의 현재 위치 출력
        // view.annotation?.coordinate // 위도 경도
        // view.annotation?.coordinate.latitude
        // view.annotation?.coordinate.longitude
        // view.annotation?.title // pin 타이틀 가져오기
        
        // 나의 핀을 선택 시 프로그램 전역 변수인 userInfo_Id를 표시하고 그렇지 않으면 해당 핀의 닉네임을 가져 옴
        let name = ((view.annotation?.title)! != "My Location") ? view.annotation?.title : "\(userInfo[0].userInfo_Nickname!)"
        labelName.text = name as? String
        // CLLocation으로 위도 경도를 묶어주고 GLGeocoder를 통해 위도 경도를 주소로 변환
        textLocation(location: CLLocation(latitude: (view.annotation?.coordinate.latitude)!, longitude: (view.annotation?.coordinate.longitude)!))
        for i in 0..<dbformappage.count {
            if dbformappage[i].userInfo_Nickname == name {
                userInfo_Email = dbformappage[i].userInfo_Email!
            }
        }
                
    }
    
    // 원하는 위도와 경도의 지도 띄우기
    // 위도와 경도에 대한 함수
    func goLocation(latitudeValue: CLLocationDegrees, longtitudeValue: CLLocationDegrees, delta span: Double) -> CLLocationCoordinate2D {
        
//        strLog += " > goLocation"
//        print(strLog)
        
        let pLocation = CLLocationCoordinate2DMake(latitudeValue, longtitudeValue)
        let spanValue = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        let pRegion = MKCoordinateRegion(center: pLocation, span: spanValue)
        mapViewForDiary.setRegion(pRegion, animated: true)
        
        return pLocation
    }
    
    // Pin 만들기 // CLLocationDegrees 좌표 값, delta span 범위
    func setAnnotation(latitudeValue: CLLocationDegrees, longtitudeValue: CLLocationDegrees, delta span: Double, title strTitle: String, subTitle strSubTitle: String){
        
//        strLog += " > setAnnotation"
//        print(strLog)
        
        let annotation = MKPointAnnotation() // Pin 모양
        annotation.coordinate = goLocation(latitudeValue: latitudeValue, longtitudeValue: longtitudeValue, delta: span) // 위치 찾아서 그림 그려주는 아이
        annotation.title = strTitle // 제목
        annotation.subtitle = strSubTitle // 내용
        mapViewForDiary.addAnnotation(annotation)
    }
    
    // 위치가 변경되었을때 지도의 정보를 표시하는 함수
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
//        strLog += " > locationManager"
//        print(strLog)
        
        let pLocation = locations.last // 마지막 지점 받네
        _ = goLocation(latitudeValue: (pLocation?.coordinate.latitude)!, longtitudeValue: (pLocation?.coordinate.longitude)!, delta: 0.01) // func의 리턴값을 받을 필요가 없는 경우 _ = 으로 받아준다 // 지도 위치만 찍어주고 반환받지 않는 것으로 보임
        textLocation(location: pLocation!)
        locationManager.stopUpdatingLocation() // 다 쓰고 이제 계속 업데이팅 해봐야 배터리만 나가니까 멈춰주는 거라고 구글에서 나옴
        
    }
    
    // 사용자의 현재 위치 출력
    func textLocation(location: CLLocation) {
        
//        strLog += " > textLocation"
//        print(strLog)
        
        let locale = Locale(identifier: "en_US")
        CLGeocoder().reverseGeocodeLocation(location, preferredLocale: locale, completionHandler: {(placemarks, erro) -> Void in
            let pm = placemarks!.first
            let country = pm!.country
            var address: String = country!
            
            if pm!.locality != nil { // 지역주소
                address += " "
                address += pm!.locality!
            }
            
            if pm!.thoroughfare != nil { // 도로명 주소
                address += " "
                address += pm!.thoroughfare!
            }
            
            self.labelAddress.text = "\(address)"
            
        })
    }
    
    // 여러 유저의 위치를 조회되는 크기만큼 반복해서 표시
    func printPin(){
        
//        strLog += " > textLocation"
//        print(strLog)
        
        dbformappage.removeAll()
        
        for index in 0..<feedItem.count{
            
            let item: DBForMapPage = feedItem[index] as! DBForMapPage
            
            let userInfo_Email = String(item.userInfo_Email!)
            let userInfo_Nickname = String(item.userInfo_Nickname!)
            let userInfo_Latitude = Double(item.userInfo_Latitude!)
            let userInfo_Longtitude = Double(item.userInfo_Longtitude!)
            
            dbformappage.append(DBForMapPage(userInfo_Email: userInfo_Email, userInfo_Nickname: userInfo_Nickname, userInfo_Latitude: userInfo_Latitude, userInfo_Longtitude: userInfo_Longtitude))
            
            setAnnotation(latitudeValue: userInfo_Latitude, longtitudeValue: userInfo_Longtitude, delta: 0.01, title: "\(userInfo_Nickname)", subTitle: "")

        }
    }
 
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "btnMore"{
            let othersPageTableView = segue.destination as! OthersPageTableViewController // 위임 받음
            othersPageTableView.receivedItem(userInfo_Email: userInfo_Email)
        }
    }
    
    // 타이머를 통해 현재 위치를 지속적으로 업데이트
    @objc func updateMyLocation(){
        let mysqlformappage = MySQLForMapPageModel()
        let latitude = locationManager.location?.coordinate.latitude
        let longtitude = locationManager.location?.coordinate.longitude
        mysqlformappage.updataLocation(userInfo_Email: userInfo[0].userInfo_Email!, userInfo_Latitude: latitude!, userInfo_Longitude: longtitude!)
    }

    // =========================== Map Extra Popup Page Setting =========================== //
    // =========================== Map Extra Popup Page Setting =========================== //
    // =========================== Map Extra Popup Page Setting =========================== //
    // =========================== Map Extra Popup Page Setting =========================== //
    // =========================== Map Extra Popup Page Setting =========================== //
/*
    func setupCard() { // 초기 세팅 해줌
        visualEffectView = UIVisualEffectView()
        visualEffectView.frame = self.view.frame
        self.view.addSubview(visualEffectView)
        
        // 확인 않았지만 화면 내에 서브의 어떤 형태로 만들어주는 효과 주는 것인 듯
        cardViewController = CardViewController(nibName:"CardViewController", bundle:nil)
        self.addChild(cardViewController)
        self.view.addSubview(cardViewController.view) // 화면 본체
        
        // 프레임 크기 세팅인 듯
        cardViewController.view.frame = CGRect(x: 0, y: self.view.frame.height - cardHandleAreaHeight, width: self.view.bounds.width, height: cardHeight)
      
        // 뷰 테두리를 둥글게
        cardViewController.view.clipsToBounds = false
        
        // ==================================== 제스처 기능 ==================================== //
        // ==================================== 제스처 기능 ==================================== //
        // ==================================== 제스처 기능 ==================================== //
        
        // 제스처 인지하는 녀셕이래
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MapPageViewController.handleCardTap(recognzier:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(MapPageViewController.handleCardPan(recognizer:)))
        
        // 내가 만든 Sub 화면에 제스터 값을 던져 주는 것
        cardViewController.handlerArea.addGestureRecognizer(tapGestureRecognizer)
        cardViewController.handlerArea.addGestureRecognizer(panGestureRecognizer)
    
        // 상단 제스처 받는 녀석 응용해서 버튼 클릭 시 액션 기능 추가
        let btnGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MapPageViewController.btnToDiaryPage(recognizer:)))
        cardViewController.btnMove.addGestureRecognizer(btnGestureRecognizer)
        
        // ==================================== 제스처 기능 ==================================== //
        // ==================================== 제스처 기능 ==================================== //
        // ==================================== 제스처 기능 ==================================== //
        
    }
    
    // Popup View의 버튼 액션
    @objc
    func btnToDiaryPage(recognizer:UITapGestureRecognizer) {
        let identifier = ""
        guard let uvc = self.storyboard?.instantiateViewController(withIdentifier: identifier) else{
            return
        }
        
        // 화면 전환 애니메이션을 설정
        // uvc.modalPresentationStyle = .fullScreen
        uvc.modalTransitionStyle = .coverVertical
        
        // 인자값으로 다음 뷰 컨트롤러를 넣고 present 메소드를 호출
        self.present(uvc, animated: true)
        
    }

    // 상단 제스처 인지를 돕는 녀석의 매소드
    @objc
    func handleCardTap(recognzier:UITapGestureRecognizer) {
        switch recognzier.state {
        case .ended:
            animateTransitionIfNeeded(state: nextState, duration: 0.9) // duration 초 단위는 아니고 바꾸면 핸들러 클릭시 뷰가 올라오고 내려가는 속도가 조절됨
        default:
            break
        }
    }
    
    // 상단 제스처 인지를 돕는 녀석의 매소드
    @objc
    func handleCardPan (recognizer:UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            startInteractiveTransition(state: nextState, duration: 0.9)
        case .changed:
            let translation = recognizer.translation(in: self.cardViewController.handlerArea)
            var fractionComplete = translation.y / cardHeight
            fractionComplete = cardVisible ? fractionComplete : -fractionComplete
            updateInteractiveTransition(fractionCompleted: fractionComplete)
        case .ended:
            continueInteractiveTransition()
        default:
            break
        }
    }
    
    // 보이고 안보이고 등의 여러 애니메이션 효과를 runningAnimations 바구니에 담아 구동 정도로 이해하면 될 듯
    func animateTransitionIfNeeded (state:CardState, duration:TimeInterval) {
        if runningAnimations.isEmpty { // 상단 전역 변수 CardState 여기서 열고 닫기 처리하는 것으로 보임
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.cardViewController.view.frame.origin.y = self.view.frame.height - self.cardHeight
                case .collapsed:
                    self.cardViewController.view.frame.origin.y = self.view.frame.height - self.cardHandleAreaHeight
                }
            }
            
            frameAnimator.addCompletion { _ in // 완료 시 변수 Bool 값 반대로
                self.cardVisible = !self.cardVisible
                self.runningAnimations.removeAll() // 위 method에서 받은 처리 값 삭제
            }
            
            frameAnimator.startAnimation()
            runningAnimations.append(frameAnimator) // 위 method에서 받은 값 추가
            
            // 가장자리가 둥근 정도
            let cornerRadiusAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
                switch state {
                case .expanded:
                    self.cardViewController.view.layer.cornerRadius = 0 // 보조 페이지 가장자리의 둥근 정도
                case .collapsed:
                    self.cardViewController.view.layer.cornerRadius = 0 // 위와 같은데 닫혀있을 때
                }
            }

            cornerRadiusAnimator.startAnimation()
            runningAnimations.append(cornerRadiusAnimator)
            
            // 오 이건 블러 효과 필요 시 사용
            let blurAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.visualEffectView.effect = UIBlurEffect(style: .systemChromeMaterial)
                case .collapsed:
                    self.visualEffectView.effect = nil
                }
            }

            blurAnimator.startAnimation()
            runningAnimations.append(blurAnimator)
            
        }
    }
    
    // 기능 제거 시 화면을 끌어서 올리거나 내릴 수 없음
    func startInteractiveTransition(state:CardState, duration:TimeInterval) {
        if runningAnimations.isEmpty {
            animateTransitionIfNeeded(state: state, duration: duration)
        }
        for animator in runningAnimations {
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
        }
    }
    
    // 기능 제거 시 화면을 끌어서 올리거나 내릴 수 없음
    func updateInteractiveTransition(fractionCompleted:CGFloat) {
        for animator in runningAnimations {
            animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
        }
    }
    
    // 기능 제거 시 화면을 끌어서 올리거나 내릴 수 없음
    func continueInteractiveTransition (){
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
*/
    // =========================== Map Extra Popup Page Setting =========================== //
    // =========================== Map Extra Popup Page Setting =========================== //
    // =========================== Map Extra Popup Page Setting =========================== //
    // =========================== Map Extra Popup Page Setting =========================== //
    // =========================== Map Extra Popup Page Setting =========================== //

}
