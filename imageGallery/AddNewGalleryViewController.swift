//
//  AddNewGalleryViewController.swift
//  imageGallery
//
//  Created by Alec Charbonneau on 1/29/18.
//  Copyright © 2018 Alec Charbonneau. All rights reserved.
//

import UIKit

class AddNewGalleryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var galleryNameTextField: UITextField!
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Unwind To Table" {
            if let newGallery = galleryNameTextField.text {
                if let tableVC = segue.destination as? ImageSelectorTableViewController {
                    let newIndexPath = IndexPath(row: tableVC.model.galleryNames[0].count, section:0)
                    tableVC.model.galleryNames[0].append(newGallery)
                    tableVC.tableView.insertRows(at: [newIndexPath], with: .automatic)
                }
            }
        }
    }
    
    
}
