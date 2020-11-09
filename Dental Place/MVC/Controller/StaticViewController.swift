//
//  StaticViewController.swift
//  Dental Place
//
//  Created by AMARENDRA on 17/04/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import UIKit
import SVProgressHUD

class StaticViewController: UIViewController,UIWebViewDelegate {

    @IBOutlet var titleLbl:UILabel!
    @IBOutlet var wbview:UIWebView!
    var loadUrl = "https://dentalplace.app/privacy-policy/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wbview.delegate=self
        
        if let load = URL(string: loadUrl) as? URL
        {
            self.wbview.loadRequest(URLRequest(url: load))
        }

        // Do any additional setup after loading the view.
    }
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(true)
        
         
         self.tabBarController?.tabBar.isHidden = true
     }
     
     override func viewWillDisappear(_ animated: Bool) {
         super.viewWillDisappear(true)
         self.tabBarController?.tabBar.isHidden = false
     }
    
    @IBAction func BookAppoitment(_ sender: UIButton)
           {
            self.navigationController?.popViewController(animated: true)
               
           }
      

}
