//
//  ViewController.swift
//  BarChart
//
//  Created by Nguyen Vu Nhat Minh on 19/8/17.
//  Copyright © 2017 Nguyen Vu Nhat Minh. All rights reserved.
//

import UIKit

class StatisticsPageViewController: UIViewController {
    
    @IBOutlet weak var imageViewEmotionKing: UIImageView!
    @IBOutlet weak var labelMessage: UILabel!
    
    @IBOutlet weak var basicBarChart: BasicBarChart!
    
    // chart 항목의 수
    private let numEntry = emotionStatisticsTemp.count
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let dataEntries = generateDataEntries()
        basicBarChart.updateDataEntries(dataEntries: dataEntries, animated: false)
    }

    // 데이터를 받아 화면 만들어주는 기능
    func generateDataEntries() -> [DataEntry] {
        // Custom Color : #Color Literal
        let colors = [#colorLiteral(red: 0.6650223136, green: 0.7216776013, blue: 0.7302500606, alpha: 1), #colorLiteral(red: 0.7624815106, green: 0.8439856172, blue: 0.8153397441, alpha: 1), #colorLiteral(red: 0.9981295466, green: 0.721668601, blue: 0.6307073236, alpha: 1), #colorLiteral(red: 0.964186132, green: 0.8198686838, blue: 0.7684211135, alpha: 1), #colorLiteral(red: 0.6729319692, green: 0.7344418168, blue: 0.6848812699, alpha: 1), #colorLiteral(red: 0.3729856312, green: 0.5851404071, blue: 0.577994585, alpha: 1)]
        var result: [DataEntry] = []
        var max = 0
        
        for i in 0..<numEntry {
            // value를 받아 높이를 만듦
            let value = emotionStatisticsTemp[i]
            let height: Float = Float(value) / 30
            
            if i > 0{
                if emotionStatisticsTemp[max] < emotionStatisticsTemp[i]{
                    max = i
                    labelMessage.text = "Your past days were usually '\(imageFileName[i])'"
                }
            }else {
                labelMessage.text = "Your past days were usually '\(imageFileName[i])'"
            }
            
            result.append(DataEntry(color: colors[i], height: height, textValue: "\(value)", title: imageFileName[i]))
        }
        imageViewEmotionKing.image = UIImage(named: imageFileName[max])
        return result
    }
}

