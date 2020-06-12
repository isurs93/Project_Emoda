//
//  OthersPageTableViewController.swift
//  Emoda
//
//  Created by Piano on 2020/03/21.
//  Copyright © 2020 Piano. All rights reserved.
//

import UIKit

// 아주 간단한 페이지야 앞선 페이지로부터 이메일 받아서 JSP로 날리고 이메일 값을 기준으로 공유된 일기 전체를 불러와 리스트화 시키는 거야
class OthersPageTableViewController: UITableViewController, MySQLForOthersPageModelProtocol {
    
    @IBOutlet var tableViewOthers: UITableView!
    
    var userInfo_Email = ""
    var feedItem: NSArray = NSArray()
    var diaryList = [DBForOthersPage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // cell의 높이
        tableView.rowHeight = 68
        
        let mysqlforotherspagemodel = MySQLForOthersPageModel()
        mysqlforotherspagemodel.delegate = self
        mysqlforotherspagemodel.downloadItems(userInfo_Email: userInfo_Email)
                
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    // 한 컨텐츠를 몇개씩 보여줄래
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    // 테이블 뷰에 총 몇개 보여줄래
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return feedItem.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "diaryCell", for: indexPath) as! OthersPageTableViewCell // myCell에 TableViewCell을 쓰겠다고 알려주는 것 as! 셀 이름
        let item: DBForOthersPage = feedItem[indexPath.row] as! DBForOthersPage
        cell.imageViewEmotion?.image = UIImage(named: "\(imageFileName[item.diary_Emotion!])")
        cell.labelDate?.text = "\(item.diary_Date!)"
        cell.labelTitle?.text = "\(item.diary_Title!)"
        
        // Configure the cell...

        return cell
    }
    
    func receivedItem(userInfo_Email: String){
        self.userInfo_Email = userInfo_Email
    }
    
    func itemDownloaded(items: NSArray) {
        feedItem = items
        
        diaryList.removeAll()
        for i in 0..<feedItem.count {
            
            let item: DBForOthersPage = feedItem[i] as! DBForOthersPage
            
            let diary_Seq = item.diary_Seq!
            let userInfo_Email = item.userInfo_Email!
            let diary_Emotion = item.diary_Emotion!
            let diary_Title = item.diary_Title!
            let diary_Contents = item.diary_Contents!
            let diary_Date = item.diary_Date!
            
            diaryList.append(DBForOthersPage(diary_Seq: diary_Seq, userInfo_Email: userInfo_Email, diary_Emotion: diary_Emotion, diary_Title: diary_Title, diary_Contents: diary_Contents, diary_Date: diary_Date))
            
        }
        
        tableViewOthers.reloadData()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let cell = sender as! UITableViewCell
        let indexPath = self.tableViewOthers.indexPath(for: cell)

        let diaryPageView = segue.destination as! DiaryPageViewController // 위임 받음

        let item: DBForOthersPage = diaryList[(indexPath! as NSIndexPath).row]

        // 아이템을 가져와서 하나씩 아래에 받아줌
        let diary_Seq = item.diary_Seq!
        let userInfo_Email = item.userInfo_Email!
        let diary_Emotion = item.diary_Emotion!
        let diary_Title = item.diary_Title!
        let diary_Contents = item.diary_Contents!
        let diary_Date = item.diary_Date!

        diaryPageView.receivedItems(diary_Seq, userInfo_Email, diary_Emotion, diary_Title, diary_Contents, diary_Date)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

}
