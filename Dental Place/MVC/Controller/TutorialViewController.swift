//
//  TutorialViewController.swift
//  Dental Place
//
//  Created by AMARENDRA on 13/05/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {
    @IBOutlet weak var CollectionView: UICollectionView!

    var currentIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor=UIColor.init(red: 107/255, green: 116/255, blue: 128/255, alpha: 1)
CollectionView.register(UINib(nibName: "TutFistPageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TutFistPageCollectionViewCell")
        
    }


}
extension TutorialViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
                    return 4
        

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TutFistPageCollectionViewCell", for: indexPath) as! TutFistPageCollectionViewCell
       // cell.getStartedBtn.isEnabled=false
        cell.getStartedBtn.tag=indexPath.row
          cell.skipBtn.addTarget(self, action: #selector(getStartAction), for: .touchUpInside)
        cell.getStartedBtn.addTarget(self, action: #selector(getStartAction), for: .touchUpInside)
        if self.currentIndex == 3
               {
                   cell.getStartedBtn.isEnabled=true
               }
               else
               {
                   cell.getStartedBtn.isEnabled=false

               }
                if indexPath.row == 0
        
                {
                    cell.image.image = UIImage(named: "tut1")//(named: "screen-1")
                }
                else if indexPath.row == 1
        
                {
                    cell.image.image = UIImage(named: "tut2")//(named: "Screen-2-iphone-x")
                }
                else if indexPath.row == 2
        
                {
                    cell.image.image = UIImage(named: "tut3")
                }
                else if indexPath.row == 3
        
                {
                    cell.image.image = UIImage(named: "tut4")
                }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        
        
         return CGSize(width: SCREENWIDTH, height: SCREENHEIGHT-((UIApplication.shared.statusBarFrame.height)+20))
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
                 return 0.00001
             }

             func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
                 return 0.000001
             }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TutFistPageCollectionViewCell", for: indexPath) as! TutFistPageCollectionViewCell
        print("visible cell = \(indexPath.row)")
       
    }
    @objc func getStartAction(_ sender:UIButton)
    {
        DEFAULT.set("yes", forKey: "GetStart")
        DEFAULT.synchronize()
        DEFAULT.removeObject(forKey: "START")
               DEFAULT.synchronize()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for cell in self.CollectionView.visibleCells
        {
            let indexPath = self.CollectionView.indexPath(for: cell)
            print(indexPath)
            self.currentIndex = indexPath?.row ?? 0
            self.CollectionView.reloadData()
        }
   }
}
