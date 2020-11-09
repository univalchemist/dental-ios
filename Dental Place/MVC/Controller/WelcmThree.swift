//
//  WelcmThree.swift
//  Dental Place
//
//  Created by eWeb on 12/03/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class WelcmThree: UIViewController
{

    @IBOutlet weak var nxt: UIButton!

  
   
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var DateText: UITextField!
    
    var firstName = ""
    
    var lastName = ""
    
    var gender = ""
    
    let datePicker = UIDatePicker()
    
    var selectedDate = ""
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
       
        self.DateText.layer.cornerRadius = 6
        self.DateText.layer.borderWidth = 1
        self.DateText.layer.borderColor = UIColor(red: 193/255.0, green: 206/255.0, blue: 218/255.0, alpha: 1).cgColor
        self.nxt.layer.cornerRadius = 6
        self.backBtn.layer.cornerRadius = 6
        self.backBtn.layer.borderWidth = 1
        self.backBtn.layer.borderColor = UIColor(red: 35/255.0, green: 166/255.0, blue: 152/255.0, alpha: 1).cgColor
        
    
        DateText.delegate = self
       
//        popupView.layer.shadowColor = UIColor.lightGray.cgColor
//        popupView.layer.shadowOpacity = 1
//        popupView.layer.shadowOffset = .zero
//        popupView.layer.shadowRadius = 3
        self.showDatePicker()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        IQKeyboardManager.shared.enableAutoToolbar = false
       // IQKeyboardManager.shared.sh = false
        //IQKeyboardManager.shared.shouldHidePreviousNext = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        IQKeyboardManager.shared.enableAutoToolbar = true
      //  IQKeyboardManager.shared.shouldShowTextFieldPlaceholder = true
      //  IQKeyboardManager.shared.shouldHidePreviousNext = true
    }
    
    
    
    
    
    
    func showDatePicker()
    {
        
        datePicker.datePickerMode = .date
        
       datePicker.setValue(CALENDERCOLOL, forKeyPath: "textColor")
        self.datePicker.setValue(true, forKey: "highlightsToday")

        
        datePicker.backgroundColor = UIColor.white
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -17, to: Date())
        
        datePicker.addTarget(self, action: #selector(dateChange), for: .valueChanged)
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        
        self.view.addGestureRecognizer(tapGesture)
        
       
        
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.bordered, target: self, action: #selector(WelcmThree.donedatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.bordered, target: self, action: #selector(WelcmThree
            .cancelDatePicker))
       // toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
       // DateText.inputAccessoryView = toolbar
        DateText.inputView = datePicker
    }
    
    
    @objc func viewTapped()
    {
         self.view.endEditing(true)
    }
    
    
    
    @objc func dateChange()
    {
        
        let formatter = DateFormatter()
        //formatter.dateFormat = "dd/MM/yyyy"
        formatter.dateFormat = "MMMM d yyyy"
        
        formatter.dateFormat = "MMMM d, yyyy"
        
        var dateSelected = formatter.string(from: datePicker.date)
        self.selectedDate = dateSelected
        DateText.text! = self.selectedDate //self.convertDateFormater(dateSelected)
        DEFAULT.set(self.selectedDate, forKey: "DATEOFBIRTH")

        DEFAULT.synchronize()
        
        self.view.endEditing(true)
    }
    
    
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        //formatter.dateFormat = "dd/MM/yyyy"
        formatter.dateFormat = "MMMM d yyyy"
        
        formatter.dateFormat = "MMMM d yyyy"
        
        let dateSelected = formatter.string(from: datePicker.date)
        self.selectedDate = dateSelected
        DateText.text! = self.selectedDate //self.convertDateFormater(dateSelected)
        DEFAULT.set(self.selectedDate, forKey: "DATEOFBIRTH")

        DEFAULT.synchronize()
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        
        self.nxt.isHidden = false
        self.view.endEditing(true)
    }
    @IBAction func pickDateBtn(_ sender: UIButton)
    {
//        self.popupView.isHidden = false
    }
    
    @IBAction func nextAct(_ sender: UIButton)
    {
        
        if self.selectedDate == ""
        {
            
            NetworkEngine.commonAlert(message: "Please select date of birth.", vc: self)
            
        }
        else
        {
            let wlcomeFour = self.storyboard?.instantiateViewController(withIdentifier: "wlcomeFour") as! wlcomeFour
           wlcomeFour.firstName = self.firstName
            wlcomeFour.lastName = self.lastName
             wlcomeFour.gender = self.gender
             wlcomeFour.dateOfBirth = self.selectedDate
            self.navigationController?.pushViewController(wlcomeFour, animated: true)
        }

        
        
        
        
        
    }
    
    @IBAction func backAct(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func skipAct(_ sender: UIButton)
    {
        let wlcomeFour = self.storyboard?.instantiateViewController(withIdentifier: "wlcomeFour") as! wlcomeFour
        self.navigationController?.pushViewController(wlcomeFour, animated: true)
        
    }
    
    @IBAction func pickerDone(_ sender: Any)
    {
       // self.popupView.isHidden = true
    }
    
    @IBAction func pickerCancel(_ sender: UIButton)
    {
       // self.popupView.isHidden = true
    }
    
}
extension WelcmThree:UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
         self.nxt.isHidden = true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
       self.nxt.isHidden = false
    }
}

