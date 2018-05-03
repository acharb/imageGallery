//
//  GallerySelectTableViewCell.swift
//  imageGallery
//
//  Created by Alec Charbonneau on 3/1/18.
//  Copyright © 2018 Alec Charbonneau. All rights reserved.
//

import UIKit

class GallerySelectTableViewCell: UITableViewCell, UITextFieldDelegate {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var textField: UITextField!
        {
        didSet(newValue){
            textField.delegate = self
        }
    }
    
    var oldTextString: String?
    
    var tableViewController: ImageSelectorTableViewController?
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.isUserInteractionEnabled = false
        
        //update model with new name
        
        let textString = self.textField.text
        
        if let tvc = self.tableViewController{
            let gallery = tvc.model.galleries.remove(at: tvc.model.galleries.index(forKey: oldTextString!)!)
            
            tvc.model.galleries[textString!] = gallery.value
        }

        return true
    }
    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
//        self.textField.
    }

}
