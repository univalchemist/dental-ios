//
//  SecondTab.swift
//  Dental Place
//
//  Created by eWeb on 12/03/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import UIKit

class SecondTab: UIViewController,  UITableViewDataSource, UITableViewDelegate
{
    
    @IBOutlet weak var rescPopup: UIView!
    @IBOutlet weak var blackREscPopup: UIView!
    @IBOutlet weak var bookAppoitmentPopUp: UIView!
    @IBOutlet weak var bookAppoinmnt: UIButton!
    @IBOutlet weak var mainRoundView: UIView!
    @IBOutlet weak var histryView: UIView!
    @IBOutlet weak var appoinView: UIView!
    @IBOutlet weak var appointmntBtn: UIButton!
    @IBOutlet weak var histryBtn: UIButton!
    @IBOutlet weak var historyPopup: UIView!
    @IBOutlet weak var historytable: UITableView!
    
    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        blackREscPopup.isHidden = true
        bookAppoitmentPopUp.isHidden = true
        historyPopup.isHidden = true
        
        rescPopup.layer.cornerRadius = 8
        rescPopup.layer.shadowColor = UIColor.lightGray.cgColor
        rescPopup.layer.shadowOpacity = 1
        rescPopup.layer.shadowOffset = .zero
        rescPopup.layer.shadowRadius = 3
        
        bookAppoitmentPopUp.layer.cornerRadius = 8
        bookAppoitmentPopUp.layer.shadowColor = UIColor.lightGray.cgColor
        bookAppoitmentPopUp.layer.shadowOpacity = 1
        bookAppoitmentPopUp.layer.shadowOffset = .zero
        bookAppoitmentPopUp.layer.shadowRadius = 3
        
        bookAppoinmnt.layer.cornerRadius = 6
        historytable.register(UINib(nibName: "HistoryTableCell", bundle: nil), forCellReuseIdentifier: "HistoryTableCell")
        
        self.mainRoundView.layer.cornerRadius = 8
        mainRoundView.layer.shadowColor = UIColor.lightGray.cgColor
        mainRoundView.layer.shadowOpacity = 1
        mainRoundView.layer.shadowOffset = .zero
        mainRoundView.layer.shadowRadius = 3
        
        histryBtn.setTitleColor(UIColor(red: 0/255.0, green: 106/255.0, blue: 160/255.0, alpha: 1), for: .normal)
        histryView.backgroundColor = UIColor(red: 0/255.0, green: 106/255.0, blue: 160/255.0, alpha: 1)
        
        appointmntBtn.setTitleColor(UIColor(red: 32/255.0, green: 156/255.0, blue: 141/255.0, alpha: 1), for: .normal)
        appoinView.backgroundColor = UIColor(red: 32/255.0, green: 156/255.0, blue: 141/255.0, alpha: 1)
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
     
     
    }
    @IBAction func ThreeDotAct(_ sender: UIButton)
    {
        blackREscPopup.isHidden = false
        
        bookAppoitmentPopUp.isHidden = true
        historyPopup.isHidden = true
    }
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
        var RatingViewController = self.storyboard?.instantiateViewController(withIdentifier: "RatingViewController") as! RatingViewController
        self.navigationController?.pushViewController(RatingViewController, animated: true)
        
    }
    @objc func AllComment(_ sender: UIButton)
    {
        var AllComments = self.storyboard?.instantiateViewController(withIdentifier: "AllComments") as! AllComments
        self.navigationController?.pushViewController(AllComments, animated: true)
        
    }
    @IBAction func historyButton(_ sender: Any)
    {
        historyPopup.isHidden = false
       
        bookAppoitmentPopUp.isHidden = true
        
        
        appointmntBtn.setTitleColor(UIColor(red: 0/255.0, green: 106/255.0, blue: 160/255.0, alpha: 1), for: .normal)
        appoinView.backgroundColor = UIColor(red: 0/255.0, green: 106/255.0, blue: 160/255.0, alpha: 1)
        
        histryBtn.setTitleColor(UIColor(red: 32/255.0, green: 156/255.0, blue: 141/255.0, alpha: 1), for: .normal)
        histryView.backgroundColor = UIColor(red: 32/255.0, green: 156/255.0, blue: 141/255.0, alpha: 1)
    }
    @IBAction func AppointmentAct(_ sender: Any)
    {
        historyPopup.isHidden = true
      //  blackREscPopup.isHidden = true
        bookAppoitmentPopUp.isHidden = true
        
        histryBtn.setTitleColor(UIColor(red: 0/255.0, green: 106/255.0, blue: 160/255.0, alpha: 1), for: .normal)
        histryView.backgroundColor = UIColor(red: 0/255.0, green: 106/255.0, blue: 160/255.0, alpha: 1)
        
        appointmntBtn.setTitleColor(UIColor(red: 32/255.0, green: 156/255.0, blue: 141/255.0, alpha: 1), for: .normal)
        appoinView.backgroundColor = UIColor(red: 32/255.0, green: 156/255.0, blue: 141/255.0, alpha: 1)
    }
    @IBAction func bookAppAct(_ sender: UIButton)
    {
        bookAppoitmentPopUp.isHidden = false
        //blackREscPopup.isHidden = true
        historyPopup.isHidden = true
    }
    @IBAction func reschdule(_ sender: Any)
    {
        blackREscPopup.isHidden = true
        bookAppoitmentPopUp.isHidden = true
        historyPopup.isHidden = true
    }
    @IBAction func cancel(_ sender: Any)
    {
        blackREscPopup.isHidden = true
        bookAppoitmentPopUp.isHidden = true
        historyPopup.isHidden = true
    }
}

