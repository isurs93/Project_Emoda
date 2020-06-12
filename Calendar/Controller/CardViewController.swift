//
//  CardViewController.swift
//  CardViewAnimation
//
//  Created by Brian Advent on 26.10.18.
//  Copyright © 2018 Brian Advent. All rights reserved.
//

import UIKit

class CardViewController: UIViewController {

    // CardViewController.xib의 view outlet(name : handlerArea)을 연결만 하고 처리는 보여질 MapPageViewController에서 해당 페이지를 상속받아 처리됨
    @IBOutlet weak var handlerArea: UIView!
    @IBOutlet weak var btnMove: UIButton!
    
}
