//
//  AppointmentHistoryViewController.swift
//  Dental Place
//
//  Created by eWeb on 17/03/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import UIKit

class AppointmentHistoryViewController: UIViewController
{
@IBOutlet weak var historytable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
 historytable.register(UINib(nibName: "HistoryTableCell", bundle: nil), forCellReuseIdentifier: "HistoryTableCell")
    }
    

}
extension AppointmentHistoryViewController:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 4
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 246
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableCell") as! HistoryTableCell
        
        cell.ratePopup.isHidden = true
        cell.allReviewPopup.isHidden = true
        cell.uiview.layer.cornerRadius = 8
        cell.uiview.layer.shadowColor = UIColor.lightGray.cgColor
        cell.uiview.layer.shadowOpacity = 1
        cell.uiview.layer.shadowOffset = .zero
        cell.uiview.layer.shadowRadius = 3
        
        if indexPath.row == 0
        {
            cell.ratePopup.isHidden = true
            cell.allReviewPopup.isHidden = true
        }
        else if indexPath.row == 1
        {
            cell.ratePopup.isHidden = false
            cell.allReviewPopup.isHidden = true
            cell.rateBtn.tag = indexPath.row
            cell.rateBtn.layer.cornerRadius = 6
            cell.rateBtn.addTarget(self, action: #selector(rateBtnAct(_:)), for: .touchUpInside)
            
        }
        else if indexPath.row == 2
        {
            cell.ratePopup.isHidden = true
            cell.allReviewPopup.isHidden = false
            cell.allReviewBtn.tag = indexPath.row
            cell.allReviewBtn.layer.cornerRadius = 6
            cell.allReviewBtn.addTarget(self, action: #selector(AllComment(_:)), for: .touchUpInside)
        }
        else if indexPath.row == 3
        {
            cell.allReviewPopup.isHidden = true
            cell.ratePopup.isHidden = true
        }
        
        return cell
    }
    
    @objc func rateBtnAct(_ sender: UIButton)
    {
        let RatingViewController = self.storyboard?.instantiateViewController(withIdentifier: "RatingViewController") as! RatingViewController
        self.navigationController?.pushViewController(RatingViewController, animated: true)
        
    }
    @objc func AllComment(_ sender: UIButton)
    {
        let AllComments = self.storyboard?.instantiateViewController(withIdentifier: "AllComments") as! AllComments
        self.navigationController?.pushViewController(AllComments, animated: true)
        
    }
}
