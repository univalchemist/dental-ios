//
//  BookAppointment.swift
//  Dental Place
//
//  Created by eWeb on 14/03/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import UIKit

class BookAppointment: UIViewController, UITableViewDataSource, UITableViewDelegate
{
   

    @IBOutlet weak var mapviewUi: UIView!
    @IBOutlet weak var listViewui: UIView!
    @IBOutlet weak var mapViewBtn: UIButton!
    @IBOutlet weak var listViewBtn: UIButton!
    
     @IBOutlet weak var filterSelectedBtn: UIButton!
    
    @IBOutlet weak var bookAppoitmentTable: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        bookAppoitmentTable.register(UINib(nibName: "BookAppoitmentTableCell", bundle: nil), forCellReuseIdentifier: "BookAppoitmentTableCell")
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookAppoitmentTableCell") as! BookAppoitmentTableCell
        cell.bookAppBtn.tag = indexPath.row
        cell.bookAppBtn.layer.cornerRadius = 12
        cell.bookAppBtn.addTarget(self, action: #selector(BookAction), for: .touchUpInside)
        
        return cell
    }
    @objc func BookAction(_ sender:UIButton)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 280
        
    }
}
