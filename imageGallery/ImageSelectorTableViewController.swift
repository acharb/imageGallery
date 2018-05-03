//
//  ImageSelectorTableViewController.swift
//  imageGallery
//
//  Created by Alec Charbonneau on 1/28/18.
//  Copyright © 2018 Alec Charbonneau. All rights reserved.
//

import UIKit

class ImageSelectorTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        
        
    }
    
   
    
    // MARK: - Table view data source

    var sectionNames: [String] = ["Galleries","Recently Deleted"]
    
    //lazy var galleryNames = model.galleryNames
    
    var model = ModelImageGallery()
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionNames.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.galleryNames[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "galleryNameTableCells", for: indexPath) as? GallerySelectTableViewCell {
            
            
            // Configure the cell...
            
            cell.textField.text? = model.galleryNames[indexPath.section][indexPath.row]
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(editText))
            tap.numberOfTapsRequired = 2
            cell.addGestureRecognizer(tap)
            //tap.cancelsTouchesInView = false
            
            return cell
        }
        let cell = GallerySelectTableViewCell()
        cell.textField.text = "Name not found"
        return cell
        
    }
    
    @objc func editText(_ sender: UITapGestureRecognizer){
        if sender.state == .ended {
            if let cell = sender.view as? GallerySelectTableViewCell {
                cell.textField.isUserInteractionEnabled = true
                print(cell.textField.canBecomeFirstResponder)
                cell.textField.becomeFirstResponder()
                print(cell.textField.isFirstResponder)
                
                // storing text before changing it
                cell.oldTextString = cell.textField.text
                cell.tableViewController = self
                
                print("double tapped")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionNames[section]
    }
    
    

    // MARK: Editing functions
    
//    //Override to support conditional editing of the table view.
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//
//        return true
//    }
    

    
    // Override to support editing the table view. // note: table view is the VIEW, not the VC
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let gallery = model.galleryNames[indexPath.section].remove(at: indexPath.item) // remove from gallery names array
            tableView.deleteRows(at: [indexPath], with: .fade) // remove from view
            
            
            if indexPath.section == 0 {                        // deleted from galleries section
                //add to data source recently deleted
                let newIndexPath = IndexPath(row: model.galleryNames[1].count, section: 1)
                model.galleryNames[newIndexPath.section].insert(gallery, at:newIndexPath.item)
                tableView.insertRows(at: [newIndexPath], with: .fade)
            } else if indexPath.section == 1 {                                  // remove permanetly from model
                self.model.galleries[gallery] = nil
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextAction = UIContextualAction(style: .normal, title: "Undelete"){ (action: UIContextualAction, sourceView: UIView, completionHandler:(Bool)-> Void) in
            
            if indexPath.section == 1 { // if in recently deleted section, then delete from there and add to gallery section
                
                //remove from recently deleted section
                let gallery = self.model.galleryNames[indexPath.section].remove(at: indexPath.item)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                //add to gallery section
                let newIndexPath = IndexPath(row: self.model.galleryNames[0].count, section: 0)
                self.model.galleryNames[newIndexPath.section].insert(gallery, at:newIndexPath.item)
                tableView.insertRows(at: [newIndexPath], with: .fade)
                
                //commit handler
                completionHandler(true)
                
            } else {
                completionHandler(false)
            }

        }
        contextAction.backgroundColor = UIColor.green
        let unswipe = UISwipeActionsConfiguration(actions: [contextAction])
        return unswipe
    }
    

    
    // Override to support rearranging the table view.
//    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
//
//    }
 

    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
 

    
    // MARK: - Navigation

    //unwind segue from addNewGallery view
    @IBAction func unwindToTable(segue: UIStoryboardSegue) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Show Gallery" {
            if let collectionVC = segue.destination.childViewControllers[0] as? ImageCollectionViewController {
                if let galleryName = (sender as? GallerySelectTableViewCell)?.textField.text {
                    if let images = self.model.galleries[galleryName] { // gallery name exists
                        collectionVC.setGallery(to: galleryName)
                        collectionVC.images = images
                    } else { // gallery doesn't exist, so adding to model
                        collectionVC.images = []
                        self.model.galleries[galleryName] = []
                    }
                }
            }
        }
    }
}
