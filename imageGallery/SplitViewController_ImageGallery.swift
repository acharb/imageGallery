//
//  SplitViewController_ImageGallery.swift
//  imageGallery
//
//  Created by Alec Charbonneau on 2/1/18.
//  Copyright © 2018 Alec Charbonneau. All rights reserved.
//

import UIKit

class SplitViewController_ImageGallery: UISplitViewController {

    var model = ModelImageGallery()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
//        if let detailVC = segue.destination as? ImageCollectionViewController {
//            if segue.identifier == "Show Detail"{
//                detailVC.model = self.model
//            }
//        }
        
        
    }
    

}
